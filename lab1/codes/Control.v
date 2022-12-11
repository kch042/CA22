`include "Parameters.v"

// Control modules generates
// 1. main control signal
// 2. aluctrl
module Control(opcode, funct3, funct7, alusrc, aluctrl, memread, memwrite, mem2reg, regwrite, branch, noop);

input   [6:0]   opcode;
input   [2:0]   funct3;
input   [6:0]   funct7;
input           noop;

output          alusrc, memread, memwrite, mem2reg, regwrite, branch;
output  [3:0]   aluctrl;

/*********** Main Control Signal ***********/
wire is_r_type, is_i_type, is_load, is_store, is_beq;
assign is_r_type = ((!noop) & (opcode == `OP_R_TYPE));
assign is_i_type = ((!noop) & (opcode == `OP_I_TPYE));
assign is_load   = ((!noop) & (opcode == `OP_LOAD));
assign is_store  = ((!noop) & (opcode == `OP_STORE));
assign is_beq    = ((!noop) & (opcode == `OP_BEQ));

assign regwrite  = is_r_type | is_i_type | is_load;
assign alusrc    = is_r_type ? 0: 1; 
assign memread   = is_load;
assign memwrite  = is_store;
assign mem2reg   = is_load;
assign branch    = is_beq;

reg [1:0] aluop;
always @(*) begin
    if (is_r_type) 
        aluop = `ALUOP_R_TYPE;
    else if (is_i_type || is_load || is_store) 
        aluop = `ALUOP_I_TYPE_AND_LOAD_STORE;
    else if (is_beq)
        aluop = `ALUOP_BEQ;
    else
        aluop = `ALUOP_UNDEFINED;
end

ALUControl alucontrol(
    .aluop(aluop),
    .funct3(funct3),
    .funct7(funct7),
    .aluctrl(aluctrl)
);

endmodule


// decode for alu control signal
module ALUControl(aluop, funct3, funct7, aluctrl);

localparam FUNCT3_ADD_SUB_MUL = 3'b000;
localparam FUNCT3_SLL         = 3'b001;
localparam FUNCT3_SRA         = 3'b101;
localparam FUNCT3_XOR         = 3'b100;
localparam FUNCT3_AND         = 3'b111;

input   [1:0] aluop;
input   [2:0] funct3;
input   [6:0] funct7;

output  [3:0] aluctrl;
reg     [3:0] aluctrl;

always @(*) begin
    case (aluop)
        
        `ALUOP_I_TYPE_AND_LOAD_STORE: case (funct3)
            FUNCT3_SRA:             aluctrl = `ALU_SRA;  // rsai
            default:                aluctrl = `ALU_ADD;  // addi/lw/sw
        endcase
        
        `ALUOP_R_TYPE: case (funct3)
            FUNCT3_ADD_SUB_MUL: if (funct7 == 7'b0000000) 
                                    aluctrl = `ALU_ADD;
                                else if (funct7 == 7'b0100000)
                                    aluctrl = `ALU_SUB;
                                else if (funct7 == 7'b0000001)
                                    aluctrl = `ALU_MUL;
                                else 
                                    aluctrl = `ALU_NOP;

            FUNCT3_AND:             aluctrl = `ALU_AND;
            FUNCT3_XOR:             aluctrl = `ALU_XOR;
            FUNCT3_SLL:             aluctrl = `ALU_SLL;
            FUNCT3_SRA:             aluctrl = `ALU_SRA;

            default:                aluctrl = `ALU_NOP;
        endcase

        default: aluctrl = `ALU_NOP;    
    endcase

end

endmodule