module Data_Memory (
    input logic [31:0] WriteDataM,
    input logic [31:0] ALUResultM,
    input logic        clk,
    input logic        MemWriteM,
    input logic        rst,
	 input logic [2:0] funct3M,
	 output logic [2:0] funct3M_sel,
    output logic [31:0] ReadData,
    output logic [31:0] DM0
);




    logic [31:0] Data_Mem [255:0];   // 2D array for data memory
    integer i;

    always_comb begin                     // Asynchronous read from Data Memory
        ReadData = Data_Mem[ALUResultM];
		  DM0 = ReadData;
		  funct3M_sel = funct3M;
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 256; i++) begin
                Data_Mem[i] <= 32'd0;
					 
            end
        end else if (MemWriteM) begin
            Data_Mem[ALUResultM] <= WriteDataM; 
				
        end
    end    
    
endmodule