`include "params.v"

module util(
    clk,
    init,
    cnt,
);

input clk;
input init;
output reg [3:0] cnt;


always @(posedge clk or posedge init) begin
    if (init) cnt <= 0;
    else cnt += `x;
end


endmodule


module p(clk, in, out);

input           clk;
input   [3:0]   in;
output  [3:0]   out;

reg     [3:0]   x;
always@(posedge clk)
    x <= in;

assign out = x;

endmodule

