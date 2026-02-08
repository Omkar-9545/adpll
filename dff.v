/* This is a DFF */

module dff(
	input clk,
	input data,
	input reset,
	output reg q
	);

	always @(posedge clk or posedge reset) begin
		if(reset)
			q <= 1'b0;
		else
			q <= data;
	end
endmodule
