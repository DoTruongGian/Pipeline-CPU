module PCPlus4 (
    input logic [31:0] PCF,
    output logic [31:0] PCPlus4F
);
    always_comb begin
        PCPlus4F = PCF + 4;
    end
endmodule
