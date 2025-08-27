module mux_2(
    input [31:0] IN_1 , IN_2 ,
    input sel,
    output [31:0] out

);

    assign out = sel ? IN_2 : IN_1;

endmodule