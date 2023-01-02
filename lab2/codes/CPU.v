module CPU(clk_i, rst_i);

input               clk_i;
input               rst_i;

/************ Wires to connect modules ***************/ 

//
// Some values are passed along pipeline until it's used.
// for example, rd_addr
// it will be obtained in ID stage, but will be used when in WB stage, 
// so we need a wire for each stage it pass
// -> rd_addr, rd_addr_exe, rd_addr_mem, rd_addr_wb
//

// PC
wire    [31:0]  pc, pc_id, pc_exe;   
wire    [31:0]  pc_plus_four, pc_predict_branch, pc_go_on, pc_rollback, next_pc;
wire            is_mispredict;
parameter       FOUR = 4;

// Instruction
wire    [31:0]  instruction, instruction_id;

// Register File
// Note: rs2_mem is used to write mem
// e.g. sw rs2 imm(rs1) -> mem[rs1+imm<<1] = rs2
wire    [31:0]  rs1, rs1_exe;
wire    [31:0]  rs2, rs2_exe, rs2_exe_forwarded, rs2_mem;
wire    [31:0]  imm, imm_exe;
wire    [4:0]   rs1_addr, rs1_addr_exe, rs2_addr, rs2_addr_exe;   
wire    [4:0]   rd_addr, rd_addr_exe, rd_addr_mem, rd_addr_wb;

// Branch Predictor
wire            branch_pred, branch_pred_exe;

// Control Signal
wire            alusrc, alusrc_exe;
wire    [3:0]   aluctrl, aluctrl_exe;
wire            branch_instr, branch_instr_exe;
wire            memread, memread_exe, memread_mem;
wire            memwrite, memwrite_exe, memwrite_mem;
wire            mem2reg, mem2reg_exe, mem2reg_mem, mem2reg_wb;
wire            regwrite, regwrite_exe, regwrite_mem, regwrite_wb;

// Hazard Detection (load-use hazard)
wire            noop, pcwrite, stall;

// ALU
wire    [1:0]   forwardA, forwardB;
wire    [31:0]  alu_op1, alu_op2;
wire            is_zero;
wire    [31:0]  alu_result, alu_result_mem, alu_result_wb;


// Mem
wire    [31:0]  mem_result, mem_result_wb;

// WB
wire    [31:0]  rd_data;

/*******************************************************/ 

// IF

Adder Add_PC(
    .data1_i    (pc),
    .data2_i    (FOUR),
    .data_o     (pc_plus_four)
);

Mux_2_way M2_Predict_Branch(
    .data1_i    (pc_plus_four),
    .data2_i    (pc_predict_branch),
    .select_i   (branch_pred & branch_instr),
    .data_o     (pc_go_on)
);

Mux_2_way M2_Recover_From_MisPrediction (
    .data1_i    (pc_go_on),
    .data2_i    (pc_rollback),
    .select_i   (is_mispredict),
    .data_o     (next_pc)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .PCWrite_i  (pcwrite),
    .pc_i       (next_pc),
    .pc_o       (pc)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc),
    .instr_o    (instruction)
);

IF_ID IF_ID(
    .clk            (clk_i),
    .instruction_in (instruction),
    .instruction_out(instruction_id),
    .pc_in          (pc),
    .pc_out         (pc_id),
    .stall          (stall),    
    .flush          (is_mispredict || (branch_pred && branch_instr))
);


/*******************************************************/ 

// ID

assign  rs1_addr =  instruction_id[19:15];
assign  rs2_addr =  instruction_id[24:20];
assign  rd_addr  =  instruction_id[11:7];

assign  pc_predict_branch = pc_id + (imm << 1);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i  (rs1_addr),
    .RS2addr_i  (rs2_addr),
    .RDaddr_i   (rd_addr_wb),           // be careful !
    .RDdata_i   (rd_data),
    .RegWrite_i (regwrite_wb),
    .RS1data_o  (rs1),
    .RS2data_o  (rs2)
);

Imm_Gen Imm_Gen(
    .instruction(instruction_id),
    .imm(imm)
);

Control Control(
    .opcode         (instruction_id[6:0]),
    .funct3         (instruction_id[14:12]),
    .funct7         (instruction_id[31:25]),
    .alusrc         (alusrc),
    .aluctrl        (aluctrl),
    .memread        (memread),
    .memwrite       (memwrite),
    .mem2reg        (mem2reg),
    .regwrite       (regwrite),
    .branch_instr   (branch_instr),
    .noop           (noop)
);

Hazard_Detection Hazard_Detection(
    .memread_exe    (memread_exe),
    .rd_addr_exe    (rd_addr_exe),
    .rs1_addr       (rs1_addr),
    .rs2_addr       (rs2_addr),
    .pcwrite        (pcwrite),
    .stall          (stall),
    .noop           (noop)
);

Branch_Predictor Branch_Predictor(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .update_i       (branch_instr_exe),
    .result_i       (is_zero),
    .predict_o      (branch_pred)
);

