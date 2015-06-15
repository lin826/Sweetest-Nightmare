`ifndef _ROBOT_VH_
`define _ROBOT_VH_

`include "keyboard.vh"

reg graph[63:0][127:0];

// graph_output(x_page, y_addr, keyboard, output_bit)
task graph_output;
	input [63:0] x_page;
	input [127:0] y_addr;
	input [15:0] ctrl_code_i;
	output reg output_bit;
	begin
		output_bit <= graph[x_page][y_addr]; 
	end
endtask


`endif