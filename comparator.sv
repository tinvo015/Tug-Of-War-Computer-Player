// 10-bit comparator
module comparator (press, clk, SW, comp);

	output logic press;
	
	input logic clk;
	input logic [8:0] SW;
	input logic [9:0] comp;
	
	always_comb begin
				
		if (comp[9]==1) begin
			press = 0;
		end else if (SW[8:0] > comp[8:0]) begin
			press = 1;
		end else begin
			press = 0;
		end		
			
	end	
endmodule 

module comparator_testbench();
	logic clk;
	logic [9:0] SW;
	logic [9:0] comp;
	logic compare;
	
	
	comparator dut (.press(compare), .clk(clk), .SW(SW[8:0]), .comp(comp));

	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
		
		SW = 01110101;comp = 1111101010;	@(posedge clk);		
		SW = 01010101;comp = 1111100010;	@(posedge clk);			
		SW = 01110101;comp = 1111101010;	@(posedge clk);			
		SW = 01110001;comp = 1111010100;	@(posedge clk);			
		SW = 01110101;comp = 1111101010;	@(posedge clk);		
		SW = 11110101;comp = 0111101010;	@(posedge clk);		
		 
		$stop; // End the simulation.
	end
endmodule 