/* This is a simple digital phase detector */

module phase_detector(
	input sig_a,
	input sig_b,
	output up,
	output down
	);

	//intermediate signals
	wire rst;	//to reset the flops if both up and down signals assert at once
	reg const_1 = 1'b1;	//const high signal to the flops

	assign rst = up & down;

	dff up_register(.data(const_1),.clk(sig_a),.reset(rst),.q(up));
	dff down_register(.data(const_1),.clk(sig_b),.reset(rst),.q(down));

endmodule 
