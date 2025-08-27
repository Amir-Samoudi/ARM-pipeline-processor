module frequency_divider(
    input clk, rst,
    output reg clk_divided
    );

    always @(posedge clk, posedge rst) begin
        if (rst == 1)
            clk_divided <= 0;
        else 
            clk_divided <= ~clk_divided;
    end

endmodule
