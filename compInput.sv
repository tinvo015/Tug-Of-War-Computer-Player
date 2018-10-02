module compInput (Clock, Reset, in, out);

	input logic Clock, Reset;

	input logic in; //user input

	output logic out; 

	
	enum {pressed, unPressed} ps, ns;

	// Next State logic
	always_comb begin
		case (ps)
			pressed: 	if (in) 		ns = pressed; 
							else 			ns = unPressed;
			unPressed: 	if (in) 		ns = pressed; 
							else 			ns = unPressed; 

		endcase
		
		if (ps == pressed) begin
			out = 1;
		end else begin
			out = 0;
		end
		
		
	end


	// DFFs
	always_ff @(posedge Clock) begin
		if (Reset)
			ps <= unPressed;
		else
			ps <= ns;
	end

endmodule 


module compInput_testbench();
	logic clk;
	logic [3:0] KEY; 
	logic out;
	logic [9:0] SW;
	

	userInput dut (.Clock(clk), .Reset(SW[9]), .in(KEY[3]), .out(out));

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
		KEY[3] <=0;											@(posedge clk);
		KEY[3] <=1;											@(posedge clk);
		KEY[3] <=1;											@(posedge clk);
		KEY[3] <=0;											@(posedge clk);
		
		

		 $stop; // End the simulation.
	end
endmodule

