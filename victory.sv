module victory (Clock, Reset, L, R, led9, led1, HEX0, HEX1, win);

	input logic Clock, Reset;

	// L is true when left key is pressed, R is true when the right key
	// is pressed, led9 is true when LED9 is on, and led1
	// is true when LED1 is on.
	input logic L, R, led9, led1;

	output logic [6:0] HEX0, HEX1;
	output logic win;

	logic win1, win2;
	
	enum {none, player1, player2} ps, ns;

	// Next State logic
	always_comb begin
		case (ps)
			none: if (led9 & L & ~R) 					ns = player2; 
					else if (led1 & ~L & R)				ns = player1;
					else 										ns = none;
			
			player1: 										ns = none;
			player2:											ns = none;
		endcase
		
		if (ps == player1 ) begin
			win1 = 1'b1;
			win2 = 1'b0;
			win = 1'b1;
		end else if (ps == player2) begin
			win1 = 1'b0;
			win2 = 1'b1;
			win = 1'b1;
		end else begin
			win1 = 1'b0;
			win2 = 1'b0;
			win = 1'b0;
		end
		
	end

	score p1score(.Clock(Clock), .Reset(Reset), .win(win1), .hex(HEX0)); 
	score p2score(.Clock(Clock), .Reset(Reset), .win(win2), .hex(HEX1));	

	// DFFs
	always_ff @(posedge Clock) begin
		if (Reset)
			ps <= none;
		else
			ps <= ns;
	end

endmodule 

module victory_testbench();
	logic clk;
	logic [3:0] KEY; 
	logic [9:0] SW;
	logic [9:0] LEDR;
	logic [6:0] HEX0, HEX1;
	

	victory dut (.Clock(clk), .Reset(SW[9]), .L(KEY[3]), .R(KEY[0]), .led9(LEDR[9]), .led1(LEDR[1]), .HEX0(HEX0), .HEX1(HEX1));

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
		SW[9] <= 0; LEDR[9]<=0; LEDR[1]<=0;			@(posedge clk);
		LEDR[9]<=1; KEY[3] <=1; KEY[0] <=0;			@(posedge clk);
		LEDR[9]<=0; KEY[3] <=0;
		LEDR[1]<=1; KEY[0] <=1;							@(posedge clk);
		repeat(6) 											@(posedge clk);
		SW[9] <=1; 											@(posedge clk);

		
		

		 $stop; // End the simulation.
	end
endmodule

