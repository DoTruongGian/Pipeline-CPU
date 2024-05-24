module Decompress(
    input logic [31:0] inputA, PCF_c,
    output logic [31:0] Decompress_o,
    output logic flag_PCC,
    output logic [31:0] temp_inss, PCF_co,
    output logic flag_2comm
);

    reg [31:0] compress_o;
    reg [15:0] register_instruction;
    logic [1:0] compress_h, compress_l;
    reg flag_un = 1'b0, flag_PC = 1'b0;
    logic [31:0] Decompress_o_temp;

    assign compress_h = inputA[17:16];
    assign compress_l = inputA[1:0];

    always_comb begin
        if (flag_PC == 1'b1) begin
            compress_o = {16'b0, register_instruction};
            flag_PC = 1'b0;
				PCF_co = PCF_c ;
        end else if (compress_l == 2'b11) begin
            if (!flag_un) begin
                compress_o = inputA;
					 PCF_co = PCF_c ;
            end else begin
                if (compress_h == 2'b11) begin
                    compress_o = {inputA[15:0], register_instruction};
                    register_instruction = inputA[31:16];
						  PCF_co = PCF_c ;
                end
                if (compress_h != 2'b11) begin
                    compress_o = {inputA[15:0], register_instruction};
                    register_instruction = inputA[31:16];
                    PCF_co = PCF_c - 4;
						  flag_PC = 1'b1;
                    flag_un = 1'b0;
                end
            end
        end else if (compress_l != 2'b11) begin
            if (compress_h != 2'b11 && flag_PC == 1'b0) begin
                compress_o = {16'b0, inputA[15:0]};
                register_instruction = inputA[31:16];
					 flag_PC = 1'b1;
                PCF_co = PCF_c - 4;
            end
            if (compress_h == 2'b11 && flag_un == 1'b0) begin
                compress_o = {16'b0, inputA[15:0]};
                register_instruction = inputA[31:16];
                flag_un = 1'b1;
					 PCF_co = PCF_c ;
            end else if (flag_un) begin
                compress_o = {inputA[15:0], register_instruction};
                register_instruction = inputA[31:16];
					 PCF_co = PCF_c ;
            end
        end
    end

    always @(*) begin
        case (compress_o[1:0])
            2'b00: begin
                Decompress_o_temp = {7'b0, compress_o[6:2], compress_o[11:7], 3'b0, compress_o[11:7], 7'b0110011};
            end
            // Add cases for other values of compress_o[1:0] if needed
            default: begin
                Decompress_o_temp = compress_o; // Default output if op doesn't match any case
            end
        endcase
    end

    assign Decompress_o = Decompress_o_temp;
    assign flag_2comm = flag_un;
    assign temp_inss = inputA;
    assign flag_PCC = flag_PC;

endmodule
