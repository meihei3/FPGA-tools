// VGA signal generator, 640 x 480, by Li Yamin, yamin@ieee.org

module vgac8 (vga_clk,clrn,d_in,row_addr,col_addr,rdn,r,g,b,hs,vs,blankn,syncn);   // vgac
    input     [23:0] d_in;     // rrrrrrrr_gggggggg_bbbbbbbb, pixel
    input            vga_clk;  // 25MHz
    input            clrn;
    output reg [8:0] row_addr; // pixel ram row address, 480 (512) lines
    output reg [9:0] col_addr; // pixel ram col address, 640 (1024) pixels
    output reg [7:0] r,g,b;    // red, green, blue colors, 10-bit for each
    output reg       rdn;      // read pixel RAM (active low)
    output reg       hs,vs;    // horizontal and vertical synchronization
    output           blankn = 1; // for ADV7123 DAC
    output           syncn = 0;  // for ADV7123 DAC
    // h_count: vga horizontal counter (0-799 pixels)
    reg [9:0] h_count;
    always @ (posedge vga_clk or negedge clrn) begin
        if (!clrn) begin
            h_count <= 10'h0;
        end else if (h_count == 10'd799) begin
            h_count <= 10'h0;
        end else begin 
            h_count <= h_count + 10'h1;
        end
    end
    // v_count: vga vertical counter (0-524 lines)
    reg [9:0] v_count;
    always @ (posedge vga_clk or negedge clrn) begin
        if (!clrn) begin
            v_count <= 10'h0;
        end else if (h_count == 10'd799) begin
            if (v_count == 10'd524) begin
                v_count <= 10'h0;
            end else begin
                v_count <= v_count + 10'h1;
            end
        end
    end
    // signals, will be latched for outputs
    wire [9:0] row    =  v_count - 10'd35;     // ( 2+33= 35) pixel ram row address 
    wire [9:0] col    =  h_count - 10'd143;    // (96+48=144) pixel ram col address 
    wire       h_sync = (h_count > 10'd95);    //  96 -> 799
    wire       v_sync = (v_count > 10'd1);     //   2 -> 524
    wire       read   = (h_count > 10'd142) && // 143 -> 782 =
                        (h_count < 10'd783) && //              640 pixels
                        (v_count > 10'd34)  && //  35 -> 514 =
                        (v_count < 10'd515);   //              480 lines
    // vga signals
    always @ (posedge vga_clk) begin           // posedge orginal
        row_addr <=  row[8:0];                 // pixel ram row address
        col_addr <=  col;                      // pixel ram col address
        rdn      <= ~read;                     // read pixel (active low)
        hs       <=  h_sync;                   // horizontal synch
        vs       <=  v_sync;                   // vertical   synch
        r        <=  rdn ? 8'h0 : d_in[23:16]; // 8-bit red
        g        <=  rdn ? 8'h0 : d_in[15:08]; // 8-bit green
        b        <=  rdn ? 8'h0 : d_in[07:00]; // 8-bit blue
    end
endmodule
