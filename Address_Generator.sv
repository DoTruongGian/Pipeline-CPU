module Address_Generator (
    input logic        rst,
    input logic        clk,
    input logic        PCSrcE,
    input logic        StallF,
    input logic [31:0] PCPlus4F,
    input logic [31:0] PCTargetE,
    output logic [31:0] PCF
);

    logic [31:0] PCFbar;

    // Combinational block: always_comb is appropriate for combinational logic
    always_comb begin
        PCFbar = (PCSrcE == 1'b1)  ? PCTargetE : PCF +4;
    end

    // Sequential block: always_ff is appropriate for sequential logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            PCF <= 32'h0;
        end
        else if (StallF) begin
            // No change in PCF
        end
        else begin
            PCF <= PCFbar;
        end
    end 

endmodule
