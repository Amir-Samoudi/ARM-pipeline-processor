module Adder(
    input [31:0] IN_1, IN_2,
    output [31:0] OUT
);

    assign OUT = IN_1 + IN_2;
    
endmodule