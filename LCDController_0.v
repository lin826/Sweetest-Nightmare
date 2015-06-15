`timescale 1ns / 1ps
`include "lcd.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:20:09 04/22/2015 
// Design Name: 
// Module Name:    LCDController 
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
////////////////////////////// ////////////////////////////////////////////////////
`include "keyboard.vh"
module LCDController_0(
    input clk,
    input reset,
	 input [15:0] ctrl_code_i,
	 output reg [7:0] lcd_d,
	 output reg lcd_rst,
	 output lcd_cs1,
	 output lcd_cs2,
	 output lcd_en,
	 output reg lcd_wr,
	 output reg lcd_di
    );
	 
	parameter OBJECT_PATTERN = 8'hff;

	 `include "lcd_task.vh"
	 
	 reg [2:0] state;
	 reg [2:0] addr_x;
	 reg [7:0] addr_y;
	 reg [1:0] ram_select;
	 reg [1:0] enable;
	 reg [1:0] delay;
	 reg clear;
	
	// Pattern gen
	reg [5:0] line;
	reg [7:0] obj_addr_y;
	reg [2:0] obj_sprite_addr_y;
	reg [2:0] obj_addr_x;
	reg [5:0] obj_line;

	reg scroll;
	always @(posedge clk or negedge reset) begin
		if(~reset) begin
			clear <= 1'b1; // fisrt to clear the screen
			state <= 3'b0;
			delay <= 2'b00;
			addr_x <= 3'b000; // Start from first page
			addr_y <= 9'h0; // Start from first column
			enable <= 2'b00;
			ram_select <= 2'b11;
			lcd_rst<= 1'b0;  
			lcd_di <= 1'b0;
			lcd_wr <= 1'b0;

			obj_addr_y <= 8'd60;
			obj_addr_x <= 3'o2;
			obj_line <= 6'd4;
			obj_sprite_addr_y <= 0;
			line <= 6'b0;
		end 
		else begin
			if(enable < 2'b10) begin
				enable <= enable + 2'b1;
				delay[1] <= 1'b1;
			end
			else if(delay != 2'b00)
				delay <= delay - 2'b1;
			else begin
				case (ctrl_code_i)
					`KEYCODE_8:
							obj_addr_y <= obj_addr_y + 1;
					`KEYCODE_2:
							obj_addr_y <= obj_addr_y - 1;
					`KEYCODE_6:
							obj_line <= obj_line - 1;
					`KEYCODE_4:
							obj_line <= obj_line + 1;
				endcase

				case(state)
					`STATE_DISPLAY_ON:
							display_on(enable, state, lcd_d, lcd_rst);
					`STATE_SET_STARTLINE:
						begin
							state <= `STATE_SET_Y_COUNTER;
							lcd_d <= {2'b11, line};
							enable <= 2'b00;
						end
					`STATE_SET_Y_COUNTER:
						begin
							state <= `STATE_SET_X_COUNTER; 
							lcd_d <= `TEMPLATE_SET_Y;
							enable <= 2'b00;
						end
					`STATE_SET_X_COUNTER:
						begin
							lcd_di <= `MODE_CMD;
							state <= `STATE_WRITE;
							lcd_d <= {5'b10111, addr_x}; 
							enable <= 2'b00;
						end
					`STATE_WRITE: 
					begin
						if(clear) begin
							ram_select <= 2'b11; 
							if(addr_y < 64) begin 
								addr_y <= addr_y + 8'h1;
								lcd_di <= `MODE_DATA; 
								lcd_d <= 8'h00; 
								enable <= 2'b00; 
							end
							else if(addr_x < 3'o7) begin 
								state <= 3'o3; 
								addr_x <= addr_x + 3'o1; 
							end
							else begin 
								state <= 3'o3; 
								addr_x <= 3'o0; 
								clear <= 1'b0; 
							end
						end
						else begin
							if(addr_y < 128) begin
								lcd_di <= `MODE_DATA;
								genPattern();
								
								ram_select <= (addr_y  < 64) ? 2'b01 : 2'b10;
								addr_y <= addr_y + 8'h1;
								enable <= 2'b00; 
							end
							else begin
								ram_select <= 2'b11;
								state <= `STATE_SET_X_COUNTER;
								addr_x <= addr_x + 3'o1;
								addr_y <= 0;
							end
						end
					end
				endcase
			end
		end
	end
	
	assign lcd_en = enable[0];
	assign lcd_cs1 = ram_select[0];
	assign lcd_cs2 = ram_select[1];
	
	task genPattern;
		case(addr_x)
	3'd0:
		case(addr_y)
			8'd5: lcd_d <= 8'b11100000;
			8'd6: lcd_d <= 8'b00100000;
			8'd7: lcd_d <= 8'b00100000;
			8'd8: lcd_d <= 8'b00100000;
			8'd9: lcd_d <= 8'b00100000;
			8'd12: lcd_d <= 8'b10000000;
			8'd16: lcd_d <= 8'b10000000;
			8'd20: lcd_d <= 8'b10000000;
			8'd21: lcd_d <= 8'b10000000;
			8'd22: lcd_d <= 8'b10000000;
			8'd26: lcd_d <= 8'b10000000;
			8'd28: lcd_d <= 8'b10000000;
			8'd29: lcd_d <= 8'b10000000;
			8'd31: lcd_d <= 8'b10000000;
			8'd42: lcd_d <= 8'b10000000;
			8'd43: lcd_d <= 8'b10000000;
			8'd44: lcd_d <= 8'b10000000;
			8'd45: lcd_d <= 8'b10000000;
			8'd49: lcd_d <= 8'b10010000;
			8'd53: lcd_d <= 8'b10000000;
			8'd54: lcd_d <= 8'b10000000;
			8'd55: lcd_d <= 8'b10000000;
			8'd56: lcd_d <= 8'b10000000;
			8'd59: lcd_d <= 8'b11110000;
			8'd60: lcd_d <= 8'b10000000;
			8'd61: lcd_d <= 8'b10000000;
			8'd62: lcd_d <= 8'b10000000;
			8'd65: lcd_d <= 8'b10000000;
			8'd66: lcd_d <= 8'b11100000;
			8'd67: lcd_d <= 8'b10000000;
			8'd68: lcd_d <= 8'b10000000;
			8'd78: lcd_d <= 8'b00100000;
			8'd79: lcd_d <= 8'b11100000;
			8'd80: lcd_d <= 8'b00100000;
			8'd87: lcd_d <= 8'b10000000;
			8'd88: lcd_d <= 8'b10000000;
			8'd89: lcd_d <= 8'b10000000;
			8'd90: lcd_d <= 8'b10000000;
			8'd94: lcd_d <= 8'b11110000;
			8'd97: lcd_d <= 8'b10000000;
			8'd98: lcd_d <= 8'b10000000;
			8'd99: lcd_d <= 8'b10000000;
			8'd100: lcd_d <= 8'b10000000;
			8'd104: lcd_d <= 8'b10000000;
			default: lcd_d <= 8'b0;
		endcase
	3'd1:
		case(addr_y)
			8'd5: lcd_d <= 8'b00011111;
			8'd6: lcd_d <= 8'b00010001;
			8'd7: lcd_d <= 8'b00010001;
			8'd8: lcd_d <= 8'b00010001;
			8'd9: lcd_d <= 8'b00010001;
			8'd12: lcd_d <= 8'b00000011;
			8'd13: lcd_d <= 8'b00001100;
			8'd14: lcd_d <= 8'b00011000;
			8'd15: lcd_d <= 8'b00001100;
			8'd16: lcd_d <= 8'b00000001;
			8'd19: lcd_d <= 8'b00001111;
			8'd20: lcd_d <= 8'b00010010;
			8'd21: lcd_d <= 8'b00010010;
			8'd22: lcd_d <= 8'b00010010;
			8'd23: lcd_d <= 8'b00010011;
			8'd26: lcd_d <= 8'b00011111;
			8'd27: lcd_d <= 8'b00000001;
			8'd31: lcd_d <= 8'b00000001;
			8'd32: lcd_d <= 8'b01001100;
			8'd33: lcd_d <= 8'b00011000;
			8'd34: lcd_d <= 8'b00000110;
			8'd35: lcd_d <= 8'b00000011;
			8'd42: lcd_d <= 8'b00011111;
			8'd46: lcd_d <= 8'b00011111;
			8'd49: lcd_d <= 8'b00011111;
			8'd52: lcd_d <= 8'b01001111;
			8'd53: lcd_d <= 8'b01010000;
			8'd54: lcd_d <= 8'b01010000;
			8'd55: lcd_d <= 8'b01010000;
			8'd56: lcd_d <= 8'b00111111;
			8'd59: lcd_d <= 8'b00011111;
			8'd63: lcd_d <= 8'b00011111;
			8'd66: lcd_d <= 8'b00011111;
			8'd67: lcd_d <= 8'b00010000;
			8'd68: lcd_d <= 8'b00010000;
			8'd70: lcd_d <= 8'b01100000;
			8'd71: lcd_d <= 8'b00011000;
			8'd78: lcd_d <= 8'b00010000;
			8'd79: lcd_d <= 8'b00011111;
			8'd80: lcd_d <= 8'b00010000;
			8'd87: lcd_d <= 8'b01111111;
			8'd88: lcd_d <= 8'b00010000;
			8'd89: lcd_d <= 8'b00010000;
			8'd90: lcd_d <= 8'b00010000;
			8'd91: lcd_d <= 8'b00001011;
			8'd94: lcd_d <= 8'b00011111;
			8'd97: lcd_d <= 8'b00011100;
			8'd98: lcd_d <= 8'b00010010;
			8'd99: lcd_d <= 8'b00010010;
			8'd100: lcd_d <= 8'b00010010;
			8'd101: lcd_d <= 8'b00011111;
			8'd104: lcd_d <= 8'b00000001;
			8'd105: lcd_d <= 8'b01000100;
			8'd106: lcd_d <= 8'b00011000;
			8'd107: lcd_d <= 8'b00000110;
			8'd108: lcd_d <= 8'b00000001;
			default: lcd_d <= 8'b0;
		endcase
	3'd2:
		case(addr_y)
			8'd5: lcd_d <= 8'b11000000;
			8'd8: lcd_d <= 8'b11000000;
			8'd11: lcd_d <= 8'b10000000;
			8'd14: lcd_d <= 8'b11001000;
			8'd16: lcd_d <= 8'b01000000;
			8'd17: lcd_d <= 8'b11110000;
			8'd18: lcd_d <= 8'b01000000;
			8'd19: lcd_d <= 8'b01000000;
			8'd21: lcd_d <= 8'b11111000;
			8'd22: lcd_d <= 8'b01000000;
			8'd23: lcd_d <= 8'b01000000;
			8'd24: lcd_d <= 8'b01000000;
			8'd25: lcd_d <= 8'b10000000;
			8'd32: lcd_d <= 8'b11111000;
			8'd33: lcd_d <= 8'b01000000;
			8'd34: lcd_d <= 8'b01000000;
			8'd35: lcd_d <= 8'b01000000;
			8'd36: lcd_d <= 8'b10000000;
			8'd39: lcd_d <= 8'b10000000;
			8'd40: lcd_d <= 8'b01000000;
			8'd41: lcd_d <= 8'b01000000;
			8'd42: lcd_d <= 8'b01000000;
			8'd43: lcd_d <= 8'b10000000;
			8'd46: lcd_d <= 8'b11000000;
			8'd47: lcd_d <= 8'b10000000;
			8'd48: lcd_d <= 8'b01000000;
			8'd49: lcd_d <= 8'b01000000;
			default: lcd_d <= 8'b0;
		endcase
	3'd3:
		case(addr_y)
			8'd5: lcd_d <= 8'b00000001;
			8'd6: lcd_d <= 8'b00001100;
			8'd7: lcd_d <= 8'b00000111;
			8'd9: lcd_d <= 8'b00000011;
			8'd10: lcd_d <= 8'b00001100;
			8'd11: lcd_d <= 8'b00000011;
			8'd14: lcd_d <= 8'b00001111;
			8'd17: lcd_d <= 8'b00000111;
			8'd18: lcd_d <= 8'b00001000;
			8'd19: lcd_d <= 8'b00001000;
			8'd21: lcd_d <= 8'b00001111;
			8'd25: lcd_d <= 8'b00001111;
			8'd32: lcd_d <= 8'b00001111;
			8'd36: lcd_d <= 8'b00001111;
			8'd39: lcd_d <= 8'b00000111;
			8'd40: lcd_d <= 8'b00001001;
			8'd41: lcd_d <= 8'b00001001;
			8'd42: lcd_d <= 8'b00001001;
			8'd43: lcd_d <= 8'b00001001;
			8'd46: lcd_d <= 8'b00001111;
			8'd51: lcd_d <= 8'b00001100;
			8'd52: lcd_d <= 8'b00001100;
			default: lcd_d <= 8'b0;
		endcase
	3'd4:
		case(addr_y)
			8'd5: lcd_d <= 8'b00001000;
			8'd6: lcd_d <= 8'b11111000;
			8'd7: lcd_d <= 8'b00001000;
			8'd10: lcd_d <= 8'b00011100;
			8'd13: lcd_d <= 8'b11100000;
			8'd14: lcd_d <= 8'b00100000;
			8'd15: lcd_d <= 8'b00100000;
			8'd16: lcd_d <= 8'b00100000;
			8'd17: lcd_d <= 8'b11000000;
			8'd19: lcd_d <= 8'b00100000;
			8'd20: lcd_d <= 8'b00100000;
			8'd21: lcd_d <= 8'b11000000;
			8'd27: lcd_d <= 8'b00100000;
			8'd28: lcd_d <= 8'b11111000;
			8'd29: lcd_d <= 8'b00100000;
			8'd30: lcd_d <= 8'b00100000;
			8'd32: lcd_d <= 8'b11100100;
			8'd35: lcd_d <= 8'b11100000;
			8'd36: lcd_d <= 8'b01000000;
			8'd37: lcd_d <= 8'b00100000;
			8'd38: lcd_d <= 8'b00100000;
			8'd40: lcd_d <= 8'b11000000;
			8'd41: lcd_d <= 8'b10100000;
			8'd42: lcd_d <= 8'b10100000;
			8'd43: lcd_d <= 8'b10100000;
			8'd44: lcd_d <= 8'b11100000;
			8'd47: lcd_d <= 8'b11000000;
			8'd48: lcd_d <= 8'b00100000;
			8'd49: lcd_d <= 8'b00100000;
			8'd50: lcd_d <= 8'b00100000;
			8'd51: lcd_d <= 8'b11111100;
			8'd62: lcd_d <= 8'b11111100;
			8'd63: lcd_d <= 8'b00100000;
			8'd64: lcd_d <= 8'b00100000;
			8'd65: lcd_d <= 8'b00100000;
			8'd66: lcd_d <= 8'b01000000;
			8'd69: lcd_d <= 8'b11100000;
			8'd73: lcd_d <= 8'b11100000;
			8'd75: lcd_d <= 8'b00100000;
			8'd76: lcd_d <= 8'b11111000;
			8'd77: lcd_d <= 8'b00100000;
			8'd78: lcd_d <= 8'b00100000;
			8'd84: lcd_d <= 8'b00001000;
			8'd85: lcd_d <= 8'b11111000;
			8'd86: lcd_d <= 8'b00001000;
			8'd93: lcd_d <= 8'b11000000;
			8'd94: lcd_d <= 8'b00100000;
			8'd95: lcd_d <= 8'b00100000;
			8'd96: lcd_d <= 8'b00100000;
			8'd97: lcd_d <= 8'b01000000;
			8'd99: lcd_d <= 8'b00100000;
			8'd100: lcd_d <= 8'b10100000;
			8'd101: lcd_d <= 8'b10100000;
			8'd102: lcd_d <= 8'b10100000;
			8'd103: lcd_d <= 8'b11000000;
			8'd106: lcd_d <= 8'b11100000;
			8'd107: lcd_d <= 8'b00100000;
			8'd108: lcd_d <= 8'b00100000;
			8'd109: lcd_d <= 8'b00100000;
			8'd110: lcd_d <= 8'b11000000;
			8'd113: lcd_d <= 8'b00011100;
			8'd115: lcd_d <= 8'b00100000;
			8'd116: lcd_d <= 8'b11111000;
			8'd117: lcd_d <= 8'b00100000;
			8'd118: lcd_d <= 8'b00100000;
			default: lcd_d <= 8'b0;
		endcase
	3'd5:
		case(addr_y)
			8'd5: lcd_d <= 8'b00000100;
			8'd6: lcd_d <= 8'b00000111;
			8'd7: lcd_d <= 8'b00000100;
			8'd13: lcd_d <= 8'b00000111;
			8'd17: lcd_d <= 8'b00000111;
			8'd21: lcd_d <= 8'b00000111;
			8'd28: lcd_d <= 8'b00000111;
			8'd29: lcd_d <= 8'b00000100;
			8'd30: lcd_d <= 8'b00000100;
			8'd32: lcd_d <= 8'b00000111;
			8'd35: lcd_d <= 8'b00000111;
			8'd40: lcd_d <= 8'b00000011;
			8'd41: lcd_d <= 8'b00000100;
			8'd42: lcd_d <= 8'b00000100;
			8'd43: lcd_d <= 8'b00000100;
			8'd44: lcd_d <= 8'b00000100;
			8'd47: lcd_d <= 8'b00000011;
			8'd48: lcd_d <= 8'b00000100;
			8'd49: lcd_d <= 8'b00000100;
			8'd50: lcd_d <= 8'b00000100;
			8'd51: lcd_d <= 8'b00000111;
			8'd54: lcd_d <= 8'b00011100;
			8'd55: lcd_d <= 8'b00000010;
			8'd62: lcd_d <= 8'b00000111;
			8'd63: lcd_d <= 8'b00000100;
			8'd64: lcd_d <= 8'b00000100;
			8'd65: lcd_d <= 8'b00000100;
			8'd66: lcd_d <= 8'b00000011;
			8'd69: lcd_d <= 8'b00000011;
			8'd70: lcd_d <= 8'b00000100;
			8'd71: lcd_d <= 8'b00000100;
			8'd72: lcd_d <= 8'b00000100;
			8'd73: lcd_d <= 8'b00000111;
			8'd76: lcd_d <= 8'b00000111;
			8'd77: lcd_d <= 8'b00000100;
			8'd78: lcd_d <= 8'b00000100;
			8'd84: lcd_d <= 8'b00000100;
			8'd85: lcd_d <= 8'b00000111;
			8'd86: lcd_d <= 8'b00000100;
			8'd93: lcd_d <= 8'b00000011;
			8'd94: lcd_d <= 8'b00000100;
			8'd95: lcd_d <= 8'b00000100;
			8'd96: lcd_d <= 8'b00000100;
			8'd97: lcd_d <= 8'b00000110;
			8'd99: lcd_d <= 8'b00000111;
			8'd100: lcd_d <= 8'b00000100;
			8'd101: lcd_d <= 8'b00000100;
			8'd102: lcd_d <= 8'b00000100;
			8'd103: lcd_d <= 8'b00000111;
			8'd106: lcd_d <= 8'b00000111;
			8'd110: lcd_d <= 8'b00000111;
			8'd116: lcd_d <= 8'b00000111;
			8'd117: lcd_d <= 8'b00000100;
			8'd118: lcd_d <= 8'b00000100;
			default: lcd_d <= 8'b0;
		endcase
	3'd6:
		case(addr_y)
			8'd5: lcd_d <= 8'b01110000;
			8'd6: lcd_d <= 8'b01010000;
			8'd7: lcd_d <= 8'b10010000;
			8'd8: lcd_d <= 8'b10010000;
			8'd10: lcd_d <= 8'b00010000;
			8'd11: lcd_d <= 8'b11111100;
			8'd12: lcd_d <= 8'b00010000;
			8'd13: lcd_d <= 8'b00010000;
			8'd15: lcd_d <= 8'b11100000;
			8'd16: lcd_d <= 8'b00010000;
			8'd17: lcd_d <= 8'b00010000;
			8'd18: lcd_d <= 8'b00010000;
			8'd19: lcd_d <= 8'b11100000;
			8'd22: lcd_d <= 8'b11110000;
			8'd23: lcd_d <= 8'b00010000;
			8'd24: lcd_d <= 8'b00010000;
			8'd25: lcd_d <= 8'b00010000;
			8'd26: lcd_d <= 8'b11100000;
			8'd27: lcd_d <= 8'b01000000;
			8'd33: lcd_d <= 8'b11111110;
			8'd34: lcd_d <= 8'b00010000;
			8'd35: lcd_d <= 8'b00010000;
			8'd36: lcd_d <= 8'b00010000;
			8'd37: lcd_d <= 8'b11100000;
			8'd40: lcd_d <= 8'b11100000;
			8'd41: lcd_d <= 8'b01010000;
			8'd42: lcd_d <= 8'b01010000;
			8'd43: lcd_d <= 8'b01010000;
			8'd44: lcd_d <= 8'b01100000;
			8'd47: lcd_d <= 8'b11110000;
			8'd48: lcd_d <= 8'b00100000;
			8'd49: lcd_d <= 8'b00010000;
			8'd50: lcd_d <= 8'b00010000;
			default: lcd_d <= 8'b0;
		endcase
	3'd7:
		case(addr_y)
			8'd5: lcd_d <= 8'b00000010;
			8'd6: lcd_d <= 8'b00000010;
			8'd7: lcd_d <= 8'b00000010;
			8'd8: lcd_d <= 8'b00000010;
			8'd11: lcd_d <= 8'b00000011;
			8'd12: lcd_d <= 8'b00000010;
			8'd13: lcd_d <= 8'b00000010;
			8'd15: lcd_d <= 8'b00000001;
			8'd16: lcd_d <= 8'b00000010;
			8'd17: lcd_d <= 8'b00000010;
			8'd18: lcd_d <= 8'b00000010;
			8'd19: lcd_d <= 8'b00000001;
			8'd22: lcd_d <= 8'b00001111;
			8'd23: lcd_d <= 8'b00000010;
			8'd24: lcd_d <= 8'b00000010;
			8'd25: lcd_d <= 8'b00000010;
			8'd26: lcd_d <= 8'b00000001;
			8'd33: lcd_d <= 8'b00000011;
			8'd37: lcd_d <= 8'b00000011;
			8'd40: lcd_d <= 8'b00000001;
			8'd41: lcd_d <= 8'b00000010;
			8'd42: lcd_d <= 8'b00000010;
			8'd43: lcd_d <= 8'b00000010;
			8'd44: lcd_d <= 8'b00000010;
			8'd47: lcd_d <= 8'b00000011;
			8'd52: lcd_d <= 8'b00000011;
			8'd53: lcd_d <= 8'b00000011;
			default: lcd_d <= 8'b0;
		endcase
endcase

	endtask

endmodule
