module alu(
    input logic [31:0] SrcAE, SrcBE,      // ALU 32-bit Inputs
    input logic [4:0] ALUControlE,         // ALU Selection
    input logic [2:0] funct3E,
    output logic [31:0] ALUResult,         // ALU 32-bit Output
    output logic CarryOut,                 // Carry Out Flag
    output logic ZeroE                     // Zero Flag
);

    logic [31:0] ALU_Result;
    logic [32:0] tmp;

    always_comb begin
        tmp = {1'b0, SrcAE} + {1'b0, SrcBE};
        CarryOut = tmp[32];
    end

    always_comb begin
        case (funct3E)
            3'b000: ZeroE = (SrcAE == SrcBE); // beq
            3'b001: ZeroE = (SrcAE != SrcBE); // bne
            3'b100: ZeroE = (SrcAE < SrcBE); // blt
            3'b101: ZeroE = (SrcAE > SrcBE); // bge
            3'b110: ZeroE = (SrcAE < SrcBE); // bltu
            3'b111: ZeroE = (SrcAE >= SrcBE); // bgeu
            default: ZeroE = 1'b0;
        endcase
    end

    always_comb begin
        case (ALUControlE)
            5'b00000: ALU_Result = SrcAE + SrcBE;
            5'b00001: ALU_Result = SrcAE - SrcBE;
            5'b00010: ALU_Result = SrcAE * SrcBE;
            5'b00011: ALU_Result = SrcAE / SrcBE;
            5'b00100: ALU_Result = SrcAE << SrcBE;
            5'b00101: ALU_Result = SrcAE >> SrcBE;
            5'b00110: ALU_Result = {SrcAE[30:0], SrcAE[31]};
            5'b00111: ALU_Result = {SrcAE[0], SrcAE[31:1]};
            5'b01000: ALU_Result = SrcAE & SrcBE;
            5'b01001: ALU_Result = SrcAE | SrcBE;
            5'b01010: ALU_Result = SrcAE ^ SrcBE;
            5'b01011: ALU_Result = ~(SrcAE | SrcBE);
            5'b01100: ALU_Result = ~(SrcAE & SrcBE);
            5'b01101: ALU_Result = ~(SrcAE ^ SrcBE);
            5'b01110: ALU_Result = (SrcAE > SrcBE) ? 32'd1 : 32'd0;
            5'b01111: ALU_Result = (SrcAE == SrcBE) ? 32'd1 : 32'd0;
            5'b10000: ALU_Result = SrcBE;
            default: ALU_Result = SrcAE + SrcBE;
        endcase
    end

    always_comb begin
        ALUResult = ALU_Result;
    end

endmodule
