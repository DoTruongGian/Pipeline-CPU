module LS_sel (
	input logic [2:0] funct3M,
	input logic [31:0] ReadData,
	output logic [2:0] select,
	output logic [31:0] lw,
	output logic [31:0] lb,
	output logic [31:0] lh,
	output logic [31:0] lbu,
	output logic [31:0] lhu
);
assign select = funct3M;
assign lw = ReadData;
assign lbu = {24'b0, ReadData[7:0]};
assign lhu = {16'b0, ReadData[15:0]};
assign lb = {{24{ReadData[7]}}, ReadData [7:0]};
assign lh = {{16{ReadData[15]}}, ReadData [15:0]};
endmodule