ID_EXE ID_EXE(
    .clk(clk_i), .flush(is_mispredict), 
    .rs1_in(rs1), .rs2_in(rs2), .rs1_addr_in(rs1_addr), .rs2_addr_in(rs2_addr), .rd_addr_in(rd_addr), .imm_in(imm), .aluctrl_in(aluctrl), .alusrc_in(alusrc), .memwrite_in(memwrite), .memread_in(memread), .mem2reg_in(mem2reg), .regwrite_in(regwrite),
    .rs1_out(rs1_exe), .rs2_out(rs2_exe), .rs1_addr_out(rs1_addr_exe), .rs2_addr_out(rs2_addr_exe), .rd_addr_out(rd_addr_exe), .imm_out(imm_exe), .aluctrl_out(aluctrl_exe), .alusrc_out(alusrc_exe), .memwrite_out(memwrite_exe), .memread_out(memread_exe), .mem2reg_out(mem2reg_exe), .regwrite_out(regwrite_exe),
    .pc_in(pc_id), 
    .branch_instr_in(branch_instr), 
    .branch_pred_in(branch_pred), 
    .pc_out(pc_exe), 
    .branch_instr_out(branch_instr_exe), 
    .branch_pred_out(branch_pred_exe)
);

/*******************************************************/ 

// EXE

Forwarding Forwarding(
    .rs1_addr_exe(rs1_addr_exe), .rs2_addr_exe(rs2_addr_exe),
    .rd_addr_mem(rd_addr_mem), .rd_addr_wb(rd_addr_wb),
    .regwrite_mem(regwrite_mem), .regwrite_wb(regwrite_wb),
    .forwardA(forwardA), .forwardB(forwardB)
);


parameter   [31:0]  dotcar = {31{1'b0}}; // don't care
Mux_4_way M4_ForwardA(
    .data1_i    (rs1_exe),
    .data2_i    (rd_data),
    .data3_i    (alu_result_mem),
    .data4_i    (dotcar),
    .select_i   (forwardA),
    .data_o     (alu_op1)
);
Mux_4_way M4_ForwardB(
    .data1_i    (rs2_exe),
    .data2_i    (rd_data),
    .data3_i    (alu_result_mem),
    .data4_i    (dotcar),
    .select_i   (forwardB),
    .data_o     (rs2_exe_forwarded)
);
Mux_2_way M2_ALU(
    .data1_i    (rs2_exe_forwarded),
    .data2_i    (imm_exe),
    .select_i   (alusrc_exe),
    .data_o     (alu_op2)
);


ALU ALU(
    .op1        (alu_op1),
    .op2        (alu_op2),
    .aluctrl    (aluctrl_exe),
    .result     (alu_result),
    .zero       (is_zero)
);

Control_Hazard_Detection Control_Hazard_Detection(
    .branch_instr_exe   (branch_instr_exe),
    .is_zero            (is_zero),
    .branch_pred_exe    (branch_pred_exe),
    .pc_exe             (pc_exe), 
    .imm_exe            (imm_exe),
    .is_mispredict      (is_mispredict),
    .pc_rollback        (pc_rollback)
);

// Be careful about sw
// We must pass the forwarded rs2 to write memory if necessary
EXE_MEM EXE_MEM(
    .clk(clk_i),
    .alu_result_in(alu_result), .memwrite_addr_in(rs2_exe_forwarded), .rd_addr_in(rd_addr_exe), .memread_in(memread_exe), .memwrite_in(memwrite_exe), .mem2reg_in(mem2reg_exe), .regwrite_in(regwrite_exe),
    .alu_result_out(alu_result_mem), .memwrite_addr_out(rs2_mem), .rd_addr_out(rd_addr_mem), .memread_out(memread_mem), .memwrite_out(memwrite_mem), .mem2reg_out(mem2reg_mem), .regwrite_out(regwrite_mem)
);

/*******************************************************/ 

// MEM

Data_Memory Data_Memory(
    .clk_i      (clk_i),
    .addr_i     (alu_result_mem),
    .MemRead_i  (memread_mem),
    .MemWrite_i (memwrite_mem),
    .data_i     (rs2_mem),
    .data_o     (mem_result)
);

MEM_WB MEM_WB(
    .clk(clk_i), 
    .mem2reg_in(mem2reg_mem), .regwrite_in(regwrite_mem), .rd_addr_in(rd_addr_mem), .alu_result_in(alu_result_mem), .mem_result_in(mem_result), 
    .mem2reg_out(mem2reg_wb), .regwrite_out(regwrite_wb), .rd_addr_out(rd_addr_wb), .alu_result_out(alu_result_wb), .mem_result_out(mem_result_wb)
);

/*******************************************************/ 

// WB
Mux_2_way M2_WB(
    .data1_i    (alu_result_wb),
    .data2_i    (mem_result_wb),
    .select_i   (mem2reg_wb),
    .data_o     (rd_data)
);


endmodule
