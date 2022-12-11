// Detect whether branch happens and calculate branch addr
// The module is designed to placed in ID stage.
module Branch_Detection (
    pc_id, imm, rs1, rs2, branch, 
    do_branch, branch_addr
);

input   [31:0]  pc_id, imm; 
input   [31:0]  rs1, rs2;
input           branch;

output          do_branch;
output  [31:0]  branch_addr;

assign  do_branch   =   branch & (rs1 == rs2);
assign  branch_addr =   pc_id + (imm << 1);
    
endmodule