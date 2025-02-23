
module master(
    // External interfaces
    input clk,
    input rst_n,
    input mode,
    input read_en,
    input write_en,
    
    // Read signals
    input ar_ready, r_valid,
    output reg ar_valid, r_ready,
    output reg [2:0] ar_addr,
    input [3:0] r_data,
    
    // Write signals
    input aw_ready, w_ready, b_valid,
    output reg aw_valid, w_valid, b_ready,
    output reg [2:0] aw_addr,
    output reg [3:0] w_data,
    
    // External output
    output reg [3:0] LED_OUT
);


    localparam IDLE        = 3'b000;
    localparam READ_ADDR   = 3'b001;
    localparam READ_DATA   = 3'b010;
    localparam WRITE_ADDR  = 3'b011;
    localparam WRITE_DATA  = 3'b100;
    localparam WRITE_RESP  = 3'b101;
    
    reg [2:0] state;
    reg [3:0] mem_m [7:0];
    integer i_m;
    integer i;
    reg [3:0] read_data;
    reg [2:0] j;
    integer STREAM_LEN;
    // Synchronous state transition
    always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            state    <= IDLE;
       
            for (i_m = 0; i_m < 8; i_m = i_m + 1)
             begin
                mem_m[i_m] = 4'b0000;
             end
        end
         else begin
            if (state == IDLE) begin
                if (read_en) state <= READ_ADDR;
                else if (write_en) state <= WRITE_ADDR;
                else
                state <= IDLE;
            end 
            else if (state == READ_ADDR) begin
                
                 ar_addr <= 3'd0;
                 STREAM_LEN =0;
                if (ar_ready) begin state <= READ_DATA; end
            end 
            else if (state == READ_DATA) begin
                
                if (r_valid) begin
                  if(STREAM_LEN <8)
                  begin
                         mem_m[STREAM_LEN] <= r_data; 
                          STREAM_LEN = STREAM_LEN +1;
                  end
                  if(STREAM_LEN>=8)
                 
                  state <= IDLE;
                end
            end 
            else if (state == WRITE_ADDR) begin
              
                if (aw_ready) 
                begin
                aw_addr <= 3'd0;
                STREAM_LEN =0;
                
                state <= WRITE_DATA;
                
                end
            end 
            else if (state == WRITE_DATA) begin
              
                if (w_ready) begin
                if (mode)
                begin
                        if( STREAM_LEN <8)
                        begin
                        w_data <= 4'd1 + (STREAM_LEN*2);
                        STREAM_LEN =  STREAM_LEN+1;
                        end
                end
                else
                begin
                    if( STREAM_LEN <8)
                    begin
                        w_data <= 4'd0 + (STREAM_LEN*2);
                        STREAM_LEN =  STREAM_LEN+1;
                    end
                end
               // w_data <= mode ? 4'd1 : 4'd0;
               if(STREAM_LEN>=8)
              
                state <= WRITE_RESP;
                end
            end 
            else if (state == WRITE_RESP) begin
              
                if (b_valid) begin state <= IDLE; end 
            end
        end
    end
    
   //  Output logic based on state
    always @(posedge clk or posedge rst_n ) begin
        if(rst_n) begin
         ar_valid <= 0;
            r_ready  <= 0;
            aw_valid <= 0;
            w_valid  <= 0;
            b_ready  <= 0;
            end else begin
        ar_valid <= (state == READ_ADDR);
        r_ready  <= (state == READ_DATA);
        aw_valid <= (state == WRITE_ADDR);
        w_valid  <= (state == WRITE_DATA);
        b_ready  <= (state == WRITE_RESP);
        end
    end

// Clock Divider Logic
parameter MAX_COUNT = 10_000_000 -1;
wire counter_en;
  reg [23:0] counter_10M;

    always @(posedge clk, posedge rst_n)
    if(rst_n)
counter_10M <= 0;
else if (counter_10M == MAX_COUNT)
counter_10M <= 0;
else
counter_10M <=counter_10M +1'b1;

assign counter_en = (counter_10M == 0);


    always @(posedge clk, posedge rst_n)
begin
    if(rst_n) begin 
    LED_OUT <= 4'd0;
     j <= 3'b000;
 end
else if(state == READ_DATA)
    begin
       LED_OUT <= 4'd0;
    end
else
begin
     LED_OUT <= mem_m[j];
     j<= j+1;
end
end

endmodule
