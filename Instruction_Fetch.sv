module Instruction_Fetch (
    input logic [31:0] instrD,
    output logic [4:0]  A1,
    output logic [4:0]  A2,
    output logic [4:0]  RdD,
    output logic [4:0]  Rs1D,
    output logic [4:0]  Rs2D,
    output logic [6:0]  OP,
    output logic [2:0]  funct3,
    output logic        funct7,
    output logic [24:0] Imm,
    output logic [6:0]  funct77
);
    always_comb begin
        A1      = instrD[19:15];
        A2      = instrD[24:20];
        RdD     = instrD[11:7];
        OP      = instrD[6:0];
        funct3  = instrD[14:12];
        funct7  = instrD[30];
        Imm     = instrD[31:7];
        funct77 = instrD[31:25];
        Rs1D    = instrD[19:15];
        Rs2D    = instrD[24:20];
    end
endmodule