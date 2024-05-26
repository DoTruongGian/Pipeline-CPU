module mux4 #
(
    parameter WIDTH = 8
)(
    input logic [WIDTH-1:0] RD2E,
    input logic [WIDTH-1:0] ResultW,
    input logic [WIDTH-1:0] ALUResultM,
    input logic [1:0] ForwardBE,
    output logic [WIDTH-1:0] WriteDataE
);
    assign WriteDataE = ForwardBE[1] ? ALUResultM : (ForwardBE[0] ? ResultW : RD2E);
endmodule