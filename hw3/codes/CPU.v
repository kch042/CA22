`include "Adder.v"
`include "PC.v"
`include "Instruction_Memory.v"
`include "MUX32.v"
`include "Imm_Gen.v"
`include "Registers.v"
`include "Control.v"
`include "ALU.v"

module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

// PC
wire [31:0] pc; 
wire [31:0] next_pc;
parameter FOUR = 4;

Adder Add_PC(
    .data1_i    (pc),
    .data2_i    (FOUR),
    .data_o     (next_pc)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (next_pc),
    .pc_o       (pc)
);


// Instruction
wire [31:0] instruction;
Instruction_Memory Instruction_Memory(
    .addr_i     (pc), 
    .instr_o    (instruction)
);

// Reg
wire [31:0] rs1;
wire [31:0] rs2;

Registers Registers(
    .clk_i       (clk_i),
    .RS1addr_i   (instruction[19:15]),
    .RS2addr_i   (instruction[24:20]),
    .RDaddr_i    (instruction[11:7]), 
    .RDdata_i    (alu_out),
    .RegWrite_i  (regwrite),
    .RS1data_o   (rs1), 
    .RS2data_o   (rs2) 
);

wire regwrite;
wire alusrc;
wire [3:0] aluctrl;

Control Control(
    .opcode(instruction[6:0]), 
    .funct3(instruction[14:12]), 
    .funct7(instruction[31:25]), 
    .regwrite(regwrite), 
    .alusrc(alusrc), 
    .aluctrl(aluctrl)
);


wire [31:0] imm;
Imm_Gen Imm_Gen(
    .instruction(instruction),
    .imm(imm)
);

// select for second operand of alu
wire [31:0] m1;
wire [31:0] m2;
wire [31:0] m_out;

assign m1 = rs2;
assign m2 = imm;

MUX32 MUX_ALUSrc(
    .data1_i    (m1),
    .data2_i    (m2),
    .select_i   (alusrc),
    .data_o     (m_out)
);
  

// ALU
wire [31:0] alu_op1;
wire [31:0] alu_op2;
assign alu_op1 = rs1;
assign alu_op2 = m_out;

wire [31:0] alu_out;
wire is_zero;

ALU ALU(
    .op1        (alu_op1),
    .op2        (alu_op2),
    .aluctrl    (aluctrl),
    .result     (alu_out),
    .zero       (is_zero)
);


endmodule

