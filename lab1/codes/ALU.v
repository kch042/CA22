`include "Parameters.v"

module ALU(op1, op2, aluctrl, result, zero);

input   [31:0]  op1;
input   [31:0]  op2;
input   [3:0]   aluctrl;

output  [31:0]  result;
reg     [31:0]  result;

output zero;
assign zero = (op1 == op2);

wire    [4:0]   shamt;
assign shamt = op2[4:0]; 

always @(*) begin 
    case (aluctrl) 
        `ALU_AND: result = op1 & op2;
        `ALU_XOR: result = op1 ^ op2;
        `ALU_ADD: result = op1 + op2;
        `ALU_SUB: result = op1 - op2;
        `ALU_MUL: result = op1 * op2;
        `ALU_SRA: result = op1 >>> shamt;
        `ALU_SLL: result = op1 << shamt;

        default: result = {31{1'bx}};
        
    endcase

end


endmodule