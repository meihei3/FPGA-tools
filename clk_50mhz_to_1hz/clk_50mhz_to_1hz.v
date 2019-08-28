module gen_sclk(clk0, clk1);
    input clk0;
    output clk1;

    reg clk1 = 1;
    reg[32:0] counter = 0;

    always @ (posedge clk0) begin
        if (counter == 25_000_000) begin
            counter <= 0;
            clk1 <= ~clk1;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule