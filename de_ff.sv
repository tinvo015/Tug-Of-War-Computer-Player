// D flip-flop w/synchronous reset
module de_ff (q, d, reset, clk);

	output logic q;
	input logic d, reset, clk;
	
	always_ff @(posedge clk) begin // Hold val until clock edge
		
		if (reset)
			q <= 0; // On reset, set to 0
		else
			q <= d; // Otherwise out = d
	end
	
endmodule 

module de_ff_testbench();
	logic clk;
	logic [3:0] KEY; 
	logic out;
	logic [9:0] SW;
	

	dff dut (.q(out), .d(KEY[3]), .reset(SW[9]), .clk(clk));

	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
																	
		SW[9] <= 1; 										@(posedge clk);
																@(posedge clk);
		SW[9] <= 0; KEY[3] <= 0;						@(posedge clk);
		KEY[3] <=1;											@(posedge clk);
		KEY[3] <=1;											@(posedge clk);
		KEY[3] <=0;											@(posedge clk);
		KEY[3] <=0;											@(posedge clk);

	   $stop; // End the simulation.
	end
endmodule
