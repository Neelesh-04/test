
`timescale 1ns / 1ps

module slave(
    // External Inputs
    input clk,
    input rst_n,
    
    // Read Channel
    output reg ar_ready, r_valid,
    input ar_valid, r_ready,
    input [2:0] ar_addr,
    output reg [3:0] r_data,
    
    // Write Channel
    input [2:0] aw_addr,
    input [3:0] w_data,
    output reg aw_ready, w_ready, b_valid,
    input aw_valid, w_valid, b_ready
);

    localparam IDLE        = 3'b000;
    localparam READ_WAIT   = 3'b001;
    localparam READ_DATA   = 3'b010;
    localparam WRITE_WAIT  = 3'b011;
    localparam WRITE_DATA  = 3'b100;
    localparam WRITE_RESP  = 3'b101;

    reg [2:0] state;
    reg [3:0] mem_s [7:0];
//    reg [2:0] write_addr;
    reg [3:0] write_data;
    

    integer i_m;
    integer STREAM_LEN;
    
    // **State Transition Logic**
    always @(posedge clk or posedge rst_n) begin
       
        if (rst_n) begin
            state <= IDLE;

             for (i_m = 0; i_m < 8; i_m = i_m + 1)
             begin
                mem_s[i_m] = 4'b0000;
             end
        end 
        else begin
            if (state == IDLE) begin
                if (ar_valid) 
                    state <= READ_WAIT;
                else if (aw_valid) 
                    state <= WRITE_WAIT;
            end
            else if (state == READ_WAIT) begin
           
            if (ar_valid)    
                    STREAM_LEN = 0;
                  
                     state <= READ_DATA;
                    
            end
            else if (state == READ_DATA) begin
                
                if (r_ready)    
                 begin   
                if(STREAM_LEN <8)
                     begin  
                      r_data <= mem_s[STREAM_LEN]; 
                    // r_valid = 1'b1;
                      STREAM_LEN = STREAM_LEN +1;
                       end
                 if(STREAM_LEN>=8)begin
                   // r_valid = 1'b0;
                     
                      state <= IDLE; end
                       end
            end
            else if (state == WRITE_WAIT) begin
                
                if (aw_valid) begin
                    STREAM_LEN = 0;
                     
                    state <= WRITE_DATA;
                   
                end
            end
            else if (state == WRITE_DATA) begin
                
                if (w_valid) begin
//                    write_data <= w_data;
//                    for(i = 0; i<8;i=i+1)begin
//                        mem_s[i] <= write_data + (i*2);
//                    end
                    if(STREAM_LEN <8)begin
                        mem_s[STREAM_LEN] <= w_data;
                        STREAM_LEN = STREAM_LEN +1;
                   end
                   if(STREAM_LEN>=8)
                    
                    state <= WRITE_RESP;
                end
            end
            else if (state == WRITE_RESP) begin
              
                if (b_ready) 
                   
                    state <= IDLE;
            end
        end
    end

    // **Output Logic**
    always @(posedge clk or posedge rst_n) begin
        if(rst_n)begin
             ar_ready <= 0;
            r_valid  <= 0;
            aw_ready <= 0;
            w_ready  <= 0;
            b_valid  <= 0;
      end else begin
            ar_ready <= (state == READ_WAIT);
          r_valid  <= (state == READ_DATA );
            aw_ready <= (state == WRITE_WAIT);
            w_ready  <= (state == WRITE_DATA);
            b_valid  <= (state == WRITE_RESP);        
        end
        end

endmodule


