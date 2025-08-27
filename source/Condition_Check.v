module Condition_Check(
    input [3:0] Condition, Status,
    output reg condition_flag
);

    always @(Condition, Status) begin
        condition_flag = 1'b0;
        case (Condition)
           4'b0000 : condition_flag = (Status[2] == 1'b1) ? 1'b1 : 1'b0;
           4'b0001 : condition_flag = (Status[2] == 1'b0) ? 1'b1 : 1'b0;
           4'b0010 : condition_flag = (Status[1] == 1'b1) ? 1'b1 : 1'b0;
           4'b0011 : condition_flag = (Status[1] == 1'b0) ? 1'b1 : 1'b0;
           4'b0100 : condition_flag = (Status[3] == 1'b1) ? 1'b1 : 1'b0;
           4'b0101 : condition_flag = (Status[3] == 1'b0) ? 1'b1 : 1'b0;
           4'b0110 : condition_flag = (Status[0] == 1'b1) ? 1'b1 : 1'b0;
           4'b0111 : condition_flag = (Status[0] == 1'b0) ? 1'b1 : 1'b0;
           4'b1000 : condition_flag = (Status[1] == 1'b1)&(Status[2] == 1'b0) ? 1'b1 : 1'b0;
           4'b1001 : condition_flag = (Status[1] == 1'b0)&(Status[2] == 1'b1) ? 1'b1 : 1'b0;
           4'b1010 : condition_flag = (Status[0] == Status[3]) ? 1'b1 : 1'b0;
           4'b1011 : condition_flag = (Status[0] != Status[3]) ? 1'b1 : 1'b0;
           4'b1100 : condition_flag = (Status[2] == 1'b0)&(Status[0] == Status[3]) ? 1'b1 : 1'b0;
           4'b1101 : condition_flag = (Status[2] == 1'b1)&(Status[0] != Status[3]) ? 1'b1 : 1'b0;
           4'b1110 : condition_flag = 1'b1;
            default: ; 
        endcase
    end

endmodule
