module mux_3(
    input [31:0] IN_1 , IN_2 , IN_3,
    input [1:0] sel,
    output [31:0] out

);

    assign out = (sel == 2'b00) ? IN_1 :
                 (sel == 2'b01) ? IN_2 :
                 (sel == 2'b10) ? IN_3 :
                 32'bz;

endmodule
