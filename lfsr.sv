// 10-bit linear feedback shift register
module lfsr (q,reset, clk);

	output logic [10:1] q;
	input logic reset, clk;
	logic temp;
	
	de_ff dff1(.q(q[1]), .d(temp), .reset(reset), .clk(clk));	
	de_ff dff2(.q(q[2]), .d(q[1]), .reset(reset), .clk(clk));
	de_ff dff3(.q(q[3]), .d(q[2]), .reset(reset), .clk(clk));	
	de_ff dff4(.q(q[4]), .d(q[3]), .reset(reset), .clk(clk));
	de_ff dff5(.q(q[5]), .d(q[4]), .reset(reset), .clk(clk));	
	de_ff dff6(.q(q[6]), .d(q[5]), .reset(reset), .clk(clk));
	de_ff dff7(.q(q[7]), .d(q[6]), .reset(reset), .clk(clk));	
	de_ff dff8(.q(q[8]), .d(q[7]), .reset(reset), .clk(clk));
	de_ff dff9(.q(q[9]), .d(q[8]), .reset(reset), .clk(clk));	
	de_ff dff10(.q(q[10]), .d(q[9]), .reset(reset), .clk(clk));
	
	assign temp = q[10] ~^ q[7]; //q[10] xor q[7]
	
endmodule 

