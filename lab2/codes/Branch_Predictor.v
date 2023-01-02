module Branch_Predictor
(
    clk_i, 
    rst_i,

    update_i,
	result_i,
	predict_o
);

input       clk_i, rst_i;
input       update_i, result_i;
output      predict_o;

reg [1:0]   state;

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
        state <= 2'b11;
    else if (update_i && result_i && state != 2'b11)
        state <= state+1;
    else if (update_i && !result_i && state != 2'b00)
        state <= state-1;
    else
        state <= state;
end

// take the second least siginificant bit.
assign predict_o = state >> 1;

// for now, use a always-taken predictor for simplicity
// assign predict_o = 1;

endmodule
