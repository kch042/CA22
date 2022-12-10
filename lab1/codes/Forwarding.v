// For now, ignore the case where
// regwrite_mem is 1 and mem_read is 1
// which is load-use hazard and will be solved 
// by hazard detection unit later

`define FROM_REG    2'b00
`define FROM_WB     2'b01
`define FROM_MEM    2'b10

module Forwarding(
    rs1_addr_exe, rs2_addr_exe, regwrite_mem, regwrite_wb, rd_addr_mem, rd_addr_wb,
    forwardA, forwardB
);

input       [31:0]  rs1_addr_exe, rs2_addr_exe, rd_addr_mem, rd_addr_wb;
input               regwrite_mem, regwrite_wb;
output      [1:0]   forwardA, forwardB;

assign  forwardA    =   ((rs1_addr_exe == rd_addr_mem) && regwrite_mem) ?   `FROM_MEM   :
                        ((rs1_addr_exe == rd_addr_wb)  && regwrite_wb)  ?   `FROM_WB    :
                                                                            `FROM_REG;

assign  forwardB    =   ((rs2_addr_exe == rd_addr_mem) && regwrite_mem) ?   `FROM_MEM   :
                        ((rs2_addr_exe == rd_addr_wb)  && regwrite_wb)  ?   `FROM_WB    :
                                                                            `FROM_REG;

endmodule