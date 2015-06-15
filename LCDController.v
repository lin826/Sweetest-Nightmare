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
module LCDController(
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
	
	parameter BALL_RADIUS = 3;
	// 1. Up_ward
	parameter	OBJECT_PATTERN1_1 = 8'b00000000;
	parameter	OBJECT_PATTERN1_2 = 8'b00001111;
	parameter	OBJECT_PATTERN1_3 = 8'b00111100;
	parameter	OBJECT_PATTERN1_4 = 8'b01111000;
	parameter	OBJECT_PATTERN1_5 = 8'b01111000;
	parameter	OBJECT_PATTERN1_6 = 8'b01111000;
	parameter	OBJECT_PATTERN1_7 = 8'b00111100;
	parameter	OBJECT_PATTERN1_8 = 8'b00001111;
	
	// 2. Right_Up
	parameter	OBJECT_PATTERN2_1 = 8'b00000000;
	parameter	OBJECT_PATTERN2_2 = 8'b00011100;
	parameter	OBJECT_PATTERN2_3 = 8'b00111111;
	parameter	OBJECT_PATTERN2_4 = 8'b01111001;
	parameter	OBJECT_PATTERN2_5 = 8'b01110000;
	parameter	OBJECT_PATTERN2_6 = 8'b01100000;
	parameter	OBJECT_PATTERN2_7 = 8'b00100000;
	parameter	OBJECT_PATTERN2_8 = 8'b00110000;
	
	// 3.
	parameter	OBJECT_PATTERN3_1 = 8'b00000000;
	parameter	OBJECT_PATTERN3_2 = 8'b00000000;
	parameter	OBJECT_PATTERN3_3 = 8'b00011100;
	parameter	OBJECT_PATTERN3_4 = 8'b00111110;
	parameter	OBJECT_PATTERN3_5 = 8'b01111111;
	parameter	OBJECT_PATTERN3_6 = 8'b01100011;
	parameter	OBJECT_PATTERN3_7 = 8'b01000001;
	parameter	OBJECT_PATTERN3_8 = 8'b01000001;
	
	// 4.
	parameter	OBJECT_PATTERN4_1 = 8'b00000000;
	parameter	OBJECT_PATTERN4_2 = 8'b00111000;
	parameter	OBJECT_PATTERN4_3 = 8'b11111100;
	parameter	OBJECT_PATTERN4_4 = 8'b10011110;
	parameter	OBJECT_PATTERN4_5 = 8'b00001110;
	parameter	OBJECT_PATTERN4_6 = 8'b00000110;
	parameter	OBJECT_PATTERN4_7 = 8'b00000100;
	parameter	OBJECT_PATTERN4_8 = 8'b00001100;
		
	// 5.
	parameter	OBJECT_PATTERN5_1 = 8'b00000000;
	parameter	OBJECT_PATTERN5_2 = 8'b11110000;
	parameter	OBJECT_PATTERN5_3 = 8'b00111100;
	parameter	OBJECT_PATTERN5_4 = 8'b00011110;
	parameter	OBJECT_PATTERN5_5 = 8'b00011110;
	parameter	OBJECT_PATTERN5_6 = 8'b00011110;
	parameter	OBJECT_PATTERN5_7 = 8'b00111100;
	parameter	OBJECT_PATTERN5_8 = 8'b11110000;
		
	// 6.
	parameter	OBJECT_PATTERN6_1 = 8'b00000000;
	parameter	OBJECT_PATTERN6_2 = 8'b00000110;
	parameter	OBJECT_PATTERN6_3 = 8'b00000010;
	parameter	OBJECT_PATTERN6_4 = 8'b00000011;
	parameter	OBJECT_PATTERN6_5 = 8'b00000111;
	parameter	OBJECT_PATTERN6_6 = 8'b01001111;
	parameter	OBJECT_PATTERN6_7 = 8'b01111110;
	parameter	OBJECT_PATTERN6_8 = 8'b00011100;
	// 7.
	parameter	OBJECT_PATTERN7_1 = 8'b00000000;
	parameter	OBJECT_PATTERN7_2 = 8'b01000001;
	parameter	OBJECT_PATTERN7_3 = 8'b01000001;
	parameter	OBJECT_PATTERN7_4 = 8'b01100011;
	parameter	OBJECT_PATTERN7_5 = 8'b01111111;
	parameter	OBJECT_PATTERN7_6 = 8'b00111110;
	parameter	OBJECT_PATTERN7_7 = 8'b00011100;
	parameter	OBJECT_PATTERN7_8 = 8'b00000000;
	
	// 8.
	parameter	OBJECT_PATTERN8_1 = 8'b00000000;
	parameter	OBJECT_PATTERN8_2 = 8'b00110000;
	parameter	OBJECT_PATTERN8_3 = 8'b00100000;
	parameter	OBJECT_PATTERN8_4 = 8'b01100000;
	parameter	OBJECT_PATTERN8_5 = 8'b01110000;
	parameter	OBJECT_PATTERN8_6 = 8'b01111001;
	parameter	OBJECT_PATTERN8_7 = 8'b00111111;
	parameter	OBJECT_PATTERN8_8 = 8'b00011100;
	
	// Ball
	parameter	BALL_PATTERN1 = 8'b00111100;
	parameter	BALL_PATTERN2 = 8'b01100110;
	parameter	BALL_PATTERN3 = 8'b11000011;
	parameter	BALL_PATTERN4 = 8'b10000001;
	parameter	BALL_PATTERN5 = 8'b10000001;
	parameter	BALL_PATTERN6 = 8'b11000011;
	parameter	BALL_PATTERN7 = 8'b01100110;
	parameter	BALL_PATTERN8 = 8'b00111100;
	
	// Shadow
	parameter	S_PATTERN1 = 8'b00111100;
	parameter	S_PATTERN2 = 8'b01111110;
	parameter	S_PATTERN3 = 8'b11111111;
	parameter	S_PATTERN4 = 8'b11111111;
	parameter	S_PATTERN5 = 8'b11111111;
	parameter	S_PATTERN6 = 8'b11111111;
	parameter	S_PATTERN7 = 8'b01111110;
	parameter	S_PATTERN8 = 8'b00111100;
	
	// AI
	parameter	AI_PATTERN1_1 = 8'b00000000;
	parameter	AI_PATTERN1_2 = 8'b00000010;
	parameter	AI_PATTERN1_3 = 8'b00011001;
	parameter	AI_PATTERN1_4 = 8'b00111101;
	parameter	AI_PATTERN1_5 = 8'b00111101;
	parameter	AI_PATTERN1_6 = 8'b10111001;
	parameter	AI_PATTERN1_7 = 8'b10101011;
	parameter	AI_PATTERN1_8 = 8'b01001110;
	
	parameter	AI_PATTERN2_1 = 8'b00000010;
	parameter	AI_PATTERN2_2 = 8'b00011001;
	parameter	AI_PATTERN2_3 = 8'b00111101;
	parameter	AI_PATTERN2_4 = 8'b00111101;
	parameter	AI_PATTERN2_5 = 8'b10111001;
	parameter	AI_PATTERN2_6 = 8'b10101001;
	parameter	AI_PATTERN2_7 = 8'b10101101;
	parameter	AI_PATTERN2_8 = 8'b01000110;
	
	parameter	AI_PATTERN3_1 = 8'b00011000;
	parameter	AI_PATTERN3_2 = 8'b00111100;
	parameter	AI_PATTERN3_3 = 8'b00111101;
	parameter	AI_PATTERN3_4 = 8'b10111001;
	parameter	AI_PATTERN3_5 = 8'b10101101;
	parameter	AI_PATTERN3_6 = 8'b10101001;
	parameter	AI_PATTERN3_7 = 8'b11101010;
	parameter	AI_PATTERN3_8 = 8'b01000110;
	
	// Heart
	parameter	Heart_PATTERN1 = 8'b00011110;
	parameter	Heart_PATTERN2 = 8'b00111111;
	parameter	Heart_PATTERN3 = 8'b01111110;
	parameter	Heart_PATTERN4 = 8'b11111100;
	parameter	Heart_PATTERN5 = 8'b11111100;
	parameter	Heart_PATTERN6 = 8'b01111110;
	parameter	Heart_PATTERN7 = 8'b00111111;
	parameter	Heart_PATTERN8 = 8'b00011110;

	`include "lcd_task.vh"
	 reg [2:0] level = 0;
	 /*************************
	  * 0. story_1
	  * 1. game_1 (normal)
	  * 2. story_2
	  * 3. game_2 (with evil)
	  * 4. story_3
	  * 5. game_3 (rainy)
	  * 6. story_4
	  *************************/
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
	integer obj_speed_y;
	integer obj_speed_x;
	reg [3:0] dir;
	reg [5:0] shift_x;	
	wire [7:0] dis_y;
	
	// Ball
	reg [7:0] ball_addr_y;
	reg [5:0] ball_line;
	integer ball_speed_y;
	integer ball_speed_x;
	reg [3:0] ball_delay;
	
	wire [7:0] ball_dis_y;
	assign ball_dis_y = addr_y - ball_addr_y;
	reg [5:0] ball_dis_x;
	
	// Shadow
	reg [7:0] shadow_addr_y;
	reg [5:0] shadow_line;
	integer shadow_speed_y;
	integer shadow_speed_x;
	reg [2:0] shadow_delay;
	
	wire [7:0] shadow_dis_y;
	assign shadow_dis_y = addr_y - shadow_addr_y;
	reg [5:0] shadow_dis_x;
	
	// AI
	reg [7:0] AI_addr_y;
	reg [5:0] AI_line;
	reg [1:0] AI_state;
	wire [7:0] AI_dis_y;
	
	// Heart
	reg [7:0] Heart_addr_y;

	reg scroll;
	always @(posedge clk or negedge reset) begin
		if(~reset) begin
			level <= 0;
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

			obj_addr_y <= 8'd110;
			obj_addr_x <= 3'o0;
			obj_line <= 6'd32;
			dir <= 0;
			obj_sprite_addr_y <= 0;
			line <= 6'b0;
			obj_speed_y = 0;
			obj_speed_x = 0;
			
			// Ball
			ball_addr_y <= 8'd10;
			ball_line <= 8'd10;
			ball_speed_y <= 2;
			ball_speed_x <= 1;
			ball_delay <= 0;
			
			// Shadow
			shadow_addr_y<=0;
			shadow_line<=0;
			shadow_speed_y=0;
			shadow_speed_x=0;
			shadow_delay<=0;
			
			// AI
			AI_addr_y <= 10;
			AI_line <= 30;
			AI_state <= 0;
			
			// Heart
			Heart_addr_y <= 10;
		end 
		else begin			
			if(enable < 2'b10) begin
				enable <= enable + 2'b1;
				delay[1] <= 1'b1;
			end
			else if(delay != 2'b00)
				delay <= delay - 2'b1;
			else begin	
				if(level == 5)
					ball_roll();
				else ;			
				case (ctrl_code_i)
					`KEYCODE_8: begin
							obj_speed_y = 1;
							dir <=2;
					end
					`KEYCODE_2: begin
							obj_speed_y = -1;
							dir <=6;
					end
					`KEYCODE_6: begin
							obj_speed_x = -1;
							dir <=0;
					end
					`KEYCODE_4: begin
							obj_speed_x = 1;
							dir <=4;
					end
					`KEYCODE_9: begin
							obj_speed_y = 1;
							obj_speed_x = -1;
							dir <=1;
					end
					`KEYCODE_7: begin
							obj_speed_y = 1;
							obj_speed_x = 1;
							dir <=3;
					end
					`KEYCODE_1: begin
							obj_speed_y = -1;
							obj_speed_x = 1;
							dir <=5;
					end
					`KEYCODE_3: begin
							obj_speed_y = -1;
							obj_speed_x = -1;
							dir <=7;
					end
					`KEYCODE_5: begin
						obj_speed_y = 0;
						obj_speed_x = 0;
						if(level%2==0 && level < 7) begin
							next_level();
						end else ;
					end
					default: ;
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
								state <= 3'o3; // `define STATE_SET_X_COUNTER 3'b011
								addr_x <= addr_x + 3'o1; 
							end
							else begin 
								state <= 3'o3;  // `define STATE_SET_X_COUNTER 3'b011
								addr_x <= 3'o0; 
								clear <= 1'b0; 								
							end
						end
						else begin
							if(addr_y < 128) begin
								lcd_di <= `MODE_DATA;
								if(level==0)
									genPattern_0();
								else if(level==1)
									genPattern_1();
								else if(level==2)
									genPattern_2();
								else if(level==3)
									genPattern_3();
								else if(level==4)
									genPattern_4();
								else if(level==5)
									genPattern_5();
								else if(level==6)
									genPattern_6();
								else begin
									genPattern_6();
								end
								
								ram_select <= (addr_y  < 64) ? 2'b01 : 2'b10;
								addr_y <= addr_y + 8'h1;
								enable <= 2'b00; 
							end
							else begin								
								ram_select <= 2'b11;
								state <= `STATE_SET_X_COUNTER;
								addr_x <= addr_x + 3'o1;
								addr_y <= 0;
								if(level ==1 && addr_x==0) begin
									ball_delay <= ball_delay + 1'b1;
									if(ball_delay[1]) begin
										ball_roll();
										obj_move();
									end
									if(ball_delay==0)
										AI_move();
									else lcd_d <= 0;
								end	else if(level == 3 && addr_x==0) begin
									ball_delay <= ball_delay + 1'b1;
									if(ball_delay[1]) begin
										ball_roll();
										obj_move();
										shadow_move();
									end
									if(ball_delay==0)
										AI_move();
									else lcd_d <= 0;
								end	else if(level ==5 && addr_x==0) begin
									ball_delay <= ball_delay + 1'b1;
									if(ball_delay[1]) begin
										obj_move();
									end	else lcd_d <= 0;
								end
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
	
	task genPattern_0;
	begin
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

	end
	endtask

	task genPattern_1;
	begin
		if(addr_x==0 && addr_y >= Heart_addr_y && addr_y <= Heart_addr_y + 8 ) begin
			drawHeart();
		end else if((addr_y<8 || addr_y>120)&& (addr_x>1 && addr_x<6) ) begin
			drawDoor();
		end else if(addr_y >= obj_addr_y && addr_y <= obj_addr_y + 8 && (addr_x == obj_line / 8 || addr_x == (obj_line / 8) + 1)) begin
			drawObject();
		end else if(addr_y >= AI_addr_y && addr_y <= AI_addr_y + 8 && (addr_x == AI_line / 8 || addr_x == (AI_line / 8) + 1)) begin
			drawAI();
		end else if(addr_y >= (ball_addr_y) && addr_y <= (ball_addr_y + 8) && (addr_x == ball_line / 8 || addr_x == (ball_line / 8) + 1)) begin
			drawBall(); 
		end else begin
			lcd_d <= 8'b0;
		end
	end
	endtask

	task genPattern_2;
	begin
	case(addr_x)
	3'd0:
		case(addr_y)
			8'd3: lcd_d <= 8'b00100000;
			8'd4: lcd_d <= 8'b11100000;
			8'd5: lcd_d <= 8'b00100000;
			8'd12: lcd_d <= 8'b11110000;
			8'd13: lcd_d <= 8'b10000000;
			8'd14: lcd_d <= 8'b10000000;
			8'd15: lcd_d <= 8'b10000000;
			8'd20: lcd_d <= 8'b10000000;
			8'd21: lcd_d <= 8'b10000000;
			8'd22: lcd_d <= 8'b10000000;
			8'd23: lcd_d <= 8'b10000000;
			8'd27: lcd_d <= 8'b10000000;
			8'd28: lcd_d <= 8'b10000000;
			8'd29: lcd_d <= 8'b10000000;
			8'd30: lcd_d <= 8'b10000000;
			8'd37: lcd_d <= 8'b11110000;
			8'd38: lcd_d <= 8'b10000000;
			8'd39: lcd_d <= 8'b10000000;
			8'd40: lcd_d <= 8'b10000000;
			8'd45: lcd_d <= 8'b10000000;
			8'd46: lcd_d <= 8'b10000000;
			8'd47: lcd_d <= 8'b10000000;
			8'd48: lcd_d <= 8'b10000000;
			8'd51: lcd_d <= 8'b10000000;
			8'd53: lcd_d <= 8'b10000000;
			8'd54: lcd_d <= 8'b10000000;
			8'd59: lcd_d <= 8'b10000000;
			8'd60: lcd_d <= 8'b11100000;
			8'd61: lcd_d <= 8'b10000000;
			8'd62: lcd_d <= 8'b10000000;
			8'd65: lcd_d <= 8'b10000000;
			8'd66: lcd_d <= 8'b10000000;
			8'd67: lcd_d <= 8'b10000000;
			8'd75: lcd_d <= 8'b11110000;
			8'd79: lcd_d <= 8'b10000000;
			8'd80: lcd_d <= 8'b10000000;
			8'd81: lcd_d <= 8'b10000000;
			8'd82: lcd_d <= 8'b10000000;
			8'd85: lcd_d <= 8'b10000000;
			8'd86: lcd_d <= 8'b10000000;
			8'd87: lcd_d <= 8'b10000000;
			8'd88: lcd_d <= 8'b10000000;
			8'd92: lcd_d <= 8'b10000000;
			8'd96: lcd_d <= 8'b10000000;
			8'd100: lcd_d <= 8'b10000000;
			8'd101: lcd_d <= 8'b10000000;
			8'd102: lcd_d <= 8'b10000000;
			default: lcd_d <= 8'b0;
		endcase
	3'd1:
		case(addr_y)
			8'd3: lcd_d <= 8'b00010000;
			8'd4: lcd_d <= 8'b00011111;
			8'd5: lcd_d <= 8'b00010000;
			8'd12: lcd_d <= 8'b00011111;
			8'd13: lcd_d <= 8'b00010000;
			8'd14: lcd_d <= 8'b00010000;
			8'd15: lcd_d <= 8'b00010000;
			8'd16: lcd_d <= 8'b00001111;
			8'd19: lcd_d <= 8'b00001111;
			8'd20: lcd_d <= 8'b00010010;
			8'd21: lcd_d <= 8'b00010010;
			8'd22: lcd_d <= 8'b00010010;
			8'd23: lcd_d <= 8'b00010011;
			8'd26: lcd_d <= 8'b01001111;
			8'd27: lcd_d <= 8'b01010000;
			8'd28: lcd_d <= 8'b01010000;
			8'd29: lcd_d <= 8'b01010000;
			8'd30: lcd_d <= 8'b00111111;
			8'd37: lcd_d <= 8'b00011111;
			8'd41: lcd_d <= 8'b00011111;
			8'd44: lcd_d <= 8'b00001111;
			8'd45: lcd_d <= 8'b00010010;
			8'd46: lcd_d <= 8'b00010010;
			8'd47: lcd_d <= 8'b00010010;
			8'd48: lcd_d <= 8'b00010011;
			8'd51: lcd_d <= 8'b00011111;
			8'd52: lcd_d <= 8'b00000001;
			8'd60: lcd_d <= 8'b00011111;
			8'd61: lcd_d <= 8'b00010000;
			8'd62: lcd_d <= 8'b00010000;
			8'd64: lcd_d <= 8'b00001111;
			8'd65: lcd_d <= 8'b00010000;
			8'd66: lcd_d <= 8'b00010000;
			8'd67: lcd_d <= 8'b00010000;
			8'd68: lcd_d <= 8'b00001111;
			8'd75: lcd_d <= 8'b00011111;
			8'd78: lcd_d <= 8'b00001111;
			8'd79: lcd_d <= 8'b00010010;
			8'd80: lcd_d <= 8'b00010010;
			8'd81: lcd_d <= 8'b00010010;
			8'd82: lcd_d <= 8'b00010011;
			8'd85: lcd_d <= 8'b00011100;
			8'd86: lcd_d <= 8'b00010010;
			8'd87: lcd_d <= 8'b00010010;
			8'd88: lcd_d <= 8'b00010010;
			8'd89: lcd_d <= 8'b00011111;
			8'd92: lcd_d <= 8'b00000011;
			8'd93: lcd_d <= 8'b00000100;
			8'd94: lcd_d <= 8'b00011000;
			8'd95: lcd_d <= 8'b00001100;
			8'd96: lcd_d <= 8'b00000001;
			8'd99: lcd_d <= 8'b00001111;
			8'd100: lcd_d <= 8'b00010010;
			8'd101: lcd_d <= 8'b00010010;
			8'd102: lcd_d <= 8'b00010010;
			8'd103: lcd_d <= 8'b00010011;
			default: lcd_d <= 8'b0;
		endcase
	3'd2:
		case(addr_y)
			8'd3: lcd_d <= 8'b11000000;
			8'd4: lcd_d <= 8'b01000000;
			8'd5: lcd_d <= 8'b01000000;
			8'd6: lcd_d <= 8'b01000000;
			8'd7: lcd_d <= 8'b10000000;
			8'd8: lcd_d <= 8'b01000000;
			8'd9: lcd_d <= 8'b01000000;
			8'd10: lcd_d <= 8'b01000000;
			8'd11: lcd_d <= 8'b10000000;
			8'd14: lcd_d <= 8'b11000000;
			8'd18: lcd_d <= 8'b11000000;
			8'd25: lcd_d <= 8'b10000000;
			8'd26: lcd_d <= 8'b01000000;
			8'd27: lcd_d <= 8'b01000000;
			8'd28: lcd_d <= 8'b01000000;
			8'd29: lcd_d <= 8'b11111000;
			8'd32: lcd_d <= 8'b11000000;
			8'd33: lcd_d <= 8'b10000000;
			8'd34: lcd_d <= 8'b01000000;
			8'd35: lcd_d <= 8'b01000000;
			8'd37: lcd_d <= 8'b10000000;
			8'd38: lcd_d <= 8'b01000000;
			8'd39: lcd_d <= 8'b01000000;
			8'd40: lcd_d <= 8'b01000000;
			8'd41: lcd_d <= 8'b11000000;
			8'd44: lcd_d <= 8'b01000000;
			8'd45: lcd_d <= 8'b01000000;
			8'd46: lcd_d <= 8'b01000000;
			8'd47: lcd_d <= 8'b01000000;
			8'd48: lcd_d <= 8'b10000000;
			8'd51: lcd_d <= 8'b11000000;
			8'd52: lcd_d <= 8'b01000000;
			8'd53: lcd_d <= 8'b01000000;
			8'd54: lcd_d <= 8'b01000000;
			8'd55: lcd_d <= 8'b10000000;
			8'd56: lcd_d <= 8'b01000000;
			8'd57: lcd_d <= 8'b01000000;
			8'd58: lcd_d <= 8'b01000000;
			8'd59: lcd_d <= 8'b10000000;
			default: lcd_d <= 8'b0;
		endcase
	3'd3:
		case(addr_y)
			8'd3: lcd_d <= 8'b00001111;
			8'd7: lcd_d <= 8'b00001111;
			8'd11: lcd_d <= 8'b00001111;
			8'd15: lcd_d <= 8'b00100110;
			8'd16: lcd_d <= 8'b00001100;
			8'd17: lcd_d <= 8'b00000011;
			8'd25: lcd_d <= 8'b00000111;
			8'd26: lcd_d <= 8'b00001000;
			8'd27: lcd_d <= 8'b00001000;
			8'd28: lcd_d <= 8'b00001000;
			8'd29: lcd_d <= 8'b00001111;
			8'd32: lcd_d <= 8'b00001111;
			8'd37: lcd_d <= 8'b00000111;
			8'd38: lcd_d <= 8'b00001001;
			8'd39: lcd_d <= 8'b00001001;
			8'd40: lcd_d <= 8'b00001001;
			8'd41: lcd_d <= 8'b00001001;
			8'd44: lcd_d <= 8'b00001110;
			8'd45: lcd_d <= 8'b00001001;
			8'd46: lcd_d <= 8'b00001001;
			8'd47: lcd_d <= 8'b00001001;
			8'd48: lcd_d <= 8'b00001111;
			8'd51: lcd_d <= 8'b00001111;
			8'd55: lcd_d <= 8'b00001111;
			8'd59: lcd_d <= 8'b00001111;
			8'd62: lcd_d <= 8'b00001100;
			8'd63: lcd_d <= 8'b00001100;
			default: lcd_d <= 8'b0;
		endcase
	3'd4:
		case(addr_y)
			8'd3: lcd_d <= 8'b00110000;
			8'd4: lcd_d <= 8'b01001000;
			8'd5: lcd_d <= 8'b01001000;
			8'd6: lcd_d <= 8'b10001000;
			8'd7: lcd_d <= 8'b10001000;
			8'd8: lcd_d <= 8'b10011000;
			8'd11: lcd_d <= 8'b11111100;
			8'd12: lcd_d <= 8'b00100000;
			8'd13: lcd_d <= 8'b00100000;
			8'd14: lcd_d <= 8'b00100000;
			8'd15: lcd_d <= 8'b11100000;
			8'd18: lcd_d <= 8'b11000000;
			8'd19: lcd_d <= 8'b10100000;
			8'd20: lcd_d <= 8'b10100000;
			8'd21: lcd_d <= 8'b10100000;
			8'd22: lcd_d <= 8'b11000000;
			8'd29: lcd_d <= 8'b11100000;
			8'd30: lcd_d <= 8'b10100000;
			8'd31: lcd_d <= 8'b00100000;
			8'd32: lcd_d <= 8'b00100000;
			8'd35: lcd_d <= 8'b11100000;
			8'd36: lcd_d <= 8'b00100000;
			8'd37: lcd_d <= 8'b00100000;
			8'd38: lcd_d <= 8'b00100000;
			8'd39: lcd_d <= 8'b11000000;
			8'd41: lcd_d <= 8'b00100000;
			8'd42: lcd_d <= 8'b00100000;
			8'd43: lcd_d <= 8'b11000000;
			8'd46: lcd_d <= 8'b11100100;
			8'd49: lcd_d <= 8'b11111100;
			8'd52: lcd_d <= 8'b11000000;
			8'd53: lcd_d <= 8'b10100000;
			8'd54: lcd_d <= 8'b10100000;
			8'd55: lcd_d <= 8'b10100000;
			8'd56: lcd_d <= 8'b11100000;
			8'd59: lcd_d <= 8'b11100000;
			8'd60: lcd_d <= 8'b10100000;
			8'd61: lcd_d <= 8'b00100000;
			8'd62: lcd_d <= 8'b00100000;
			default: lcd_d <= 8'b0;
		endcase
	3'd5:
		case(addr_y)
			8'd3: lcd_d <= 8'b00000110;
			8'd4: lcd_d <= 8'b00000100;
			8'd5: lcd_d <= 8'b00000100;
			8'd6: lcd_d <= 8'b00000100;
			8'd7: lcd_d <= 8'b00000100;
			8'd8: lcd_d <= 8'b00000011;
			8'd11: lcd_d <= 8'b00000111;
			8'd15: lcd_d <= 8'b00000111;
			8'd18: lcd_d <= 8'b00000011;
			8'd19: lcd_d <= 8'b00000100;
			8'd20: lcd_d <= 8'b00000100;
			8'd21: lcd_d <= 8'b00000100;
			8'd22: lcd_d <= 8'b00000100;
			8'd29: lcd_d <= 8'b00000100;
			8'd30: lcd_d <= 8'b00000100;
			8'd31: lcd_d <= 8'b00000101;
			8'd32: lcd_d <= 8'b00000101;
			8'd35: lcd_d <= 8'b00000111;
			8'd39: lcd_d <= 8'b00000111;
			8'd43: lcd_d <= 8'b00000111;
			8'd46: lcd_d <= 8'b00000111;
			8'd49: lcd_d <= 8'b00000111;
			8'd52: lcd_d <= 8'b00000011;
			8'd53: lcd_d <= 8'b00000100;
			8'd54: lcd_d <= 8'b00000100;
			8'd55: lcd_d <= 8'b00000100;
			8'd56: lcd_d <= 8'b00000100;
			8'd59: lcd_d <= 8'b00000100;
			8'd60: lcd_d <= 8'b00000100;
			8'd61: lcd_d <= 8'b00000101;
			8'd62: lcd_d <= 8'b00000101;
			default: lcd_d <= 8'b0;
		endcase
	3'd6:
		case(addr_y)
			8'd3: lcd_d <= 8'b10010000;
			8'd4: lcd_d <= 8'b01010000;
			8'd5: lcd_d <= 8'b01010000;
			8'd6: lcd_d <= 8'b01010000;
			8'd7: lcd_d <= 8'b11100000;
			8'd10: lcd_d <= 8'b11110000;
			8'd11: lcd_d <= 8'b00010000;
			8'd12: lcd_d <= 8'b00010000;
			8'd13: lcd_d <= 8'b00010000;
			8'd14: lcd_d <= 8'b11100000;
			8'd17: lcd_d <= 8'b11100000;
			8'd18: lcd_d <= 8'b00010000;
			8'd19: lcd_d <= 8'b00010000;
			8'd20: lcd_d <= 8'b00010000;
			8'd21: lcd_d <= 8'b11111110;
			8'd28: lcd_d <= 8'b11111110;
			8'd31: lcd_d <= 8'b11100000;
			8'd32: lcd_d <= 8'b01010000;
			8'd33: lcd_d <= 8'b01010000;
			8'd34: lcd_d <= 8'b01010000;
			8'd35: lcd_d <= 8'b01100000;
			8'd37: lcd_d <= 8'b00010000;
			8'd38: lcd_d <= 8'b11111100;
			8'd39: lcd_d <= 8'b00010000;
			8'd40: lcd_d <= 8'b00010000;
			8'd46: lcd_d <= 8'b11100000;
			8'd47: lcd_d <= 8'b01010000;
			8'd48: lcd_d <= 8'b01010000;
			8'd49: lcd_d <= 8'b01010000;
			8'd50: lcd_d <= 8'b01100000;
			8'd53: lcd_d <= 8'b00110000;
			8'd54: lcd_d <= 8'b10000000;
			8'd56: lcd_d <= 8'b10000000;
			8'd57: lcd_d <= 8'b00110000;
			8'd60: lcd_d <= 8'b11110010;
			8'd63: lcd_d <= 8'b11111110;
			8'd66: lcd_d <= 8'b01100000;
			8'd67: lcd_d <= 8'b01010000;
			8'd68: lcd_d <= 8'b10010000;
			8'd69: lcd_d <= 8'b10010000;
			8'd76: lcd_d <= 8'b11100000;
			8'd77: lcd_d <= 8'b00010000;
			8'd78: lcd_d <= 8'b00010000;
			8'd79: lcd_d <= 8'b00010000;
			8'd80: lcd_d <= 8'b00100000;
			8'd82: lcd_d <= 8'b11100000;
			8'd83: lcd_d <= 8'b00010000;
			8'd84: lcd_d <= 8'b00010000;
			8'd85: lcd_d <= 8'b00010000;
			8'd86: lcd_d <= 8'b10100000;
			8'd89: lcd_d <= 8'b11110000;
			8'd90: lcd_d <= 8'b00010000;
			8'd91: lcd_d <= 8'b00010000;
			8'd92: lcd_d <= 8'b00010000;
			8'd93: lcd_d <= 8'b11100000;
			8'd94: lcd_d <= 8'b00010000;
			8'd95: lcd_d <= 8'b00010000;
			8'd96: lcd_d <= 8'b00010000;
			8'd97: lcd_d <= 8'b11110000;
			8'd100: lcd_d <= 8'b11100000;
			8'd101: lcd_d <= 8'b01010000;
			8'd102: lcd_d <= 8'b01010000;
			8'd103: lcd_d <= 8'b01010000;
			8'd104: lcd_d <= 8'b01100000;
			default: lcd_d <= 8'b0;
		endcase
	3'd7:
		case(addr_y)
			8'd3: lcd_d <= 8'b00000011;
			8'd4: lcd_d <= 8'b00000010;
			8'd5: lcd_d <= 8'b00000010;
			8'd6: lcd_d <= 8'b00000010;
			8'd7: lcd_d <= 8'b00000011;
			8'd10: lcd_d <= 8'b00000011;
			8'd14: lcd_d <= 8'b00000001;
			8'd17: lcd_d <= 8'b00000001;
			8'd18: lcd_d <= 8'b00000010;
			8'd19: lcd_d <= 8'b00000010;
			8'd20: lcd_d <= 8'b00000010;
			8'd21: lcd_d <= 8'b00000011;
			8'd28: lcd_d <= 8'b00000011;
			8'd31: lcd_d <= 8'b00000001;
			8'd32: lcd_d <= 8'b00000010;
			8'd33: lcd_d <= 8'b00000010;
			8'd34: lcd_d <= 8'b00000010;
			8'd35: lcd_d <= 8'b00000010;
			8'd38: lcd_d <= 8'b00000011;
			8'd39: lcd_d <= 8'b00000010;
			8'd40: lcd_d <= 8'b00000010;
			8'd46: lcd_d <= 8'b00000001;
			8'd47: lcd_d <= 8'b00000010;
			8'd48: lcd_d <= 8'b00000010;
			8'd49: lcd_d <= 8'b00000010;
			8'd50: lcd_d <= 8'b00000010;
			8'd54: lcd_d <= 8'b00000001;
			8'd55: lcd_d <= 8'b00000011;
			8'd56: lcd_d <= 8'b00000001;
			8'd60: lcd_d <= 8'b00000011;
			8'd63: lcd_d <= 8'b00000011;
			8'd66: lcd_d <= 8'b00000010;
			8'd67: lcd_d <= 8'b00000010;
			8'd68: lcd_d <= 8'b00000010;
			8'd69: lcd_d <= 8'b00000010;
			8'd76: lcd_d <= 8'b00000001;
			8'd77: lcd_d <= 8'b00000010;
			8'd78: lcd_d <= 8'b00000010;
			8'd79: lcd_d <= 8'b00000010;
			8'd80: lcd_d <= 8'b00000011;
			8'd82: lcd_d <= 8'b00000001;
			8'd83: lcd_d <= 8'b00000010;
			8'd84: lcd_d <= 8'b00000010;
			8'd85: lcd_d <= 8'b00000010;
			8'd86: lcd_d <= 8'b00000001;
			8'd89: lcd_d <= 8'b00000011;
			8'd93: lcd_d <= 8'b00000011;
			8'd97: lcd_d <= 8'b00000011;
			8'd100: lcd_d <= 8'b00000001;
			8'd101: lcd_d <= 8'b00000010;
			8'd102: lcd_d <= 8'b00000010;
			8'd103: lcd_d <= 8'b00000010;
			8'd104: lcd_d <= 8'b00000010;
			8'd107: lcd_d <= 8'b00000011;
			8'd108: lcd_d <= 8'b00000011;
			default: lcd_d <= 8'b0;
		endcase
endcase

	end
	endtask
	
	task genPattern_3;
	begin
		if(addr_x==0 && addr_y >= Heart_addr_y && addr_y <= Heart_addr_y + 8 ) begin
			drawHeart();
		end else if((addr_y<8 || addr_y>120)&& (addr_x>1 && addr_x<6) ) begin
			drawDoor();
		end else if(addr_y >= obj_addr_y && addr_y <= obj_addr_y + 8 && (addr_x == obj_line / 8 || addr_x == (obj_line / 8) + 1)) begin
			drawObject();
		end else if(addr_y >= AI_addr_y && addr_y <= AI_addr_y + 8 && (addr_x == AI_line / 8 || addr_x == (AI_line / 8) + 1)) begin
			drawAI();
		end else if(addr_y >= (ball_addr_y) && addr_y <= (ball_addr_y + 8) && (addr_x == ball_line / 8 || addr_x == (ball_line / 8) + 1)) begin
			drawBall(); 
		end else if(addr_y >= (shadow_addr_y) && addr_y <= (shadow_addr_y + 8) && (addr_x == shadow_line / 8 || addr_x == (shadow_line / 8) + 1)) begin
			drawShadow();
		end else begin
			lcd_d <= 8'b0;
		end
	end
	endtask
	
	task genPattern_4;
	begin
case(addr_x)
	3'd0:
		case(addr_y)
			default: lcd_d <= 8'b0;
		endcase
	3'd1:
		case(addr_y)
			8'd4: lcd_d <= 8'b00000010;
			8'd5: lcd_d <= 8'b11111110;
			8'd6: lcd_d <= 8'b00000010;
			8'd9: lcd_d <= 8'b00000011;
			8'd12: lcd_d <= 8'b11111000;
			8'd13: lcd_d <= 8'b00001000;
			8'd14: lcd_d <= 8'b00001000;
			8'd15: lcd_d <= 8'b00001000;
			8'd16: lcd_d <= 8'b11110000;
			8'd18: lcd_d <= 8'b00001000;
			8'd19: lcd_d <= 8'b00001000;
			8'd20: lcd_d <= 8'b11110000;
			8'd27: lcd_d <= 8'b11110000;
			8'd28: lcd_d <= 8'b00001000;
			8'd29: lcd_d <= 8'b00001000;
			8'd30: lcd_d <= 8'b00001000;
			8'd31: lcd_d <= 8'b11111000;
			8'd34: lcd_d <= 8'b11110000;
			8'd35: lcd_d <= 8'b00001000;
			8'd36: lcd_d <= 8'b00001000;
			8'd37: lcd_d <= 8'b00001000;
			8'd38: lcd_d <= 8'b11110000;
			8'd41: lcd_d <= 8'b11111001;
			8'd44: lcd_d <= 8'b11111000;
			8'd45: lcd_d <= 8'b00001000;
			8'd46: lcd_d <= 8'b00001000;
			8'd47: lcd_d <= 8'b00001000;
			8'd48: lcd_d <= 8'b11110000;
			8'd51: lcd_d <= 8'b11110000;
			8'd52: lcd_d <= 8'b00001000;
			8'd53: lcd_d <= 8'b00001000;
			8'd54: lcd_d <= 8'b00001000;
			8'd55: lcd_d <= 8'b11111000;
			8'd61: lcd_d <= 8'b00001000;
			8'd62: lcd_d <= 8'b11111110;
			8'd63: lcd_d <= 8'b00001000;
			8'd64: lcd_d <= 8'b00001000;
			8'd66: lcd_d <= 8'b11110000;
			8'd67: lcd_d <= 8'b00001000;
			8'd68: lcd_d <= 8'b00001000;
			8'd69: lcd_d <= 8'b00001000;
			8'd70: lcd_d <= 8'b11110000;
			8'd77: lcd_d <= 8'b11110000;
			8'd78: lcd_d <= 8'b00101000;
			8'd79: lcd_d <= 8'b00101000;
			8'd80: lcd_d <= 8'b00101000;
			8'd81: lcd_d <= 8'b00110000;
			8'd84: lcd_d <= 8'b00111000;
			8'd85: lcd_d <= 8'b00101000;
			8'd86: lcd_d <= 8'b01001000;
			8'd87: lcd_d <= 8'b01001000;
			8'd90: lcd_d <= 8'b11110000;
			8'd91: lcd_d <= 8'b00001000;
			8'd92: lcd_d <= 8'b00001000;
			8'd93: lcd_d <= 8'b00001000;
			8'd94: lcd_d <= 8'b10010000;
			8'd96: lcd_d <= 8'b11001000;
			8'd97: lcd_d <= 8'b00101000;
			8'd98: lcd_d <= 8'b00101000;
			8'd99: lcd_d <= 8'b00101000;
			8'd100: lcd_d <= 8'b11110000;
			8'd103: lcd_d <= 8'b11111000;
			8'd104: lcd_d <= 8'b00001000;
			8'd105: lcd_d <= 8'b00001000;
			8'd106: lcd_d <= 8'b00001000;
			8'd107: lcd_d <= 8'b11110000;
			8'd108: lcd_d <= 8'b00100000;
			8'd110: lcd_d <= 8'b11110000;
			8'd111: lcd_d <= 8'b00101000;
			8'd112: lcd_d <= 8'b00101000;
			8'd113: lcd_d <= 8'b00101000;
			8'd114: lcd_d <= 8'b00110000;
			8'd117: lcd_d <= 8'b10000000;
			8'd118: lcd_d <= 8'b10000000;
			default: lcd_d <= 8'b0;
		endcase
	3'd2:
		case(addr_y)
			8'd4: lcd_d <= 8'b00000001;
			8'd5: lcd_d <= 8'b00000001;
			8'd6: lcd_d <= 8'b00000001;
			8'd12: lcd_d <= 8'b10000001;
			8'd16: lcd_d <= 8'b00000001;
			8'd20: lcd_d <= 8'b00000001;
			8'd27: lcd_d <= 8'b00000100;
			8'd28: lcd_d <= 8'b00000101;
			8'd29: lcd_d <= 8'b00000101;
			8'd30: lcd_d <= 8'b00000101;
			8'd31: lcd_d <= 8'b00000011;
			8'd35: lcd_d <= 8'b00000001;
			8'd36: lcd_d <= 8'b00000001;
			8'd37: lcd_d <= 8'b00000001;
			8'd41: lcd_d <= 8'b00000001;
			8'd44: lcd_d <= 8'b00000001;
			8'd48: lcd_d <= 8'b00000001;
			8'd51: lcd_d <= 8'b00000100;
			8'd52: lcd_d <= 8'b00000101;
			8'd53: lcd_d <= 8'b00000101;
			8'd54: lcd_d <= 8'b00000101;
			8'd55: lcd_d <= 8'b00000011;
			8'd63: lcd_d <= 8'b00000001;
			8'd64: lcd_d <= 8'b00000001;
			8'd67: lcd_d <= 8'b00000001;
			8'd68: lcd_d <= 8'b00000001;
			8'd69: lcd_d <= 8'b00000001;
			8'd78: lcd_d <= 8'b00000001;
			8'd79: lcd_d <= 8'b00000001;
			8'd80: lcd_d <= 8'b00000001;
			8'd81: lcd_d <= 8'b00000001;
			8'd84: lcd_d <= 8'b00000001;
			8'd85: lcd_d <= 8'b00000001;
			8'd86: lcd_d <= 8'b00000001;
			8'd87: lcd_d <= 8'b00000001;
			8'd91: lcd_d <= 8'b00000001;
			8'd92: lcd_d <= 8'b00000001;
			8'd93: lcd_d <= 8'b00000001;
			8'd96: lcd_d <= 8'b00000001;
			8'd97: lcd_d <= 8'b00000001;
			8'd98: lcd_d <= 8'b00000001;
			8'd99: lcd_d <= 8'b00000001;
			8'd100: lcd_d <= 8'b00000001;
			8'd103: lcd_d <= 8'b00000111;
			8'd104: lcd_d <= 8'b00000001;
			8'd105: lcd_d <= 8'b00000001;
			8'd106: lcd_d <= 8'b00000001;
			8'd111: lcd_d <= 8'b00000001;
			8'd112: lcd_d <= 8'b00000001;
			8'd113: lcd_d <= 8'b00000001;
			8'd114: lcd_d <= 8'b00000001;
			8'd117: lcd_d <= 8'b00000001;
			8'd118: lcd_d <= 8'b00000001;
			default: lcd_d <= 8'b0;
		endcase
	3'd3:
		case(addr_y)
			8'd4: lcd_d <= 8'b11001110;
			8'd5: lcd_d <= 8'b10001001;
			8'd6: lcd_d <= 8'b10001001;
			8'd7: lcd_d <= 8'b10010001;
			8'd8: lcd_d <= 8'b10010001;
			8'd9: lcd_d <= 8'b01110011;
			8'd12: lcd_d <= 8'b11111111;
			8'd13: lcd_d <= 8'b00000100;
			8'd14: lcd_d <= 8'b00000100;
			8'd15: lcd_d <= 8'b00000100;
			8'd16: lcd_d <= 8'b11111000;
			8'd19: lcd_d <= 8'b01111000;
			8'd20: lcd_d <= 8'b10010100;
			8'd21: lcd_d <= 8'b10010100;
			8'd22: lcd_d <= 8'b10010100;
			8'd23: lcd_d <= 8'b10011000;
			8'd30: lcd_d <= 8'b10011100;
			8'd31: lcd_d <= 8'b10010100;
			8'd32: lcd_d <= 8'b10100100;
			8'd33: lcd_d <= 8'b10100100;
			8'd34: lcd_d <= 8'b01000000;
			8'd35: lcd_d <= 8'b00000100;
			8'd36: lcd_d <= 8'b11111111;
			8'd37: lcd_d <= 8'b10000100;
			8'd38: lcd_d <= 8'b10000100;
			8'd40: lcd_d <= 8'b11100100;
			8'd41: lcd_d <= 8'b10010100;
			8'd42: lcd_d <= 8'b10010100;
			8'd43: lcd_d <= 8'b10010100;
			8'd44: lcd_d <= 8'b11111000;
			8'd47: lcd_d <= 8'b11111100;
			8'd48: lcd_d <= 8'b00001000;
			8'd49: lcd_d <= 8'b00000100;
			8'd50: lcd_d <= 8'b00000100;
			8'd52: lcd_d <= 8'b01111000;
			8'd53: lcd_d <= 8'b10010100;
			8'd54: lcd_d <= 8'b10010100;
			8'd55: lcd_d <= 8'b10010100;
			8'd56: lcd_d <= 8'b10011000;
			8'd59: lcd_d <= 8'b10011100;
			8'd60: lcd_d <= 8'b10010100;
			8'd61: lcd_d <= 8'b10100100;
			8'd62: lcd_d <= 8'b10100100;
			8'd69: lcd_d <= 8'b01100100;
			8'd70: lcd_d <= 8'b10010100;
			8'd71: lcd_d <= 8'b10010100;
			8'd72: lcd_d <= 8'b10010100;
			8'd73: lcd_d <= 8'b11111000;
			8'd75: lcd_d <= 8'b00000100;
			8'd76: lcd_d <= 8'b11111111;
			8'd77: lcd_d <= 8'b10000100;
			8'd78: lcd_d <= 8'b10000100;
			8'd84: lcd_d <= 8'b11111100;
			8'd85: lcd_d <= 8'b00000100;
			8'd86: lcd_d <= 8'b00000100;
			8'd87: lcd_d <= 8'b00000100;
			8'd88: lcd_d <= 8'b11111000;
			8'd89: lcd_d <= 8'b00000100;
			8'd90: lcd_d <= 8'b00000100;
			8'd91: lcd_d <= 8'b00000100;
			8'd92: lcd_d <= 8'b11111000;
			8'd95: lcd_d <= 8'b01111000;
			8'd96: lcd_d <= 8'b10010100;
			8'd97: lcd_d <= 8'b10010100;
			8'd98: lcd_d <= 8'b10010100;
			8'd99: lcd_d <= 8'b10011000;
			default: lcd_d <= 8'b0;
		endcase
	3'd4:
		case(addr_y)
			8'd22: lcd_d <= 8'b11000000;
			8'd40: lcd_d <= 8'b01000000;
			default: lcd_d <= 8'b0;
		endcase
	3'd5:
		case(addr_y)
			8'd4: lcd_d <= 8'b00110010;
			8'd5: lcd_d <= 8'b01001010;
			8'd6: lcd_d <= 8'b01001010;
			8'd7: lcd_d <= 8'b01001010;
			8'd8: lcd_d <= 8'b01111100;
			8'd11: lcd_d <= 8'b01111110;
			8'd12: lcd_d <= 8'b00000010;
			8'd13: lcd_d <= 8'b00000010;
			8'd14: lcd_d <= 8'b00000010;
			8'd15: lcd_d <= 8'b01111110;
			8'd18: lcd_d <= 8'b00111100;
			8'd19: lcd_d <= 8'b01000010;
			8'd20: lcd_d <= 8'b01000010;
			8'd21: lcd_d <= 8'b01000010;
			8'd22: lcd_d <= 8'b01111111;
			8'd29: lcd_d <= 8'b00111100;
			8'd30: lcd_d <= 8'b01000010;
			8'd31: lcd_d <= 8'b01000010;
			8'd32: lcd_d <= 8'b01000010;
			8'd33: lcd_d <= 8'b00100100;
			8'd35: lcd_d <= 8'b01111110;
			8'd36: lcd_d <= 8'b00000100;
			8'd37: lcd_d <= 8'b00000010;
			8'd38: lcd_d <= 8'b00000010;
			8'd40: lcd_d <= 8'b01111110;
			8'd43: lcd_d <= 8'b00111100;
			8'd44: lcd_d <= 8'b01001010;
			8'd45: lcd_d <= 8'b01001010;
			8'd46: lcd_d <= 8'b01001010;
			8'd47: lcd_d <= 8'b01001100;
			8'd50: lcd_d <= 8'b01001110;
			8'd51: lcd_d <= 8'b01001010;
			8'd52: lcd_d <= 8'b01010010;
			8'd53: lcd_d <= 8'b01010010;
			8'd56: lcd_d <= 8'b01000000;
			8'd57: lcd_d <= 8'b01100000;
			default: lcd_d <= 8'b0;
		endcase
	3'd6:
		case(addr_y)
			default: lcd_d <= 8'b0;
		endcase
	3'd7:
		case(addr_y)
			default: lcd_d <= 8'b0;
		endcase
endcase
	end
	endtask
	
	task genPattern_5;
	begin
		if(addr_x==0 && addr_y >= Heart_addr_y && addr_y <= Heart_addr_y + 8 ) begin
			drawHeart();
		end else if((addr_y<8 || addr_y>120)&& (addr_x>1 && addr_x<6) ) begin
			drawDoor();
		end else if(addr_y >= obj_addr_y && addr_y <= obj_addr_y + 8 && (addr_x == obj_line / 8 || addr_x == (obj_line / 8) + 1)) begin
			drawObject();
		end else if(addr_y >= AI_addr_y && addr_y <= AI_addr_y + 8 && (addr_x == AI_line / 8 || addr_x == (AI_line / 8) + 1)) begin
			drawAI();
		end /*else if(addr_y >= (ball_addr_y) && addr_y <= (ball_addr_y + 8) && (addr_x == ball_line / 8 || addr_x == (ball_line / 8) + 1)) begin
			drawBall(); 
		end */else begin
			lcd_d <= 8'b0;
		end
		if(obj_line==AI_line && obj_addr_y==AI_addr_y)
			next_level();
	end
	endtask
	
	task genPattern_6;
	begin
case(addr_x)
	3'd0:
		case(addr_y)
			default: lcd_d <= 8'b0;
		endcase
	3'd1:
		case(addr_y)
			default: lcd_d <= 8'b0;
		endcase
	3'd2:
		case(addr_y)
			8'd52: lcd_d <= 8'b10000000;
			8'd53: lcd_d <= 8'b10000000;
			default: lcd_d <= 8'b0;
		endcase
	3'd3:
		case(addr_y)
			8'd19: lcd_d <= 8'b00000001;
			8'd20: lcd_d <= 8'b00000001;
			8'd21: lcd_d <= 8'b11111111;
			8'd22: lcd_d <= 8'b00000001;
			8'd23: lcd_d <= 8'b00000001;
			8'd30: lcd_d <= 8'b00111000;
			8'd31: lcd_d <= 8'b11100000;
			8'd33: lcd_d <= 8'b10000000;
			8'd34: lcd_d <= 8'b01110000;
			8'd35: lcd_d <= 8'b00111000;
			8'd36: lcd_d <= 8'b11100000;
			8'd38: lcd_d <= 8'b10000000;
			8'd39: lcd_d <= 8'b01111000;
			8'd43: lcd_d <= 8'b10000000;
			8'd44: lcd_d <= 8'b10011000;
			8'd45: lcd_d <= 8'b01001000;
			8'd46: lcd_d <= 8'b01001000;
			8'd47: lcd_d <= 8'b01001000;
			8'd48: lcd_d <= 8'b11111000;
			8'd49: lcd_d <= 8'b11100000;
			8'd52: lcd_d <= 8'b11111111;
			8'd53: lcd_d <= 8'b11111111;
			8'd54: lcd_d <= 8'b11000000;
			8'd55: lcd_d <= 8'b11100000;
			8'd56: lcd_d <= 8'b00110000;
			8'd57: lcd_d <= 8'b00010000;
			8'd58: lcd_d <= 8'b00001000;
			8'd59: lcd_d <= 8'b00001000;
			8'd61: lcd_d <= 8'b11100000;
			8'd62: lcd_d <= 8'b01010000;
			8'd63: lcd_d <= 8'b01001000;
			8'd64: lcd_d <= 8'b01001000;
			8'd65: lcd_d <= 8'b01001000;
			8'd66: lcd_d <= 8'b01011000;
			8'd67: lcd_d <= 8'b01110000;
			8'd75: lcd_d <= 8'b11111000;
			8'd76: lcd_d <= 8'b00011000;
			8'd80: lcd_d <= 8'b11011000;
			8'd81: lcd_d <= 8'b11111000;
			8'd84: lcd_d <= 8'b11111000;
			8'd85: lcd_d <= 8'b11111000;
			8'd87: lcd_d <= 8'b00001000;
			8'd88: lcd_d <= 8'b00001000;
			8'd89: lcd_d <= 8'b00011000;
			8'd90: lcd_d <= 8'b11110000;
			default: lcd_d <= 8'b0;
		endcase
	3'd4:
		case(addr_y)
			8'd19: lcd_d <= 8'b00000100;
			8'd20: lcd_d <= 8'b00000100;
			8'd21: lcd_d <= 8'b00000111;
			8'd22: lcd_d <= 8'b00000100;
			8'd23: lcd_d <= 8'b00000100;
			8'd31: lcd_d <= 8'b00000011;
			8'd32: lcd_d <= 8'b00000110;
			8'd33: lcd_d <= 8'b00000001;
			8'd36: lcd_d <= 8'b00000001;
			8'd37: lcd_d <= 8'b00000111;
			8'd38: lcd_d <= 8'b00000111;
			8'd43: lcd_d <= 8'b00000011;
			8'd44: lcd_d <= 8'b00000100;
			8'd45: lcd_d <= 8'b00000100;
			8'd46: lcd_d <= 8'b00000100;
			8'd47: lcd_d <= 8'b00000100;
			8'd48: lcd_d <= 8'b00000111;
			8'd49: lcd_d <= 8'b00000111;
			8'd52: lcd_d <= 8'b00000111;
			8'd53: lcd_d <= 8'b00000111;
			8'd56: lcd_d <= 8'b00000001;
			8'd57: lcd_d <= 8'b00000010;
			8'd58: lcd_d <= 8'b00000100;
			8'd59: lcd_d <= 8'b00000100;
			8'd61: lcd_d <= 8'b00000001;
			8'd62: lcd_d <= 8'b00000010;
			8'd63: lcd_d <= 8'b00000100;
			8'd64: lcd_d <= 8'b00000100;
			8'd65: lcd_d <= 8'b00000100;
			8'd66: lcd_d <= 8'b00000100;
			8'd67: lcd_d <= 8'b00000110;
			8'd75: lcd_d <= 8'b00000001;
			8'd76: lcd_d <= 8'b00000111;
			8'd77: lcd_d <= 8'b00000100;
			8'd78: lcd_d <= 8'b00000100;
			8'd79: lcd_d <= 8'b00000100;
			8'd80: lcd_d <= 8'b00000111;
			8'd81: lcd_d <= 8'b00000111;
			8'd84: lcd_d <= 8'b00111111;
			8'd85: lcd_d <= 8'b00111111;
			8'd86: lcd_d <= 8'b00000100;
			8'd87: lcd_d <= 8'b00000100;
			8'd88: lcd_d <= 8'b00000100;
			8'd89: lcd_d <= 8'b00000010;
			8'd90: lcd_d <= 8'b00000011;
			8'd94: lcd_d <= 8'b00000110;
			default: lcd_d <= 8'b0;
		endcase
	3'd5:
		case(addr_y)
			default: lcd_d <= 8'b0;
		endcase
	3'd6:
		case(addr_y)
			default: lcd_d <= 8'b0;
		endcase
	3'd7:
		case(addr_y)
			default: lcd_d <= 8'b0;
		endcase
endcase
	end
	endtask
	
	assign dis_y = addr_y-obj_addr_y;
	
	task drawObject;
		begin			
			if(addr_x == obj_line / 8) begin
				shift_x = (obj_line % 8);
				case(dir)
				3'b000: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN1_1 << shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN1_2 << shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN1_3 << shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN1_4 << shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN1_5 << shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN1_6 << shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN1_7 << shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN1_8 << shift_x;
					default: lcd_d <= 0;
					endcase				
				end
				3'b001: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN2_1 << shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN2_2 << shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN2_3 << shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN2_4 << shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN2_5 << shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN2_6 << shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN2_7 << shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN2_8 << shift_x;
					default: lcd_d <= 0;
					endcase			
				end
				3'b010: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN3_1 << shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN3_2 << shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN3_3 << shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN3_4 << shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN3_5 << shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN3_6 << shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN3_7 << shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN3_8 << shift_x;
					default: lcd_d <= 0;
					endcase						
				end
				3'b011: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN4_1 << shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN4_2 << shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN4_3 << shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN4_4 << shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN4_5 << shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN4_6 << shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN4_7 << shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN4_8 << shift_x;
					default: lcd_d <= 0;
					endcase						
				end
				3'b100: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN5_1 << shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN5_2 << shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN5_3 << shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN5_4 << shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN5_5 << shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN5_6 << shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN5_7 << shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN5_8 << shift_x;
					default: lcd_d <= 0;
					endcase						
				end
				3'b101: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN6_1 << shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN6_2 << shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN6_3 << shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN6_4 << shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN6_5 << shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN6_6 << shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN6_7 << shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN6_8 << shift_x;
					default: lcd_d <= 0;
					endcase						
				end
				3'b110: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN7_1 << shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN7_2 << shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN7_3 << shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN7_4 << shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN7_5 << shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN7_6 << shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN7_7 << shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN7_8 << shift_x;
					default: lcd_d <= 0;
					endcase						
				end
				3'b111: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN8_1 << shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN8_2 << shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN8_3 << shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN8_4 << shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN8_5 << shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN8_6 << shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN8_7 << shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN8_8 << shift_x;
					default: lcd_d <= 0;
					endcase						
				end
				default: ;
				endcase
				
			end else begin
				shift_x = (8 - obj_line % 8);
				case(dir)
				3'b000: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN1_1 >> shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN1_2 >> shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN1_3 >> shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN1_4 >> shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN1_5 >> shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN1_6 >> shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN1_7 >> shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN1_8 >> shift_x;
					default: lcd_d <= 0;
					endcase				
				end
				3'b001: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN2_1 >> shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN2_2 >> shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN2_3 >> shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN2_4 >> shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN2_5 >> shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN2_6 >> shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN2_7 >> shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN2_8 >> shift_x;
					default: lcd_d <= 0;
					endcase			
				end
				3'b010: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN3_1 >> shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN3_2 >> shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN3_3 >> shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN3_4 >> shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN3_5 >> shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN3_6 >> shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN3_7 >> shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN3_8 >> shift_x;
					default: lcd_d <= 0;
					endcase						
				end
				3'b011: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN4_1 >> shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN4_2 >> shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN4_3 >> shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN4_4 >> shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN4_5 >> shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN4_6 >> shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN4_7 >> shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN4_8 >> shift_x;
					default: lcd_d <= 0;
					endcase						
				end
				3'b100: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN5_1 >> shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN5_2 >> shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN5_3 >> shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN5_4 >> shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN5_5 >> shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN5_6 >> shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN5_7 >> shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN5_8 >> shift_x;
					default: lcd_d <= 0;
					endcase						
				end
				3'b101: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN6_1 >> shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN6_2 >> shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN6_3 >> shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN6_4 >> shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN6_5 >> shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN6_6 >> shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN6_7 >> shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN6_8 >> shift_x;
					default: lcd_d <= 0;
					endcase						
				end
				3'b110: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN7_1 >> shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN7_2 >> shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN7_3 >> shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN7_4 >> shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN7_5 >> shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN7_6 >> shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN7_7 >> shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN7_8 >> shift_x;
					default: lcd_d <= 0;
					endcase						
				end
				3'b111: begin
					case(dis_y)
					8'h0: lcd_d <= OBJECT_PATTERN8_1 >> shift_x;
					8'h1: lcd_d <= OBJECT_PATTERN8_2 >> shift_x;
					8'h2: lcd_d <= OBJECT_PATTERN8_3 >> shift_x;
					8'h3: lcd_d <= OBJECT_PATTERN8_4 >> shift_x;
					8'h4: lcd_d <= OBJECT_PATTERN8_5 >> shift_x;
					8'h5: lcd_d <= OBJECT_PATTERN8_6 >> shift_x;
					8'h6: lcd_d <= OBJECT_PATTERN8_7 >> shift_x;
					8'h7: lcd_d <= OBJECT_PATTERN8_8 >> shift_x;
					default: lcd_d <= 0;
					endcase						
				end
				default: ;
				endcase
			end
		end
	endtask
		
	task drawHeart;
		begin
			case(addr_y-Heart_addr_y)
					8'h0: lcd_d <= Heart_PATTERN1 ;
					8'h1: lcd_d <= Heart_PATTERN2 ;
					8'h2: lcd_d <= Heart_PATTERN3 ;
					8'h3: lcd_d <= Heart_PATTERN4 ;
					8'h4: lcd_d <= Heart_PATTERN5 ;
					8'h5: lcd_d <= Heart_PATTERN6 ;
					8'h6: lcd_d <= Heart_PATTERN7 ;
					8'h7: lcd_d <= Heart_PATTERN8 ;
					default: lcd_d <= 0;
			endcase	
		end
	endtask
	
	task drawDoor;
		if(addr_y%2==1)	lcd_d <= 8'b10101010;
		else lcd_d <= 8'b01010101;
	endtask
	
	task drawBall;
	begin		
		begin
			if(addr_x == ball_line / 8) begin
				shift_x = (ball_line % 8);
				case(addr_y-ball_addr_y)
					8'h0: lcd_d <= BALL_PATTERN1 << shift_x;
					8'h1: lcd_d <= BALL_PATTERN2 << shift_x;
					8'h2: lcd_d <= BALL_PATTERN3 << shift_x;
					8'h3: lcd_d <= BALL_PATTERN4 << shift_x;
					8'h4: lcd_d <= BALL_PATTERN5 << shift_x;
					8'h5: lcd_d <= BALL_PATTERN6 << shift_x;
					8'h6: lcd_d <= BALL_PATTERN7 << shift_x;
					8'h7: lcd_d <= BALL_PATTERN8 << shift_x;
					default: lcd_d <= 0;
				endcase	
			end
			else begin
				shift_x = (8 - ball_line % 8);
				case(addr_y-ball_addr_y)
					8'h0: lcd_d <= BALL_PATTERN1 >> shift_x;
					8'h1: lcd_d <= BALL_PATTERN2 >> shift_x;
					8'h2: lcd_d <= BALL_PATTERN3 >> shift_x;
					8'h3: lcd_d <= BALL_PATTERN4 >> shift_x;
					8'h4: lcd_d <= BALL_PATTERN5 >> shift_x;
					8'h5: lcd_d <= BALL_PATTERN6 >> shift_x;
					8'h6: lcd_d <= BALL_PATTERN7 >> shift_x;
					8'h7: lcd_d <= BALL_PATTERN8 >> shift_x;
					default: lcd_d <= 0;
				endcase	
			end
		end
	end
	endtask
	
	reg showShadow = 0;
	task drawShadow;
	begin
		if(showShadow)
		begin
			if(addr_x == shadow_line / 8) begin
				shift_x = (shadow_line % 8);
				case(addr_y-shadow_addr_y)
					8'h0: lcd_d <= S_PATTERN1 << shift_x;
					8'h1: lcd_d <= S_PATTERN2 << shift_x;
					8'h2: lcd_d <= S_PATTERN3 << shift_x;
					8'h3: lcd_d <= S_PATTERN4 << shift_x;
					8'h4: lcd_d <= S_PATTERN5 << shift_x;
					8'h5: lcd_d <= S_PATTERN6 << shift_x;
					8'h6: lcd_d <= S_PATTERN7 << shift_x;
					8'h7: lcd_d <= S_PATTERN8 << shift_x;
					default: lcd_d <= 0;
				endcase	
			end
			else begin
				shift_x = (8 - shadow_line % 8);
				case(addr_y-shadow_addr_y)
					8'h0: lcd_d <= S_PATTERN1 >> shift_x;
					8'h1: lcd_d <= S_PATTERN2 >> shift_x;
					8'h2: lcd_d <= S_PATTERN3 >> shift_x;
					8'h3: lcd_d <= S_PATTERN4 >> shift_x;
					8'h4: lcd_d <= S_PATTERN5 >> shift_x;
					8'h5: lcd_d <= S_PATTERN6 >> shift_x;
					8'h6: lcd_d <= S_PATTERN7 >> shift_x;
					8'h7: lcd_d <= S_PATTERN8 >> shift_x;
					default: lcd_d <= 0;
				endcase	
			end
		end
	end
	endtask
	
	task setShadow;
	begin
		showShadow = 1;
		shadow_addr_y <= ball_addr_y;
		shadow_line <= ball_line;
		shadow_speed_x = ball_speed_x;
		shadow_speed_y = ball_speed_y;
	end
	endtask
	
	parameter RANGE = 9;
	task ball_roll;
	begin
		if(ball_line+ ball_speed_x < 10 || ball_line+8 + ball_speed_x > 61) begin
			ball_inverse_speed_x();
			add_Heart();
			setShadow();
		end else if(ball_line+ball_speed_x-obj_line < RANGE) // ball touch player from down
			if(ball_addr_y+ball_speed_y-obj_addr_y < RANGE ) // ball from right
			begin
				add_Heart();
				if(ball_addr_y+ball_speed_y-obj_addr_y  > ball_line+ball_speed_x-obj_line )
				begin
					ball_addr_y <= obj_addr_y+RANGE;
					ball_inverse_speed_y();
				end else begin
					ball_line <= obj_line+RANGE;
					ball_inverse_speed_x();
				end
			end else if(obj_addr_y-ball_speed_y-ball_addr_y < RANGE) // ball from left
			begin
				add_Heart();
				if(obj_addr_y-ball_speed_y-ball_addr_y  > ball_line+ball_speed_x-obj_line )
				begin
					ball_addr_y <= obj_addr_y-RANGE;
					ball_inverse_speed_y();
				end else begin
					ball_line <= obj_line+RANGE;
					ball_inverse_speed_x();
				end
			end else ;
		else if(obj_line-ball_speed_x-ball_line < RANGE) // ball touch player from up
			if(ball_addr_y+ball_speed_y-obj_addr_y < RANGE ) // ball from right
			begin
				if(ball_addr_y+ball_speed_y-obj_addr_y  > obj_line-ball_speed_x-ball_line )
				begin
					ball_addr_y <= obj_addr_y+RANGE;
					ball_inverse_speed_y();
				end else begin
					ball_line <= obj_line-RANGE;
					ball_inverse_speed_x();
				end
			end else if(obj_addr_y-ball_speed_y-ball_addr_y < RANGE) // ball from left
			begin
				if(obj_addr_y-ball_speed_y-ball_addr_y  > obj_line-ball_speed_x-ball_line )
				begin
					ball_addr_y <= obj_addr_y-RANGE;
					ball_inverse_speed_y();
				end else begin
					ball_line <= obj_line-RANGE;
					ball_inverse_speed_x();
				end
			end else ;
		// ball touch AI
		else if(ball_line+ball_speed_x-AI_line < RANGE) // ball touch AI from down
			if(ball_addr_y+ball_speed_y-AI_addr_y < RANGE ) // ball from right
			begin
				add_Heart();
				if(ball_addr_y+ball_speed_y-AI_addr_y  > ball_line+ball_speed_x-AI_line )
				begin
					ball_addr_y <= AI_addr_y+RANGE;
					ball_inverse_speed_y();
				end else begin
					ball_line <= AI_line+RANGE;
					ball_inverse_speed_x();
				end
			end else if(AI_addr_y-ball_speed_y-ball_addr_y < RANGE) // ball from left
			begin
				add_Heart();
				if(AI_addr_y-ball_speed_y-ball_addr_y  > ball_line+ball_speed_x-AI_line )
				begin
					ball_addr_y <= AI_addr_y-RANGE;
					ball_inverse_speed_y();
				end else begin
					ball_line <= AI_line+RANGE;
					ball_inverse_speed_x();
				end
			end else ;
		else if(AI_line-ball_speed_x-ball_line < RANGE) // ball touch AI from up
			if(ball_addr_y+ball_speed_y-AI_addr_y < RANGE ) // ball from right
			begin
				if(ball_addr_y+ball_speed_y-AI_addr_y  > AI_line-ball_speed_x-ball_line )
				begin
					ball_addr_y <= AI_addr_y+RANGE;
					ball_inverse_speed_y();
				end else begin
					ball_line <= AI_line-RANGE;
					ball_inverse_speed_x();
				end
			end else if(AI_addr_y-ball_speed_y-ball_addr_y < RANGE) // ball from left
			begin
				if(AI_addr_y-ball_speed_y-ball_addr_y  > AI_line-ball_speed_x-ball_line )
				begin
					ball_addr_y <= AI_addr_y-RANGE;
					ball_inverse_speed_y();
				end else begin
					ball_line <= AI_line-RANGE;
					ball_inverse_speed_x();
				end
			end else ;
		else ;
		
		if(ball_addr_y + ball_speed_y < 3) begin
			ball_addr_y <= 3;
			if(ball_speed_y<0)
				ball_inverse_speed_y();
			else ;
			// ball into the door of AI
			if(ball_line+ ball_speed_x > 15 && ball_line+ ball_speed_x < 48) 
			begin
				if(Heart_addr_y<110)
					Heart_addr_y <= Heart_addr_y + 10;
				else next_level();
				ball_addr_y <= 60;
				ball_speed_y <= 2;
				ball_line <= 15;
				ball_speed_x <= 1;	
			end else begin
				Heart_addr_y <= Heart_addr_y + 1'b1;
				setShadow();
			end
		end else if(ball_addr_y + ball_speed_y > 120) begin
			ball_addr_y <= 120;
			if(ball_speed_y>0)
				ball_inverse_speed_y();
			else ;
			// ball into the door of Player_obj
			if(ball_line+ ball_speed_x > 15 && ball_line+ ball_speed_x < 48)
			begin
				if(Heart_addr_y>10)
					Heart_addr_y <= Heart_addr_y - 10;
				else ;
				ball_addr_y <= 60;
				ball_speed_y <= -2;
				ball_line <= 15;
				ball_speed_x <= 1;				
			end else begin
				Heart_addr_y <= Heart_addr_y + 1'b1;
				setShadow();
			end
		end else begin
			ball_addr_y <= ball_addr_y + ball_speed_y;
			ball_line <= ball_line + ball_speed_x;		
		end
	end
	endtask
	
	task add_Heart;
	begin
		if(Heart_addr_y<110)
			Heart_addr_y <= Heart_addr_y + 2;
		else next_level();
	end
	endtask
	
	task ball_inverse_speed_x;
	begin
		ball_speed_x <= ball_speed_x * (-1);
		ball_line <= ball_line + 2*ball_speed_x;
	end
	endtask
	
	task ball_inverse_speed_y;
	begin
		ball_speed_y <= ball_speed_y * (-1);
		ball_addr_y <= ball_addr_y + 2*ball_speed_y;
	end
	endtask
	
	task obj_move;
	begin
		// move Player
			obj_addr_y <= obj_addr_y+obj_speed_y;
			obj_line <= obj_line+obj_speed_x;
			if(obj_addr_y>120)
				obj_addr_y <= obj_addr_y - 1'b1;
			else if(obj_addr_y< 8)
				obj_addr_y <= obj_addr_y +1'b1;
			else;
			if(obj_line >55)
				obj_line <= obj_line - 1;
			else if(obj_line<10)
				obj_line <= obj_line + 1;
			else;
	end
	endtask
	
	task shadow_move;
	begin
		shadow_addr_y <= shadow_addr_y+shadow_speed_y;
		shadow_line <= shadow_line+shadow_speed_x;
		if(shadow_addr_y>120 || shadow_addr_y< 8 || obj_line >55 || obj_line<10) begin
			showShadow = 0;
		end else if((obj_addr_y-shadow_addr_y<RANGE || shadow_addr_y-obj_addr_y<RANGE) 
						&& ( shadow_line-obj_line<RANGE || obj_line-shadow_line<RANGE )) begin
			if(Heart_addr_y>10)	Heart_addr_y <= Heart_addr_y -10;
			showShadow = 0;
		end else ;
	end
	endtask
		
	task AI_move;
	begin
	if(ball_addr_y > AI_addr_y)
		if(AI_line < ball_line)
			AI_line <= AI_line + 1'b1;
		else if(AI_line > ball_line)
			AI_line <= AI_line - 1'b1;
		else ;
	else 
		if(AI_line < ball_line)
			AI_line <= AI_line - 1'b1;
		else if(AI_line > ball_line)
			AI_line <= AI_line + 1'b1;
		else ;
	end
	endtask
	
	reg [4:0]AI_delay=0;
	assign AI_dis_y = addr_y-AI_addr_y;
	task drawAI;
		begin
			AI_delay = AI_delay +1;
			if(AI_delay==0)
				AI_state <= AI_state + 1'b1;
			else ;
			if(addr_x == AI_line / 8) begin
				shift_x = (AI_line % 8);
				case(AI_state)
				2'b00:
					case(AI_dis_y)
					8'h0: lcd_d <= AI_PATTERN1_1 << shift_x;
					8'h1: lcd_d <= AI_PATTERN1_2 << shift_x;
					8'h2: lcd_d <= AI_PATTERN1_3 << shift_x;
					8'h3: lcd_d <= AI_PATTERN1_4 << shift_x;
					8'h4: lcd_d <= AI_PATTERN1_5 << shift_x;
					8'h5: lcd_d <= AI_PATTERN1_6 << shift_x;
					8'h6: lcd_d <= AI_PATTERN1_7 << shift_x;
					8'h7: lcd_d <= AI_PATTERN1_8 << shift_x;
					default: lcd_d <= 0;
					endcase	
				2'b01:
					case(AI_dis_y)
					8'h0: lcd_d <= AI_PATTERN2_1 << shift_x;
					8'h1: lcd_d <= AI_PATTERN2_2 << shift_x;
					8'h2: lcd_d <= AI_PATTERN2_3 << shift_x;
					8'h3: lcd_d <= AI_PATTERN2_4 << shift_x;
					8'h4: lcd_d <= AI_PATTERN2_5 << shift_x;
					8'h5: lcd_d <= AI_PATTERN2_6 << shift_x;
					8'h6: lcd_d <= AI_PATTERN2_7 << shift_x;
					8'h7: lcd_d <= AI_PATTERN2_8 << shift_x;
					default: lcd_d <= 0;
					endcase	
				2'b10:
					case(AI_dis_y)
					8'h0: lcd_d <= AI_PATTERN3_1 << shift_x;
					8'h1: lcd_d <= AI_PATTERN3_2 << shift_x;
					8'h2: lcd_d <= AI_PATTERN3_3 << shift_x;
					8'h3: lcd_d <= AI_PATTERN3_4 << shift_x;
					8'h4: lcd_d <= AI_PATTERN3_5 << shift_x;
					8'h5: lcd_d <= AI_PATTERN3_6 << shift_x;
					8'h6: lcd_d <= AI_PATTERN3_7 << shift_x;
					8'h7: lcd_d <= AI_PATTERN3_8 << shift_x;
					default: lcd_d <= 0;
					endcase	
				2'b11:
					case(AI_dis_y)
					8'h0: lcd_d <= AI_PATTERN1_1 << shift_x;
					8'h1: lcd_d <= AI_PATTERN1_2 << shift_x;
					8'h2: lcd_d <= AI_PATTERN1_3 << shift_x;
					8'h3: lcd_d <= AI_PATTERN1_4 << shift_x;
					8'h4: lcd_d <= AI_PATTERN1_5 << shift_x;
					8'h5: lcd_d <= AI_PATTERN1_6 << shift_x;
					8'h6: lcd_d <= AI_PATTERN1_7 << shift_x;
					8'h7: lcd_d <= AI_PATTERN1_8 << shift_x;
					default: lcd_d <= 0;
					endcase	
				default: lcd_d <= 0;
				endcase
			end else begin
				shift_x = (8 - AI_line % 8);		
				case(AI_state)
				2'b00:
					case(AI_dis_y)
					8'h0: lcd_d <= AI_PATTERN1_1 >> shift_x;
					8'h1: lcd_d <= AI_PATTERN1_2 >> shift_x;
					8'h2: lcd_d <= AI_PATTERN1_3 >> shift_x;
					8'h3: lcd_d <= AI_PATTERN1_4 >> shift_x;
					8'h4: lcd_d <= AI_PATTERN1_5 >> shift_x;
					8'h5: lcd_d <= AI_PATTERN1_6 >> shift_x;
					8'h6: lcd_d <= AI_PATTERN1_7 >> shift_x;
					8'h7: lcd_d <= AI_PATTERN1_8 >> shift_x;
					default: lcd_d <= 0;
					endcase
				2'b01:
					case(AI_dis_y)
					8'h0: lcd_d <= AI_PATTERN2_1 >> shift_x;
					8'h1: lcd_d <= AI_PATTERN2_2 >> shift_x;
					8'h2: lcd_d <= AI_PATTERN2_3 >> shift_x;
					8'h3: lcd_d <= AI_PATTERN2_4 >> shift_x;
					8'h4: lcd_d <= AI_PATTERN2_5 >> shift_x;
					8'h5: lcd_d <= AI_PATTERN2_6 >> shift_x;
					8'h6: lcd_d <= AI_PATTERN2_7 >> shift_x;
					8'h7: lcd_d <= AI_PATTERN2_8 >> shift_x;
					default: lcd_d <= 0;
					endcase
				2'b10:
					case(AI_dis_y)
					8'h0: lcd_d <= AI_PATTERN3_1 >> shift_x;
					8'h1: lcd_d <= AI_PATTERN3_2 >> shift_x;
					8'h2: lcd_d <= AI_PATTERN3_3 >> shift_x;
					8'h3: lcd_d <= AI_PATTERN3_4 >> shift_x;
					8'h4: lcd_d <= AI_PATTERN3_5 >> shift_x;
					8'h5: lcd_d <= AI_PATTERN3_6 >> shift_x;
					8'h6: lcd_d <= AI_PATTERN3_7 >> shift_x;
					8'h7: lcd_d <= AI_PATTERN3_8 >> shift_x;
					default: lcd_d <= 0;
					endcase
				2'b11:
					case(AI_dis_y)
					8'h0: lcd_d <= AI_PATTERN1_1 >> shift_x;
					8'h1: lcd_d <= AI_PATTERN1_2 >> shift_x;
					8'h2: lcd_d <= AI_PATTERN1_3 >> shift_x;
					8'h3: lcd_d <= AI_PATTERN1_4 >> shift_x;
					8'h4: lcd_d <= AI_PATTERN1_5 >> shift_x;
					8'h5: lcd_d <= AI_PATTERN1_6 >> shift_x;
					8'h6: lcd_d <= AI_PATTERN1_7 >> shift_x;
					8'h7: lcd_d <= AI_PATTERN1_8 >> shift_x;
					default: lcd_d <= 0;
					endcase
				default: lcd_d <= 0;
				endcase				
			end
		end
	endtask	
	
	task next_level;
	begin
			level <= level +1'b1;
			
			obj_addr_y <= 8'd110;
			obj_addr_x <= 3'o0;
			obj_line <= 6'd32;
			dir <= 0;
			obj_sprite_addr_y <= 0;
			line <= 6'b0;
			obj_speed_y = 0;
			obj_speed_x = 0;
			
			// Ball
			ball_addr_y <= 8'd10;
			ball_line <= 8'd10;
			ball_speed_y <= 2;
			ball_speed_x <= 1;
			ball_delay <= 0;
			
			// AI
			AI_addr_y <= 10;
			AI_line <= 30;
			AI_state <= 0;
			
			// Heart
			Heart_addr_y <= 10;
			
			showShadow = 0;
	end
	endtask	
	
endmodule
