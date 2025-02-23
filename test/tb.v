// `default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave or surfer.
  // initial begin
  //   $dumpfile("tb.vcd");
  //   $dumpvars(0, tb);
  //   #1;
  // end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg mode;
reg read_en;
   reg write_en;
   wire [7:0] uo_out;

  // Replace tt_um_example with your module name:
  tt_um_top user_project (

      // Include power ports for the Gate Level test:
      
     .ui_in  ({mode,read_en,write_en,5'b00000}),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
     .uio_in (8'b0),   // IOs: Input path
      .uio_out(),  // IOs: Output path
      .uio_oe (),   // IOs: Enable path (active high: 0=input, 1=output)
     .ena    (1'b1),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );
initial clk = 0;
always #50 clk = ~clk; 

initial begin
rst_n = 1;
#120
rst_n =0;
mode = 1;
write_en = 1;
read_en = 0;
#3000
write_en = 0;
read_en = 1;
#3000
mode = 0;
write_en = 1;
read_en = 0;
#3000
write_en = 0;
read_en = 1;
#3000
write_en = 0;
read_en = 0;

#50000 $finish;
end

   initial begin
        
        $dumpfile("fifo.vcd");
        $dumpvars;
    end
endmodule

