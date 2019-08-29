module d2col(d_in, col);
    input [11:0] d_in;
    output [23:0] col;

    function [7:0] d2c;
        input [3:0] d;
        if (d <= 4'd0)
            d2c = 8'h00;
        else if (d <= 4'd1)
            d2c = 8'h40;
        else if (d <= 4'd3)
            d2c = 8'h80;
        else if (d <= 4'd7)
            d2c = 8'hc0;
        else
            d2c = 8'hff;
    endfunction

    assign col = {d2c(d_in[11:08]), d2c(d_in[07:04]), d2c(d_in[03:00])};

endmodule
