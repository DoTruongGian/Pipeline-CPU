module Controller (
    input      logic [6:0] OP,
    input      logic [6:0] funct77,
    input      logic [2:0] funct3,
    input            logic funct7,
    output logic       MemWriteD,
    output logic       ALUSrcD,
    output logic       RegWriteD,
    output logic       BranchD,
    output logic       JumpD, //PCSrc
    output logic [1:0] ResultSrcD,
    output logic [4:0] ALUControlD,
    output logic [2:0] ImmSrcD
);
    
	 
	 

	 
	 
    logic [16:0] checkerr;
    assign      checkerr = {{OP},{funct3},{funct77}};
    logic [1:0]   ALUOp;
    always_comb begin
        case (OP)
            7'b0000011: begin        //lw
                BranchD    = 0;
                ResultSrcD = 2'b01;
                MemWriteD  = 0;
                ALUSrcD    = 1;
                RegWriteD  = 1;
                ALUOp      = 2'b00;
                ImmSrcD    = 3'b000;
                JumpD      = 0;
            end 

            7'b0100011: begin  //sw
                BranchD    = 0;
                ResultSrcD = 2'bxx;
                MemWriteD  = 1;
                ALUSrcD    = 1;
                RegWriteD  = 0;
                ALUOp      = 2'b00;
                ImmSrcD    = 3'b001;
                JumpD      = 0;
            end

            7'b0110011: begin  //R-type
                BranchD    = 0;
                ResultSrcD = 2'b00;
                MemWriteD  = 0;
                ALUSrcD    = 0;
                RegWriteD  = 1;
                ALUOp      = 2'b10;
                ImmSrcD    = 3'bxxx;
                JumpD      = 0;
            end

            7'b1100011: begin  //branch
                BranchD    = 1;
                ResultSrcD = 2'bxx;
                MemWriteD  = 0;
                ALUSrcD    = 0;
                RegWriteD  = 0;
                ALUOp      = 2'b01;
                ImmSrcD    = 3'b010;
                JumpD      = 0;
            end

            7'b0010011: begin  //I-Type
                BranchD    = 0;
                ResultSrcD = 2'b00;
                MemWriteD  = 0;
                ALUSrcD    = 1;
                RegWriteD  = 1;
                ALUOp      = 2'b10;
                ImmSrcD    = 3'b000;
                JumpD      = 0;
            end
            7'b1101111: begin //j
                BranchD    = 0;
                ResultSrcD = 2'b10;
                MemWriteD  = 0;
                ALUSrcD    = 1'bx;
                RegWriteD  = 1;
                ALUOp      = 2'bxx;
                ImmSrcD    = 3'b011;
                JumpD      = 1;
            end
            7'b0110111:begin //U-type
				    MemWriteD  = 0;
					 BranchD    = 0;
					 ALUSrcD    = 1'b1;
                RegWriteD  = 1;
					 ImmSrcD    = 3'b100;
					 ALUSrcD    = 1;
					 ALUOp      = 2'b00;
					 
            end    
                
            default: begin
                BranchD    = 0;
                ResultSrcD = 2'b00;
                MemWriteD  = 0;
                ALUSrcD    = 1'bx;
                RegWriteD  = 0;
                ALUOp      = 2'b00;
                ImmSrcD    = 3'b000;
                JumpD      = 0;
            end 
            
        endcase
        
    end

    always_comb begin

        case (checkerr)
            17'b01100110000000000: ALUControlD = 5'b00000;
            17'b01100110000100000: ALUControlD = 5'b00001;
            17'b01100110000000001: ALUControlD = 5'b00010;
            17'b01100111000000001: ALUControlD = 5'b00011;
            17'b01100111100000001: ALUControlD = 5'b00000; //rem defined wrong
            17'b01100111110000000: ALUControlD = 5'b01000;
            17'b01100111100000000: ALUControlD = 5'b01001;
            17'b01100111000000000: ALUControlD = 5'b01010;
            17'b01100110010000000: ALUControlD = 5'b00100; //sll,logical shift left
            17'b01100111010000000: ALUControlD = 5'b00101; //srl,logical shift right
				17'b01100110100000000: ALUControlD = 5'b10001;
            17'b0010011000xxxxxxx: ALUControlD = 5'b00000;
            17'b11000110001111111: ALUControlD = 5'b00001; //beq
            17'b1100011001xxxxxxx: ALUControlD = 5'b00001;
            17'b0000011010xxxxxxx: ALUControlD = 5'b00000; //lw
            17'b0100011010xxxxxxx: ALUControlD = 5'b00000; //sw
            17'b0110111xxxxxxxxxx: ALUControlD = 5'b10000; //U-type
            default:               ALUControlD = 5'b00000;
        endcase
        
    end
endmodule