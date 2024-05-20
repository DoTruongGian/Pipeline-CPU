module Second_register (
    input logic [31:0]      PCD, 
    input logic [31:0]      ImmExtD,
    input logic [31:0]      PCPlus4D,
    input logic [31:0]      RD1,
    input logic [31:0]      RD2,
    input logic [4:0]       RdD,
    input logic [4:0]       Rs1D,
    input logic [4:0]       Rs2D,
    input logic [2:0]       funct3,
    input logic             rst,
    input logic             clk,
    input logic             RegWriteD,
    input logic             MemWriteD,
    input logic             JumpD,
    input logic             BranchD,
    input logic             ALUSrcD,
    input logic             ZeroE,
    input logic             FlushE,
    input logic [1:0]       ResultSrcD,
    input logic [4:0]       ALUControlD,
    output  logic        RegWriteE,
    output  logic        MemWriteE,
    output  logic        JumpE,
    output  logic        BranchE,
    output  logic        ALUSrcE,
    output  logic        PCSrcE,
    output  logic [1:0]  ResultSrcE,
    output  logic [4:0]  ALUControlE,
    output  logic [31:0] PCE,
    output  logic [31:0] ImmExtE,
    output  logic [31:0] PCPlus4E,
    output  logic [31:0] RD1E,
    output  logic [31:0] RD2E,
    output  logic [2:0]  funct3E,
    output  logic [4:0]  RdE,
    output  logic [4:0]  Rs1E,
    output  logic [4:0]  Rs2E
);
    always_ff @(posedge clk) begin
        if (rst) begin
            RegWriteE   <= 1'b0;
            MemWriteE   <= 1'b0;
            JumpE       <= 1'b0;
            BranchE     <= 1'b0;
            ALUSrcE     <= 1'b0;
            ResultSrcE  <= 2'b00;
            ALUControlE <= 5'b00000;
            PCE         <= 32'd0;
            ImmExtE     <= 32'd0;
            PCPlus4E    <= 32'd0;
            RD1E        <= 32'd0;
            RD2E        <= 32'd0;
            funct3E     <= 3'd0;
            RdE         <= 5'd0;
            Rs1E        <= 5'd0;
            Rs2E        <= 5'd0;
        end
        else if (FlushE) begin
            RegWriteE   <= 1'b0;
            MemWriteE   <= 1'b0;
            JumpE       <= 1'b0;
            BranchE     <= 1'b0;
            ALUSrcE     <= 1'b0;
            ResultSrcE  <= 2'b00;
            ALUControlE <= 5'b00000;
            PCE         <= 32'd0;
            ImmExtE     <= 32'd0;
            PCPlus4E    <= 32'd0;
            RD1E        <= 32'd0;
            RD2E        <= 32'd0;
            funct3E     <= 3'd0;
            RdE         <= 5'd0;
            Rs1E        <= 5'd0;
            Rs2E        <= 5'd0;
        end
        else begin
            RegWriteE   <= RegWriteD;
            MemWriteE   <= MemWriteD;
            JumpE       <= JumpD;
            BranchE     <= BranchD;
            ALUSrcE     <= ALUSrcD;
            ResultSrcE  <= ResultSrcD;
            ALUControlE <= ALUControlD;
            PCE         <= PCD;
            ImmExtE     <= ImmExtD;
            PCPlus4E    <= PCPlus4D;
            RD1E        <= RD1;
            RD2E        <= RD2;
            funct3E     <= funct3;
            RdE         <= RdD;
            Rs1E        <= Rs1D;
            Rs2E        <= Rs2D;
        end
    end
    
    assign PCSrcE = (ZeroE && BranchE) || JumpE;
endmodule
