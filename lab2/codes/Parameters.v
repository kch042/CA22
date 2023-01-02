`define OP_R_TYPE 7'b0110011
`define OP_I_TPYE 7'b0010011
`define OP_LOAD   7'b0000011
`define OP_STORE  7'b0100011
`define OP_BEQ    7'b1100011

`define ALUOP_I_TYPE_AND_LOAD_STORE 2'b00
`define ALUOP_BEQ                   2'b01
`define ALUOP_R_TYPE                2'b11
`define ALUOP_UNDEFINED             2'bxx

`define ALU_AND 0
`define ALU_XOR 1
`define ALU_SLL 2
`define ALU_ADD 3
`define ALU_SUB 4
`define ALU_MUL 5
`define ALU_SRA 6
`define ALU_NOP 4'b1111