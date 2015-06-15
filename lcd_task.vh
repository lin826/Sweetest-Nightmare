`ifndef _LCD_TASK_VH_
`define _LCD_TASK_VH_

`include "lcd.vh"

// diplay_on(ENABLE, STATE, LCD_DATA, LCD_RST)
task display_on;
	output reg [1:0] ENABLE;
	output reg [2:0] STATE;
	output reg [7:0] LCD_DATA;
	output reg LCD_RST;
	begin
		STATE <= `STATE_SET_STARTLINE;
		LCD_RST <= 1'b1; 
		LCD_DATA<= 8'h3F;
		ENABLE <= 2'b00; 
	end
endtask

// set_startline(line, enable, state, LCD_D)
task set_startline;
	input [5:0] LINE; 
	output reg [1:0] ENABLE;
	output reg [2:0] STATE;
	output reg [7:0] LCD_DATA;
	begin
		STATE <= `STATE_SET_Y_COUNTER;
		LCD_DATA <= `TEMPLATE_SET_STARTLINE | {2'b11, LINE};
		ENABLE <= 2'b00;
	end
endtask

// set_y_counter(enable, state, transition_state, LCD_D, y_addr)
task set_y_counter;
	output reg [1:0] ENABLE;
	output reg [2:0] STATE;
	output reg [7:0] LCD_DATA;
	input [5:0] Y_ADDR;
	begin
		STATE <= `STATE_SET_X_COUNTER; 
		LCD_DATA<= `TEMPLATE_SET_Y | Y_ADDR;
		ENABLE <= 2'b00;
	end
endtask

// set_x_counter(x_page, enable, state, LCD_DI, LCD_D, page_index)
task set_x_counter;
	input [2:0] X_PAGE;
	output reg [1:0] ENABLE;
	output reg [2:0] STATE;
	output reg LCD_DI;
	output reg [7:0] LCD_DATA;
	output reg [7:0] INDEX;
	begin
		LCD_DI <= `MODE_CMD;
		STATE <= `STATE_WRITE;
 		INDEX = 0; 
		LCD_DATA <= {5'b10111, X_PAGE}; 
		ENABLE <= 2'b00;
	end
endtask

// write_clear(x_page, enable, state, page_index, ram_select, LCD_D, LCD_DI, clear)
task write_clear;
	output reg [2:0] X_PAGE;
	output reg [1:0] ENABLE;
	output reg [2:0] STATE;
	output reg [7:0] INDEX;
	output reg [1:0] LCD_SEL;
	output reg [7:0] LCD_DATA;
	output reg LCD_DI;
	output reg CLEAR;
	begin
		LCD_SEL <= 2'b11;
		if(INDEX < `MAX_INDEX) begin 
			INDEX = INDEX + 8'h1;
			LCD_DI <= `MODE_DATA; 
			LCD_DATA<= 8'hFF; 
			ENABLE <= 2'b00; 
		end
		else if(X_PAGE < `MAX_PAGE) begin 
			STATE <= `STATE_SET_X_COUNTER; 
			X_PAGE <= X_PAGE + 3'o1; 
		end
		else begin 
			STATE <= `STATE_SET_X_COUNTER; 
			X_PAGE <= 3'o0; 
 			CLEAR <= 1'b0; 
		end
	end
endtask

`endif