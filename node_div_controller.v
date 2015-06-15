`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:09:35 04/28/2015 
// Design Name: 
// Module Name:    node_div_controller 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Play the music "Blue Waltz"
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module node_div_controller(
	input  clk, 
	input  rst_n, 
	output reg [19:0] note_div
);

	reg [19:0] next_note_div = 20'b0;
	reg [6:0]  counter = 0;
	reg [2:0]  delay = 0;
	
	always @(negedge clk) 
	begin
	//note_div <= 0;
	note_div <= next_note_div;
		case(counter)
			/********************************/
			7'd2: next_note_div <= 20'd60674;
			/********************************/
			7'd3: next_note_div <= 20'd30337;
			7'd6: next_note_div <= 20'd0;
			7'd7: next_note_div <= 20'd30337;
			/********************************/
			7'd9: next_note_div <= 20'd34052;
			7'd13: next_note_div <= 20'd28634;
			/********************************/
			7'd15: next_note_div <= 20'd30337;			
			7'd18: next_note_div <= 20'd40496;
			7'd19: next_note_div <= 20'd34052;
			7'd20: next_note_div <= 20'd38223;
			/********************************/
			7'd21: next_note_div <= 20'd45456;
			7'd24: next_note_div <= 20'd0;
			7'd25: next_note_div <= 20'd45456;
			/********************************/
			7'd27: next_note_div <= 20'd30337;
			7'd30: next_note_div <= 20'd0;
			7'd31: next_note_div <= 20'd30337;
			/********************************/
			7'd33: next_note_div <= 20'd22727;
			7'd36: next_note_div <= 20'd0;
			7'd37: next_note_div <= 20'd30337;
			/********************************/
			7'd39: next_note_div <= 20'd28634;
			/********************************/
			7'd50: next_note_div <= 20'd0;
			/********************************/
			7'd51: next_note_div <= 20'd28634;			
			7'd54: next_note_div <= 20'd30337;
			7'd55: next_note_div <= 20'd34052;
			7'd56: next_note_div <= 20'd28634;
			/********************************/
			7'd57: next_note_div <= 20'd30337;
			/********************************/
			7'd63: next_note_div <= 20'd34052;			
			7'd66: next_note_div <= 20'd38223;
			7'd67: next_note_div <= 20'd40496;
			7'd68: next_note_div <= 20'd34052;
			/********************************/
			7'd69: next_note_div <= 20'd38223;
			7'd74: next_note_div <= 20'd0;
			/********************************/
			7'd75: next_note_div <= 20'd38223;			
			7'd78: next_note_div <= 20'd40496;
			7'd79: next_note_div <= 20'd45456;
			7'd80: next_note_div <= 20'd38223;
			/********************************/
			7'd81: next_note_div <= 20'd40496;			
			7'd84: next_note_div <= 20'd45456;
			7'd85: next_note_div <= 20'd48158;
			7'd86: next_note_div <= 20'd40496;
			/********************************/
			7'd87: next_note_div <= 20'd45456;
			/********************************/
			7'd97: next_note_div <= 20'd0;
			/********************************/
			7'd99: next_note_div <= 20'd60674;
			7'd102: next_note_div <= 20'd0;
			7'd103: next_note_div <= 20'd60674;
			/********************************/
			7'd105: next_note_div <= 20'd57269;
			7'd108: next_note_div <= 20'd60674;
			7'd109: next_note_div <= 20'd68106;
			/********************************/
			7'd111: next_note_div <= 20'd60674;
			/********************************/
			7'd123: next_note_div <= 20'd0;
			/********************************
			7'd123: next_note_div <= 20'd57269;
			7'd126: next_note_div <= 20'd0;
			7'd127: next_note_div <= 20'd57269;
			/********************************
			7'd129: next_note_div <= 20'd45456;			
			7'd132: next_note_div <= 20'd51020;
			7'd133: next_note_div <= 20'd57269;
			7'd134: next_note_div <= 20'd51020;
			/********************************
			7'd135: next_note_div <= 20'd60674;
			/*********************************
			7'd140: next_note_div <= 20'd0;
			7'd141: counter <= 0;
			/*********************************/
			default:next_note_div <= note_div;
		endcase
		delay <= delay + 1'b1;
		if(!delay[0])
			counter <= counter + 1'b1;
		else
			counter <= counter;
	end

endmodule
