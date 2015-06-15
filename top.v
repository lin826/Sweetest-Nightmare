`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:07:12 05/11/2015 
// Design Name: 
// Module Name:    top 
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
module top(
	input clk,
	input rst_n,
	input  [0:3] col,
    output [3:0] row,
	output [7:0] LCD_data,
	output LCD_en,
	output LCD_rw,
	output LCD_rstn,
	output LCD_cs1,
	output LCD_cs2,
	output LCD_di,
    output audio_bck,
    output audio_ws,
    output audio_data,
    output audio_sysclk,
    output audio_appsel
    );
	 
	wire clock_1MHz,clock_100KHz,clock_10KHz,clock_1KHz,clock_100Hz,clock_10Hz,clock_1Hz;
	//wire [1:0] vir,hor;
	wire [15:0] audio_left,audio_right;
	wire [19:0] note_div;

	// clock divider
	clk_div c(clk, clock_1MHz, clock_100KHz, clock_10KHz, clock_1KHz, clock_100Hz, clock_10Hz, clock_1Hz);
	
	wire [15:0] keycode;
	Keyboard kb(
   .clk(clock_100KHz),
   .reset(rst_n),
   .col(col),
   .row(row),
   .keycode(keycode)
    );
	 	
	LCDController lcd_ctrl(
   .clk(clock_100KHz),
   .reset(rst_n),
	.ctrl_code_i(keycode),
	.lcd_d(LCD_data),
	.lcd_rst(LCD_rstn),
	.lcd_cs1(LCD_cs1),
	.lcd_cs2(LCD_cs2),
	.lcd_en(LCD_en),
	.lcd_wr(LCD_rw),
	.lcd_di(LCD_di));
	
	node_div_controller n_d_c(clock_10Hz, rst_n, note_div);
	
	note_generator_2 n_g(clk, rst_n, note_div, audio_left, audio_right);
	
	buzzer_control b_c(clk, rst_n, audio_left, audio_right, audio_appsel, audio_sysclk, audio_bck, audio_ws, audio_data);
	
endmodule
