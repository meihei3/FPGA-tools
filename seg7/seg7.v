function [6:0] seg7;
    input [3:0] q;
    case (q)
        4'd0   : seg7 = 7'b1000000;
        4'd1   : seg7 = 7'b1111001;
        4'd2   : seg7 = 7'b0100100;
        4'd3   : seg7 = 7'b0110000;
        4'd4   : seg7 = 7'b0011001;
        4'd5   : seg7 = 7'b0010010;
        4'd6   : seg7 = 7'b0000010;
        4'd7   : seg7 = 7'b1111000;
        4'd8   : seg7 = 7'b0000000;
        4'd9   : seg7 = 7'b0010000;
        default: seg7 = 7'b1111111; // light off
    endcase
endfunction