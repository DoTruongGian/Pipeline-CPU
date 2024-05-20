module hazard_unit (
    input logic [4:0] Rs1E,
    input logic [4:0] Rs2E,
    input logic [4:0] RdM,
    input logic [4:0] RdW,
    input logic [4:0] Rs1D,
    input logic [4:0] Rs2D,
    input logic [4:0] RdE,
    input logic [1:0] ResultSrcE,
    input logic        RegWriteM,
    input logic        RegWriteW,
    input logic        PCSrcE,
    output logic       StallF,
    output logic       StallD,
    output logic       FlushE,
    output logic       FlushD,
    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE
);
    logic lwStall;

    always_comb begin
        if (((Rs1E == RdM) && RegWriteM) && (Rs1E != 0)) begin
            ForwardAE = 2'b10;
        end
        else if (((Rs1E == RdW) && RegWriteW) && (Rs1E != 0)) begin
            ForwardAE = 2'b01;
        end
        else begin
            ForwardAE = 2'b00;
        end
    end

    always_comb begin
        if (((Rs2E == RdM) && RegWriteM) && (Rs2E != 0)) begin
            ForwardBE = 2'b10;
        end
        else if (((Rs2E == RdW) && RegWriteW) && (Rs2E != 0)) begin
            ForwardBE = 2'b01;
        end
        else begin
            ForwardBE = 2'b00;
        end
    end

    always_comb begin
        lwStall = (ResultSrcE[0] & ((Rs1D == RdE) | (Rs2D == RdE)));
        StallD = lwStall;
        FlushE = lwStall | PCSrcE;
        StallF = lwStall;
        FlushD = PCSrcE;
    end
endmodule
