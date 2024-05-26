module third_register (
    input logic [31:0] WriteDataE,
    input logic [31:0] ALUResult,
    input logic [31:0] PCPlus4E,
    input logic [4:0]  RdE,
    input logic        clk,
    input logic        rst,
    input logic        RegWriteE,
    input logic        MemWriteE,
    input logic [1:0]  ResultSrcE,
	 input logic [2:0] funct3E,
	 output logic [2:0] funct3M,
    output logic [31:0] ALUResultM,
    output logic [31:0] WriteDataM,
    output logic [31:0] PCPlus4M,
    output logic [4:0]  RdM,
    output logic        RegWriteM,
    output logic        MemWriteM,
    output logic [1:0]  ResultSrcM
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            RegWriteM  <= 1'b0;
            MemWriteM  <= 1'b0;
            ResultSrcM <= 2'b00;
            ALUResultM <= 32'd0;
            WriteDataM <= 32'd0;
            RdM        <= 5'd0;
            PCPlus4M   <= 32'd0;
				funct3M    <= funct3E;
        end
        else begin
            RegWriteM  <= RegWriteE;
            MemWriteM  <= MemWriteE;
            ResultSrcM <= ResultSrcE;
            ALUResultM <= ALUResult;
            WriteDataM <= WriteDataE;
            RdM        <= RdE;
            PCPlus4M   <= PCPlus4E;
				funct3M    <= funct3E;
        end
    end
endmodule