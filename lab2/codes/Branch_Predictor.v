module Branch_Predictor
(
    clk_i, 
    rst_i,

    update_i,
	result_i,
	predict_o
);

//
// Consider:
// Two consecutive branchs, in which
// the first one is predicted and actually non-taken,
// thus the second one is not flushed.
//
// update_i: branch_instr_exe (whether the instruction in exe is branch type)
// result_i: is_zero          (whether rs1 == rs2)
//
input       clk_i, rst_i;
input       update_i, result_i;
output      predict_o;

reg [1:0]   state;
reg [1:0]   new_state;

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
        state <= 2'b11;
    else
        state <= new_state;
end

always @(*) begin
    if (update_i && result_i && state != 2'b11)
        new_state =  state+1;
    else if (update_i && !result_i && state != 2'b00)
        new_state = state-1;
    else
        new_state = state;  
end

// take the second least siginificant bit.
assign predict_o = new_state >> 1;

// for now, use a always-taken predictor for simplicity
// assign predict_o = 1;

endmodule
