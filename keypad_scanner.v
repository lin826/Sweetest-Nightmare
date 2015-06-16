// Read out the four most recently pressed keys and record them in a buffer

module keypad_scanner (clk, resetn, col, row, keycode);
  input clk, resetn;
  input [0:3] col;
  output reg [0:3] row;
  output reg [15:0] keycode;

  reg [3:0] key;
  reg pressed;
  reg [1:0] sel, sel_next;        // a repetitive counter for row-wise scan
  reg [4:0] pause, pause_next;    // a repetitive counter for pause
  reg [1:0] state, state_next;
  reg [15:0] keycode_next;
  wire paused_to_the_end;
  wire scanned_to_3rd_row;

// state encoding
parameter s_init = 2'b00,
          s_scan = 2'b01,
          s_update = 2'b10,
          s_pause = 2'b11;
  
// define the key code
parameter key_0 = 4'd0;
parameter key_1 = 4'd1;
parameter key_2 = 4'd2;
parameter key_3 = 4'd3;
parameter key_4 = 4'd4;
parameter key_5 = 4'd5;
parameter key_6 = 4'd6;
parameter key_7 = 4'd7;
parameter key_8 = 4'd8;
parameter key_9 = 4'd9;
parameter key_A = 4'd10;
parameter key_B = 4'd11;
parameter key_C = 4'd12;
parameter key_D = 4'd13;
parameter key_E = 4'd14;
parameter key_F = 4'd15;

//pause delay
parameter p_delay = 5'b01000;

// update the sequential signals
always @(posedge clk or negedge resetn) begin
  if (resetn == 1'b0) begin
    sel <= 2'b00;
    pause <= 0;
    state <= s_init;
	keycode <= 0;
  end else begin
    sel <= sel_next;
    pause <= pause_next;
    state <= state_next;
	keycode <= keycode_next;
  end
end

assign paused_to_the_end = (pause == p_delay) ? 1 : 0;
assign scanned_to_3rd_row = (sel == 2'b11) ? 1 : 0;

// define the state transitions and outputs of the finite state machine
always @(*) begin
  // default values
  state_next = s_init;
  sel_next = 2'b00;
  pause_next = 0;
  case(state)
    s_init: begin
      state_next = s_scan;
    end
    s_scan: begin
      if (scanned_to_3rd_row) state_next = s_update;
      else state_next = s_scan;
      sel_next = sel + 1'b1;
    end
    s_update: begin
      if (curr_pressed) state_next = s_pause;
      else state_next = s_scan;
      if (curr_pressed) begin
		;
      end
	  else begin
		;
	  end
    end
    s_pause: begin
      if (paused_to_the_end) state_next = s_scan;
      else state_next = s_pause;
      pause_next = pause + 1'b1;
	end
  endcase
end

// to scan rows alternately
always @(*) begin
  case (sel)
    2'd0: row = 4'b0111;
    2'd1: row = 4'b1011;
    2'd2: row = 4'b1101;
    2'd3: row = 4'b1110;
    default: row = 4'b1111;
  endcase
end

// columns readout
always @(*) begin
  case (row)
    // detect the 0th row
    4'b0111: begin
      pressed =1;
	  keycode_next[15:12] <= col;
	  end

    // detect the 1st row
	4'b1011: begin
      pressed =1;
	  keycode_next[11:8] <= col;
    end

    // detect the 2nd row
	4'b1101: begin
      pressed =1;
	  keycode_next[7:4] <= col;
    end

    // detect the 3rd row
    4'b1110: begin
      pressed =1;
	  keycode_next[3:0] <= col;
    end

    default: begin
         keycode_next <= 0;
         pressed = 1'b0;
     end
  endcase
end

// Need the storage below because s_scan takes a few clock cycles, 
// we must remember the detected key value for a few clock cycles til state s_update
reg [3:0] curr_key;
reg curr_pressed;

always @(posedge clk or negedge resetn) begin
  if (resetn == 1'b0 || state == s_pause) begin
    curr_pressed <= 1'b0;
    curr_key <= 4'b0;
  end else if (pressed) begin
    curr_pressed <= 1'b1;
    curr_key <= key;
  end 
end

endmodule
