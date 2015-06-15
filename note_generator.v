// To generate audio left and audio right at desired note frequency
module note_generator(
  clk, // clock from crystal
  rst_n, // active low reset
  note_div, // divisor for note generation
  audio_left, // left sound audio
  audio_right // right sound audio
);

// I/O declaration
input clk; // clock from crystal
input rst_n; // active low reset
input [19:0] note_div; // divisor for note generation
output [15:0] audio_left; // left sound audio
output [15:0] audio_right; // right sound audio

// Declare internal signals
reg [19:0] clk_cnt_next, clk_cnt;
reg note_clk, note_clk_next;
reg check;
//wire [15:0] audio_right_next,audio_left_next;

// Note frequency generation
always @(posedge clk or negedge rst_n)
  if (~rst_n)
  begin
    clk_cnt <= 20'd0;
	 note_clk <= 1'b0;
  end
  else
  begin
    clk_cnt <= clk_cnt_next;
	 note_clk <= note_clk_next;
  end
	 
always @(*) begin
  if (clk_cnt == note_div)
  begin
    clk_cnt_next = 20'd0;
	 note_clk_next = ~note_clk;
  end
  else
  begin
    clk_cnt_next = clk_cnt + 1'b1;
	note_clk_next = note_clk;
  end
end
// We generate two identical square wave signals for the left and right channels
	
	parameter NUM_SAMPLE = 40;
	
	reg [0:(64 * 16) - 1] triangle_table = {
		1638,3277,4915,6553,8192,9830,11468,13107,
		14745,16384,18022,19660,21299,22937,24575,26214,
		27852,29490,31129,32767,31129,29490,27852,26214,
		24575,22937,21299,19660,18022,16384,14745,13107,
		11468,9830,8192,6553,4915,3277,1638,0
	};
	
	assign audio_left = (triangle_table[(clk_cnt / (note_div/ NUM_SAMPLE)) * 16 +: 16]);
	assign audio_right = (triangle_table[(clk_cnt / (note_div/ NUM_SAMPLE)) * 16 +: 16]);



// Note frequency generation
/*always @(posedge clk) begin
  if (~rst_n)
  begin
    clk_cnt <= 20'd0;
	 note_clk <= 1'b0;
	 audio_left <= 16'h8000;
	 audio_right <= 16'h8000;
  end
  else
  begin
    clk_cnt <= clk_cnt_next;
	 note_clk <= note_clk_next;
	 if(note_clk == 1'b0) begin
		//audio_left <= 16'h8000;
		//audio_right <= 16'h8000;
		if(audio_left[15] == 1'b0) audio_left <= audio_left_next - 1'b1;
		else if(audio_left > 16'h8000) audio_left <= audio_left_next - 1'b1;
		else audio_left <= audio_left_next;
		if(audio_right[15] == 1'b0) audio_right <= audio_right_next - 1'b1;
		else if(audio_right > 16'h8000) audio_right <= audio_right_next - 1'b1;
		else audio_right <= audio_right_next;
	 end
	 else begin
		//audio_left <= 16'h7FFF;
		//audio_left_next + 1'b1;
		//(audio_left < 16'h7FFF) ? audio_left_next + 1 : audio_left_next;
		//audio_right <= 16'h7FFF;
		//audio_right_next + 1'b1;
		//(audio_right < 16'h7FFF) ? audio_right_next + 1 : audio_right_next;
		if(audio_left[15] == 1'b1) audio_left <= audio_left_next + 1'b1;
		else if(audio_left < 16'h7FFF) audio_left <= audio_left_next + 1'b1;
		else audio_left <= audio_left_next;
		if(audio_right[15] == 1'b1) audio_right <= audio_right_next + 1'b1;
		else if(audio_right < 16'h7FFF) audio_right <= audio_right_next + 1'b1;
		else audio_right <= audio_right_next;
	 end
  end
end
	  
always @(*)
  if (clk_cnt == note_div)
  begin
    clk_cnt_next = 20'd0;
	 note_clk_next = ~note_clk;
  end
  else
  begin
    clk_cnt_next = clk_cnt + 1'b1;
	 note_clk_next = note_clk;
  end

// We generate two identical square wave signals for the left and right channels
assign audio_left_next = audio_left;
assign audio_right_next = audio_right;

*/

endmodule
