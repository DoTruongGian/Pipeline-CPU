module mux5to1 (
    input logic [31:0] lb,
    input logic [31:0] lh,
    input logic [31:0] lw,
    input logic [31:0] lbu,
    input logic [31:0] lhu,
    input logic [2:0] select,
    output logic [31:0] RD
);

    always_comb begin
        case (select)
            3'b000: RD = lb;
            3'b001: RD = lh;
            3'b010: RD = lw;
            3'b100: RD = lbu;
            3'b101: RD = lhu;
            default: RD = 32'hxxxx_xxxx; // Handle invalid select value
        endcase
    end

endmodule
