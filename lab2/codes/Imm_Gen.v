`include "Parameters.v"

module Imm_Gen(instruction, imm);

input  [31:0] instruction;
output [31:0] imm;

wire [6:0] opcode;
assign opcode = instruction[6:0];
 
reg [31:0] imm;
always @(*) begin
    case (opcode)
        `OP_STORE:  imm = $signed({ instruction[31:25], instruction[11:7]}); 
        `OP_BEQ:    imm = $signed({ instruction[31], 
                                    instruction[7],
                                    instruction[30:25], 
                                    instruction[11:8]
                                    });

        default:    imm = $signed(  instruction[31:20] );
    endcase    
end

endmodule