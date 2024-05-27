module Decompress(
    input logic [31:0] inputA,
	 input logic clk, rst,
    output logic [31:0] Decompress_o,
    output logic flag_PCC,
    output logic [31:0] temp_inss,
    output logic flag_2comm
);

    reg [31:0] compress_o;
    reg [15:0] register_instruction, cur_ins, past_ins;
    logic [1:0] compress_h, compress_l;
    reg flag_un = 1'b0, flag_PC = 1'b0 ;
	 reg [4:0]count = 5'b0;
    logic [31:0] Decompress_o_temp;
	
    assign compress_h = inputA[17:16];
    assign compress_l = inputA[1:0];
	 


    always_ff @(posedge clk or posedge rst) begin
		 
        if (flag_PC) begin
            compress_o <= {16'b0, register_instruction};
            flag_PC <= 1'b0;
        end else if (compress_l == 2'b11) begin
            if (!flag_un) begin
                compress_o <= inputA;
					 count = count + 5'b00001;
            end else begin
                if (compress_h == 2'b11) begin
                    compress_o <= {inputA[15:0], register_instruction};
                    register_instruction <= inputA[31:16];
                end
                if (compress_h != 2'b11) begin
                    compress_o <= {inputA[15:0], register_instruction};
                    register_instruction <= inputA[31:16];
						  flag_PC <= 1'b1;
                    flag_un <= 1'b0;
                end
            end
        end else if (compress_l != 2'b11) begin
            if (compress_h != 2'b11 && flag_PC == 1'b0 && flag_un == 1'b0) begin
                compress_o <= {16'b0, inputA[15:0]};
                register_instruction <= inputA[31:16];
					 flag_PC <= 1'b1;
            end
            else if (compress_h == 2'b11 && flag_un == 1'b0) begin
                compress_o <= {16'b0, inputA[15:0]};
                register_instruction <= inputA[31:16];
                flag_un <= 1'b1;
            end else if (flag_un == 1'b1 && compress_h == 2'b11) begin
                compress_o <= {inputA[15:0], register_instruction};
                register_instruction <= inputA[31:16];
            end else if (flag_un == 1'b1 && compress_h != 2'b11) begin
					     compress_o <= {inputA[15:0], register_instruction};
                    register_instruction <= inputA[31:16];
						  flag_PC <= 1'b1;
                    flag_un <= 1'b0;

				end
        end
    end

    always @(*) begin
	 
	 if (count == 5'b00010) begin
			Decompress_o_temp = 32'h00000013;
	 end else begin
        case (compress_o[1:0])
            2'b00: begin
                case (compress_o[15:13])
                    3'b000: begin
                        // C.ADDI
                        Decompress_o_temp = { {6{compress_o[12]}}, compress_o[12], compress_o[6:2], compress_o[11:7], 3'b000, compress_o[11:7], 7'b0010011 };
                    end
                    3'b010: begin
                        // C.LW
                        Decompress_o_temp = { 5'b00000, compress_o[5], compress_o[12:10], compress_o[6], compress_o[9:7], 3'b010, compress_o[11:7], 7'b0000011 };
                    end
                    3'b110: begin
                        // C.SW
                        Decompress_o_temp = { 5'b00000, compress_o[5], compress_o[12], compress_o[11:10], compress_o[6], 2'b00, compress_o[9:7], 3'b010, compress_o[4:2], 7'b0100011 };
                    end
                    default: begin
                        Decompress_o_temp = compress_o; // Default output if op doesn't match any case
                    end
                endcase
            end
            2'b01: begin
                case (compress_o[15:13])
                    3'b000: begin
                        // C.NOP / C.ADDI
                        if (compress_o[11:7] == 5'b00000) begin
                            Decompress_o_temp = 32'h00000013; // C.NOP (ADDI x0, x0, 0)
                        end else begin
                            Decompress_o_temp = { {6{compress_o[12]}}, compress_o[12], compress_o[6:2], compress_o[11:7], 3'b000, compress_o[11:7], 7'b0010011 }; // C.ADDI
                        end
                    end
                    3'b100: begin
                        // C.ADD
                        Decompress_o_temp = { 7'b0000000, compress_o[6:2], compress_o[11:7], 3'b000, compress_o[11:7], 7'b0110011 };
                    end
                    3'b101: begin
                        // C.J
                        Decompress_o_temp = { compress_o[12], compress_o[8], compress_o[10:9], compress_o[6], compress_o[7], compress_o[2], compress_o[11], compress_o[5:3], 8'b00000000, 7'b1101111 };
                    end
                    3'b110: begin
                        // C.BEQZ
                        Decompress_o_temp = { compress_o[12], compress_o[6:5], compress_o[2], 5'b00000, compress_o[11:10], compress_o[4:3], compress_o[7], compress_o[12:10], compress_o[9:7], 3'b000, 5'b00000, 7'b1100011 };
                    end
                    3'b111: begin
                        // C.BNEZ
                        Decompress_o_temp = { compress_o[12], compress_o[6:5], compress_o[2], 5'b00000, compress_o[11:10], compress_o[4:3], compress_o[7], compress_o[12:10], compress_o[9:7], 3'b001, 5'b00000, 7'b1100011 };
                    end
                    default: begin
                        Decompress_o_temp = compress_o; // Default output if op doesn't match any case
                    end
                endcase
            end
            default: begin
                Decompress_o_temp = compress_o; // Default output if op doesn't match any case
            end
        endcase
    end
	 end
    assign Decompress_o = Decompress_o_temp;
    assign flag_2comm = flag_un;
    assign temp_inss = inputA;
    assign flag_PCC = flag_PC;
endmodule
