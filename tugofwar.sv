module tugofwar (CLOCK_50,KEY, LEDR, SW, HEX0, HEX5);
	input logic CLOCK_50; // 50MHz clock.
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;
		
	output logic [9:0] LEDR;
	output logic [6:0] HEX0, HEX5;

	logic reset;
	assign reset = SW[9]; // Reset when SW9 is on.
	
	logic onetothree;
//	logic twotofour; //test
	
	logic player2, player1; // Output of dff's-- goes into userInput
	logic player2key, player1key; // actual keys of players used throughout the module
	
	logic win; // true if there is a winner
	
	logic [9:0] randomNum;
	
	logic [31:0] clk;
	parameter whichClock = 15;

	// hooks up key0 to 2 dff where output is player1's key
	de_ff dff1(.q(onetothree), .d(~KEY[0]), .reset(reset), .clk(clk[whichClock]));
	de_ff dff3(.q(player1), .d(onetothree), .reset(reset), .clk(clk[whichClock])); 

	
	clock_divider cdiv (.reset(reset), .clock(CLOCK_50), .divided_clocks(clk));
	
	
	// hooks up dffs' outputs to userInput 
	userInput input1(.Clock(clk[whichClock]), .Reset(reset), .in(player1), .out(player1key));
	userInput input2(.Clock(clk[whichClock]), .Reset(reset), .in(player2), .out(player2key));



	lfsr random(.q(randomNum),.reset(reset), .clk(clk[whichClock])); 
	comparator compare(.press(player2), .clk(clk[whichClock]), .SW(SW[8:0]), .comp(randomNum));
	
	normalLight l1 (.Clock(clk[whichClock]), .Reset(reset), .L(player2key), .R(player1key), .NL(LEDR[2]), .NR(1'b0), .lightOn(LEDR[1]));
	normalLight l2 (.Clock(clk[whichClock]), .Reset(reset), .L(player2key), .R(player1key), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]));
	normalLight l3 (.Clock(clk[whichClock]), .Reset(reset), .L(player2key), .R(player1key), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]));
	normalLight l4 (.Clock(clk[whichClock]), .Reset(reset), .L(player2key), .R(player1key), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]));
	centerlight l5 (.win(win), .Clock(clk[whichClock]), .Reset(reset), .L(player2key), .R(player1key), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]));
	normalLight l6 (.Clock(clk[whichClock]), .Reset(reset), .L(player2key), .R(player1key), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]));
	normalLight l7 (.Clock(clk[whichClock]), .Reset(reset), .L(player2key), .R(player1key), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]));
	normalLight l8 (.Clock(clk[whichClock]), .Reset(reset), .L(player2key), .R(player1key), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]));
	normalLight l9 (.Clock(clk[whichClock]), .Reset(reset), .L(player2key), .R(player1key), .NL(1'b0), .NR(LEDR[8]), .lightOn(LEDR[9]));

	
	victory winner(.Clock(clk[whichClock]), .Reset(reset), .L(player2key), .R(player1key), .led9(LEDR[9]), .led1(LEDR[1]), .HEX0(HEX0), .HEX1(HEX5), .win(win));

endmodule


// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (reset, clock, divided_clocks);
	input logic clock, reset;
	output logic [31:0] divided_clocks;
	
	initial begin
		divided_clocks <=0;
	end
		
	always_ff @(posedge clock) begin	
		divided_clocks <= divided_clocks + 1;
	end

endmodule

module tugofwar_testbench();
	logic clk;
	logic [3:0] KEY; 
	logic [9:0] SW;
	logic [9:0] LEDR;
	logic [6:0] HEX0, HEX1;
	logic [3:0] player;
	
	assign player[3:0] = ~KEY[3:0];
	
	tugofwar dut (.CLOCK_50(clk), .KEY(KEY), .LEDR(LEDR), .SW(SW), .HEX0(HEX0), .HEX1(HEX1));
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin

		
		repeat(10)								@(posedge clk);
		SW[9] <= 1;  							@(posedge clk);
		repeat(10)  							@(posedge clk);		
		SW[9] <= 0; 							@(posedge clk);
		repeat(10)								@(posedge clk);
		
		SW[9] <= 1;  							@(posedge clk);
		repeat(10)  							@(posedge clk);		
		SW[9] <= 0; KEY[0]<=1;				@(posedge clk);
		repeat(10)								@(posedge clk);
		
		
		SW[8:0] = 9'b111111111;				@(posedge clk);
		
		repeat(70) @(posedge clk);
		
		SW[9] <= 1;  							@(posedge clk);
		repeat(10)  							@(posedge clk);		
		SW[9] <= 0; KEY[0]<=1;				@(posedge clk);

		
		repeat(100) @(posedge clk);
 
		 
		 $stop; // End the simulation.
	end
endmodule 