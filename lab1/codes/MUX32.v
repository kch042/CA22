// 2 to 1 multiplexer
module Mux_2_way(
    data1_i,
    data2_i,
    select_i,
    data_o
);

input   [31:0]  data1_i;
input   [31:0]  data2_i;
input          select_i;
output  [31:0]  data_o;

assign data_o = (select_i==1) ? data2_i : data1_i;

endmodule


// 4 to 1 Multiplexer
module Mux_4_way(
    data1_i,
    data2_i,
    data3_i,
    data4_i,
    select_i,
    data_o
);

input   [31:0]  data1_i;
input   [31:0]  data2_i;
input   [31:0]  data3_i;
input   [31:0]  data4_i;
input   [1:0]   select_i;
output  [31:0]  data_o;

reg     [31:0]  data_o;
always @(*) begin
    case (select_i)
        0:  data_o = data1_i;
        1:  data_o = data2_i;
        2:  data_o = data3_i;
        3:  data_o = data4_i;
    endcase
end


endmodule