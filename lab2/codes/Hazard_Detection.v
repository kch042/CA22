module Hazard_Detection(memread_exe, rd_addr_exe, rs1_addr, rs2_addr, pcwrite, stall, noop);

input           memread_exe;
input   [4:0]   rd_addr_exe, rs1_addr, rs2_addr;

output          stall, noop, pcwrite;

wire    is_load_use;
assign  is_load_use = memread_exe & ((rs1_addr == rd_addr_exe) | (rs2_addr == rd_addr_exe));

assign  stall   = is_load_use;
assign  noop    = is_load_use;
assign  pcwrite = !is_load_use;

endmodule

// emit signal to flush the pipeline and calculate the addr to rollback
// when misprediction occurs.
module Control_Hazard_Detection(branch_instr_exe, is_zero, branch_pred_exe, pc_exe, imm_exe, is_mispredict, pc_rollback);

input           branch_instr_exe, is_zero, branch_pred_exe;
input   [31:0]  pc_exe, imm_exe;

output          is_mispredict;
output  [31:0]  pc_rollback;

assign  is_mispredict   =   branch_instr_exe & (branch_pred_exe != is_zero);
assign  pc_rollback     =   (branch_instr_exe & is_zero) ? (pc_exe + (imm_exe<<1)) : (pc_exe+4);


endmodule