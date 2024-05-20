module Decompress(
    input logic[31:0] inputA,
    output logic[31:0] outputData1,
    output logic[31:0] outputData0,
    output logic select
);

    logic [31:0] extend;
    logic [1:0] op;

    assign op = inputA[1:0];
    assign extend = {16'b0, inputA[15:0]};
    assign outputData0 = inputA;
    assign select = (inputA == extend);

    always_comb begin
        case (op)
            2'b00: begin
                outputData1 = {7'b0, inputA[6:2], inputA[11:7], 3'b0, inputA[11:7], 7'b0110011};
            end
            // Add cases for other values of op if needed
            default: begin
                outputData1 = '0; // Default output if op doesn't match any case
            end
        endcase
    end
endmodule



	reg [15:0] register_instruction;
	reg [1:0] compress_h, compress_l;
	reg flag_2com, flag_com, flag_coml;
	
	always_comb begin 
		if (compress_h != 2'b11 && compress_l != 2'b11) begin
			if(flag_2com == 1'b1) begin
			flag_2com = 1'b1;
			register_instruction = inputA[15:0];
			compress_o = {16'b0,inputA[31:16]};
			//PC-4 
			end
			else begin
			flag_2com = 1'b0;
			compress_o = {16'b0,register_instruction};
			end
		end
		
		else if (compress_h != 2'b11 && compress_l == 2'b11) begin
			register_instruction = inputA[15:0];
			compress_o = {16'b0,inputA[31:16]};
			flag_com = 1'b1;
		end
		
		else if (compress_h == 2'b11 && compress_l == 2'b11) begin 
			if (flag_com = 1'b1) begin
				register_instruction = inputA[15:0];
				compress_o = {register_intruction, inputA [31:16]};
				
			end	
			else begin
				compress_o = inputA;
			
			end
			
		end
		
		else if (compress_h == 2'b11 && compress_l != 2'b11) begin
			if (flag_coml == 1'b0) begin
				register_instruction = inputA[15:0];
				compress_o = {register_intruction, inputA [31:16]};
				flag_coml = 1'b1;	
				//PC-4
			end
			if (flag_coml == 1'b1) begin 
				flag_coml = 1'b0;
				flag_com  = 1'b0;
				compress_o = {16'b0, register_instruction};
			end
		end
	
	end