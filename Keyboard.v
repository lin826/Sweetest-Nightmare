`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:52:29 04/06/2015 
// Design Name: 
// Module Name:    Keyboard 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "keyboard.vh"
module Keyboard(
    input clk,
    input reset,
    input [0:3] col,
	 
    output [3:0] row,
    output reg [15:0] keycode
    );
	 	 
	 parameter DEFAULT_COL_DELAY = 16'b1111_1111_1111_1111;
	 
	 // Col Validator
	 reg [0:3] last_col;
	 reg [15:0] col_delays;
	 reg [15:0] keycode_buff;
	 
	 always @(posedge clk) begin
		if(~reset) col_delays <= DEFAULT_COL_DELAY;
		else begin
			if(col_delays == DEFAULT_COL_DELAY)
				last_col = col;
			else
				last_col = 4'b1111;
			col_delays <= {col_delays[11:0], col};
		end
	 end
	 	 
	 // Row scan
	 reg [15:0] keycode_delays;
	 reg [3:0] present_row;
	 reg [3:0] last_row;
	 assign row = present_row;
	 always @(posedge clk or negedge reset)
		if(~reset) begin 
			present_row <= `ROW0;
			last_row <= `ROW0;
		end else begin 
			last_row <= present_row;
			present_row <= {present_row[2:0], present_row[3]};
		end
	 
	 // Keycode
	 always @(posedge clk) begin
	   if(~reset) begin
			keycode <= `KEYCODE_EMPTY;
		end
		else begin
			case (last_row)
				`ROW0: keycode[15:12] <= last_col;
				`ROW1: keycode[11:8] <= last_col;
				`ROW2: keycode[7:4] <= last_col;
				`ROW3: keycode[3:0] <= last_col;
				default: keycode <= `KEYCODE_EMPTY;
			endcase
		end
	 end
	 
endmodule
