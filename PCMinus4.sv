module PCMinus4 (
    input logic [31:0] PCF,
    output logic [31:0] PCMinus4F
);
    always_comb begin
        PCMinus4F = PCF - 4;
    end
endmodule
