module normalLight (Clock, Reset, L, R, NL, NR, lightOn);

	input logic Clock, Reset;

	// L is true when left key is pressed, R is true when the right key
	// is pressed, NL is true when the light on the left is on, and NR
	// is true when the light on the right is on.
	input logic L, R, NL, NR;

	// when lightOn is true, the normal light should be on.
	output logic lightOn;

	
	enum {on, off} ps, ns;

	// Next State logic
	always_comb begin
		case (ps)
			on: 	if (L & R & ~NL & ~NR) 				ns = on; 
					else if (~L & ~R & ~NL & ~NR)		ns = on;
					else 										ns = off;
			off: 	if (~L & R & NL & ~NR) 				ns = on; 
					else if (L & ~R & ~NL & NR)  		ns = on; 
					else 									 	ns = off; 

		endcase
		
		if (ps == on) begin
			lightOn = 1;
		end else begin
			lightOn = 0;
		end
		
		
	end


	// DFFs
	always_ff @(posedge Clock) begin
		if (Reset)
			ps <= off;
		else
			ps <= ns;
	end

endmodule 



module normalLight_testbench();
	logic clk;
	logic [3:0] KEY; 
	logic [9:0] SW;
	logic [9:0] LEDR;
	logic leftLight, rightLight;
	

	normalLight dut (.Clock(clk), .Reset(SW[9]), .L(KEY[3]), .R(KEY[0]), .NL(leftLight), .NR(rightLight), .lightOn(LEDR[5]));

	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
																@(posedge clk);
		SW[9] <= 1;  										@(posedge clk);
		SW[9] <= 0; leftLight<=1; rightLight<=0;	@(posedge clk);
		
		KEY[3]<=0; KEY[0]<= 1; leftLight<=1; rightLight<=0; @(posedge clk); //ns=on
		KEY[3]<=1; KEY[0]<= 1; leftLight<=0; rightLight<=0; @(posedge clk); //ns=on
		KEY[3]<=0; KEY[0]<= 1; leftLight<=0; rightLight<=0; @(posedge clk); //ns=off
		KEY[3]<=0; KEY[0]<= 1; leftLight<=0; rightLight<=1; @(posedge clk); //ns =off	
		KEY[3]<=0; KEY[0]<= 1; leftLight<=0; rightLight<=0; @(posedge clk);//ns = off		 
		KEY[3]<=1; KEY[0]<= 0; leftLight<=0; rightLight<=1; @(posedge clk); //ns = on		
		KEY[3]<=1; KEY[0]<= 0; leftLight<=0; rightLight<=0; @(posedge clk);		
		KEY[3]<=1; KEY[0]<= 0; leftLight<=1; rightLight<=0; @(posedge clk);	
		KEY[3]<=1; KEY[0]<= 0; leftLight<=0; rightLight<=0; @(posedge clk);	

		 $stop; // End the simulation.
	end
endmodule 