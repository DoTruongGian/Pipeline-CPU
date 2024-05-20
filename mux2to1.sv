module mux2to1 (
    input logic [31:0] outputData0,
    input logic [31:0] outputData1,
    input logic select,
    output logic [31:0] InsD
);

    assign InsD = (select == 0) ? outputData0 : outputData1 ;

endmodule
