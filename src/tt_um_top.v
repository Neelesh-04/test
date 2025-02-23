`timescale 1ns / 1ps

module tt_um_top(
input clk,
input rst_n,
input mode, // for controlling type of write
input read_en,
input write_en,  // enabling read/write
output reg [6:0] sev_seg,
//output reg [3:0] anode //extra signal
    );

wire ar_ready, r_valid,ar_valid,
 r_ready ,aw_ready, 
 w_ready,aw_valid,w_valid,b_valid,b_ready;
 wire [2:0] aw_addr;
 wire [3:0]w_data;
  wire [2:0] ar_addr;
 wire [3:0] r_data;
 wire [3:0] LED_OUT;
 
master m(.clk(clk),.rst(rst),.mode(mode),
.ar_ready(ar_ready),.r_valid(r_valid),
.ar_valid(ar_valid),.r_ready(r_ready),.aw_valid(aw_valid),
.w_valid(w_valid),.aw_ready(aw_ready),.w_ready(w_ready),.b_valid(b_valid),
.b_ready(b_ready),.aw_addr(aw_addr),.w_data(w_data),.ar_addr(ar_addr),.r_data(r_data),.read_en(read_en),.write_en(write_en),
.LED_OUT(LED_OUT));

slave s(.clk(clk),.rst(rst),.ar_ready(ar_ready),.r_valid(r_valid),
.ar_valid(ar_valid),.r_ready(r_ready),.aw_valid(aw_valid),
.w_valid(w_valid),.aw_ready(aw_ready),.w_ready(w_ready),.b_valid(b_valid),.b_ready(b_ready),
.aw_addr(aw_addr),.w_data(w_data),.ar_addr(ar_addr),.r_data(r_data));

always @(posedge clk)
begin
//anode <= 4'b1110;
 case(LED_OUT)
        4'd0: sev_seg = 7'b0000001; // "0"  
        4'd1: sev_seg = 7'b1001111; // "1" 
        4'd2: sev_seg = 7'b0010010; // "2" 
        4'd3: sev_seg = 7'b0000110; // "3" 
        4'd4: sev_seg = 7'b1001100; // "4" 
        4'd5: sev_seg = 7'b0100100; // "5" 
        4'd6: sev_seg = 7'b0100000; // "6" 
        4'd7: sev_seg = 7'b0001111; // "7" 
        4'd8: sev_seg = 7'b0000000; // "8"  
        4'd9: sev_seg = 7'b0000100; // "9" 
        4'd10: sev_seg = 7'b0001000; // "A"
        4'd11: sev_seg = 7'b1100000; // "B"
        4'd12: sev_seg = 7'b0110001; // "C"
        4'd13: sev_seg = 7'b1000010; // "D"
        4'd14: sev_seg = 7'b0110000; // "E"
        4'd15: sev_seg = 7'b0111000; // "F"
        default: sev_seg = 7'b1111111; // Blank display

 endcase
end
endmodule
