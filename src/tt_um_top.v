`timescale 1ns / 1ps
//`default_nettype none

module tt_um_top(
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
    );

wire ar_ready, r_valid,ar_valid,
 r_ready ,aw_ready, 
 w_ready,aw_valid,w_valid,b_valid,b_ready;
 wire [2:0] aw_addr;
 wire [3:0]w_data;
  wire [2:0] ar_addr;
 wire [3:0] r_data;
 wire [3:0] LED_OUT;
 
    master m(.clk(clk),.rst(rst_n),.mode(ui_in[0]),
.ar_ready(ar_ready),.r_valid(r_valid),
.ar_valid(ar_valid),.r_ready(r_ready),.aw_valid(aw_valid),
.w_valid(w_valid),.aw_ready(aw_ready),.w_ready(w_ready),.b_valid(b_valid),
             .b_ready(b_ready),.aw_addr(aw_addr),.w_data(w_data),.ar_addr(ar_addr),.r_data(r_data),.read_en(ui_in[1]),.write_en(ui_in[2]),
.LED_OUT(LED_OUT));

    slave s(.clk(clk),.rst(rst_n),.ar_ready(ar_ready),.r_valid(r_valid),
.ar_valid(ar_valid),.r_ready(r_ready),.aw_valid(aw_valid),
.w_valid(w_valid),.aw_ready(aw_ready),.w_ready(w_ready),.b_valid(b_valid),.b_ready(b_ready),
.aw_addr(aw_addr),.w_data(w_data),.ar_addr(ar_addr),.r_data(r_data));

    wire _unused = &{ena, ui_in[7:3],uio_in[7:0]};
    assign uio_out = 0;
assign uio_oe  = 0;

always @(posedge clk)
begin
//anode <= 4'b1110;
 case(LED_OUT)
        4'd0: uo_out = 7'b0000001; // "0"  
        4'd1:  uo_out= 7'b1001111; // "1" 
        4'd2: uo_out = 7'b0010010; // "2" 
        4'd3: uo_out = 7'b0000110; // "3" 
        4'd4: uo_out = 7'b1001100; // "4" 
        4'd5: uo_out = 7'b0100100; // "5" 
        4'd6: uo_out = 7'b0100000; // "6" 
        4'd7: uo_out = 7'b0001111; // "7" 
        4'd8: uo_out = 7'b0000000; // "8"  
        4'd9: uo_out = 7'b0000100; // "9" 
        4'd10: uo_out = 7'b0001000; // "A"
        4'd11: uo_out = 7'b1100000; // "B"
        4'd12: uo_out = 7'b0110001; // "C"
        4'd13: uo_out = 7'b1000010; // "D"
        4'd14: uo_out = 7'b0110000; // "E"
        4'd15: uo_out = 7'b0111000; // "F"
        default: uo_out = 7'b1111111; // Blank display

 endcase
end
endmodule
