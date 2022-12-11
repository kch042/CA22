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