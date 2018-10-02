module score (Clock, Reset, win, hex);

	input logic Clock, Reset;

	input logic win;

	// displays winner.
	output logic [6:0] hex;

	
	enum {none, score1, score2, score3, score4, score5, score6, score7} ps, ns;

	// Next State logic
	always_comb begin
		case (ps)
			none: if (win) 			ns = score1; 
					else 					ns = none;
			
			score1: if(win)			ns = score2;
					  else				ns = score1;
					  
			score2: if(win)			ns = score3;
					  else				ns = score2;
					  
			score3: if(win)			ns = score4;
					  else				ns = score3;
					  
			score4: if(win)			ns = score5;
					  else				ns = score4;
					  
			score5: if(win)			ns = score6;
					  else				ns = score5;
					  
			score6: if(win)			ns = score7;
					  else				ns = score6;
					  
			score7: 						ns = score7;					  
		endcase
		
		if (ps==score1) begin
			hex = 7'b1111001; // 1
		end else if (ps==score2) begin
			hex = 7'b0100100; // 2
		end else if (ps==score3) begin
			hex = 7'b0110000; // 3
		end else if (ps==score4) begin
			hex = 7'b0011001; // 4
		end else if (ps==score5) begin
			hex = 7'b0010010; // 5
		end else if (ps==score6) begin
			hex = 7'b0000010; // 6
		end else if (ps==score7) begin
			hex = 7'b1111000; // 7
		end else begin
			hex = 7'b1000000; // 0
		end
		
	end



	// DFFs
	always_ff @(posedge Clock) begin
		if (Reset)
			ps <= none;
		else
			ps <= ns;
	end

endmodule 

