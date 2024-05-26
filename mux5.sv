module mux5 #
(    
    parameter WIDTH = 8
)(
    input logic [WIDTH-1:0] RD1E, 
    input logic [WIDTH-1:0] ResultW, 
    input logic [WIDTH-1:0] ALUResultM,
    input logic [1:0] ForwardAE,
    output logic [WIDTH-1:0] SrcAE
);
    assign SrcAE = ForwardAE[1] ? ALUResultM : (ForwardAE[0] ? ResultW : RD1E);
endmodule

