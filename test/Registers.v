module Registers
(
    clk_i,
    RS1addr_i,
    RS2addr_i,
    RDaddr_i, 
    RDdata_i,
    RegWrite_i, 
    RS1data_o, 
    RS2data_o 
);

// Ports
input               clk_i;
input   [4:0]       RS1addr_i;
input   [4:0]       RS2addr_i;
input   [4:0]       RDaddr_i;
input   [31:0]      RDdata_i;
input               RegWrite_i;

// Register File
reg signed    [31:0]      register       ;

// Read Data      
assign  RS1data_o = (RS1addr_i == RDaddr_i && RegWrite_i)? RDdata_i : register[RS1addr_i];
assign  RS2data_o = (RS2addr_i == RDaddr_i && RegWrite_i)? RDdata_i : register[RS2addr_i];

// Write Data   
always@(posedge clk_i) begin
    if(RegWrite_i && RDaddr_i != 0)
        register[RDaddr_i] <= RDdata_i;
end


   
endmodule 
