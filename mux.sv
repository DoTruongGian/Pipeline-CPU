module mux #
(
     parameter WIDTH = 8
)(
     input logic [WIDTH-1:0]  RD2,
     input logic [WIDTH-1:0]  ImmExt,
     input logic              ALUSrc,
     output logic [WIDTH-1:0] SrcB
);
     assign SrcB = ALUSrc ?  ImmExt : RD2;
endmodule
