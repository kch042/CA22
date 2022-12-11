// Pipeline Latches
//
// When the clock ticks (i.e. @posedge),
// each stage will write the result of previous cycle to the pipeline latches for next stage.
// When all stages have completed writing (nonblocking write), it will read pipeline latches
// for itself then comsume 
//
// So here comes the important idea,
// each stage will write the data in, maybe the first half, of the cycle
// after which will it read data and process in the rest of the cycle.
//
// CLOCK CYLE
// --------------|_______________
//     WRITE       READ & PROCESS


module IF_ID (
    clk,
    instruction_in,
    instruction_out,
    pc_in, 
    pc_out,
    stall,      // load-use hazard
    flush       // branch hazard
);
    
input                   clk;
input           [31:0]  instruction_in, pc_in;
input                   stall, flush;
output  reg     [31:0]  instruction_out, pc_out;

always @(posedge clk) begin
    if (stall) begin
            instruction_out <=  instruction_out;
            pc_out          <=  pc_out;
    end
    else if (flush) begin
            instruction_out <=  0;
            pc_out          <=  0;   
    end
    else begin
            instruction_out <= instruction_in;
            pc_out          <= pc_in; 
    end
end

endmodule


module ID_EXE (
    clk, 
    rs1_in, rs2_in, rs1_addr_in, rs2_addr_in, rd_addr_in, imm_in, aluctrl_in, alusrc_in, memwrite_in, memread_in, mem2reg_in, regwrite_in,
    rs1_out, rs2_out, rs1_addr_out, rs2_addr_out, rd_addr_out, imm_out, aluctrl_out, alusrc_out, memwrite_out, memread_out, mem2reg_out, regwrite_out);

input           clk;
input           alusrc_in, memread_in, memwrite_in, mem2reg_in, regwrite_in;
input   [3:0]   aluctrl_in;
input   [4:0]   rs1_addr_in, rs2_addr_in, rd_addr_in;
input   [31:0]  rs1_in, rs2_in, imm_in;

output  reg             alusrc_out, memread_out, memwrite_out, mem2reg_out, regwrite_out;
output  reg     [3:0]   aluctrl_out;
output  reg     [4:0]   rs1_addr_out, rs2_addr_out,rd_addr_out;
output  reg     [31:0]  rs1_out, rs2_out, imm_out;


always @(posedge clk) begin
    rs1_out         <=  rs1_in;
    rs2_out         <=  rs2_in;
    rs1_addr_out    <=  rs1_addr_in;
    rs2_addr_out    <=  rs2_addr_in;
    rd_addr_out     <=  rd_addr_in;
    imm_out         <=  imm_in;

    alusrc_out      <=  alusrc_in;
    aluctrl_out     <=  aluctrl_in;
    memwrite_out    <=  memwrite_in;
    memread_out     <=  memread_in;
    mem2reg_out     <=  mem2reg_in;
    regwrite_out    <=  regwrite_in;
end

endmodule


module EXE_MEM (
    clk,
    alu_result_in, memwrite_addr_in, rd_addr_in, memread_in, memwrite_in, mem2reg_in, regwrite_in,
    alu_result_out, memwrite_addr_out, rd_addr_out, memread_out, memwrite_out, mem2reg_out, regwrite_out
);

input           clk;
input           memread_in, memwrite_in, mem2reg_in, regwrite_in;
input   [4:0]   rd_addr_in;
input   [31:0]  alu_result_in, memwrite_addr_in;

output  reg             memread_out, memwrite_out, mem2reg_out, regwrite_out;
output  reg     [4:0]   rd_addr_out;
output  reg     [31:0]  alu_result_out, memwrite_addr_out;

always @(posedge clk) begin
    memread_out         <=  memread_in;
    memwrite_out        <=  memwrite_in;
    mem2reg_out         <=  mem2reg_in;
    regwrite_out        <=  regwrite_in;

    memwrite_addr_out   <=  memwrite_addr_in;
    rd_addr_out         <=  rd_addr_in;
    alu_result_out      <=  alu_result_in;
end

endmodule


module MEM_WB (
    clk, 
    mem2reg_in, regwrite_in, rd_addr_in, alu_result_in, mem_result_in, 
    mem2reg_out, regwrite_out, rd_addr_out, alu_result_out, mem_result_out
);

input           clk;
input           mem2reg_in, regwrite_in;
input   [4:0]   rd_addr_in;
input   [31:0]  alu_result_in, mem_result_in;

output  reg        mem2reg_out, regwrite_out;
output  reg [4:0]   rd_addr_out;
output  reg [31:0]  alu_result_out, mem_result_out;

always @(posedge clk) begin
    mem2reg_out     <=  mem2reg_in;
    regwrite_out    <=  regwrite_in;
    rd_addr_out     <=  rd_addr_in;
    alu_result_out  <=  alu_result_in;
    mem_result_out  <=  mem_result_in;
end

endmodule