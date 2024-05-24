module main (
    input logic clk,
    input logic rst,

    //checkx1 ... upto checkx6 are used to check the contents of RF register
    //for example: x1, x2 upto x6.
    //If your simulator has support to see the contents of RF and DM then
    //you can remove all of the following outputs
    //Like QuetaSim can help you see the contents of RF and DM

    output logic [31:0] checkx1,
    output logic [31:0] checkx2,
    output logic [31:0] checkx3,
    output logic [31:0] checkx4,
    output logic [31:0] checkx5,
    output logic [31:0] checkx6,
    output logic [31:0] DM0,temp_inss,PCFF,
    output logic flag_2comm,flag_PCC,
	 output logic [2:0] test,
    output logic [31:0] instruction
);

	 logic [31:0]  PCF_co,compress_wire;
	 logic [31:0] lw,lb, lbu, lh, lhu, RD;
	 logic [2:0] funct3M, funct3M_sel, select_ls;
    logic [31:0] PCF;
    logic [31:0] PCPlus4F, instrD, PCD, PCPlus4D, SrcAE;
    logic [4:0]  A1, A2, RdD, RdW, RdE, RdM, Rs1E, Rs2E, Rs1D, Rs2D;
    logic [6:0]  OP;
    logic [2:0]  funct3, funct3E;
    logic        funct7;
    logic        WE3;
    logic        RegWriteW;
    logic        RegWriteD;
    logic        MemWriteD;
    logic        JumpD;
    logic        BranchD;
    logic        ALUSrcD;
    logic        ZeroE;
    logic        RegWriteE;
    logic        MemWriteE, JumpE, BranchE, ALUSrcE, PCSrcE;

    logic [24:0] Imm;
    logic [6:0]  funct77;
    logic [31:0] ResultW, RD1, RD2;
    logic [31:0] ImmExtD;
    logic [2:0]  ImmSrcD;
    logic [1:0]  ResultSrcD, ResultSrcE, ResultSrcM, ResultSrcW;
    logic [4:0]  ALUControlD, ALUControlE;
    logic [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    logic [31:0] PCTargetE;
    logic [31:0] SrcBE;
    logic [31:0] ALUResult, ALUResultM, ALUResultW;
    logic [31:0] WriteDataM, PCPlus4M, PCPlus4W;
    logic        CarryOut, RegWriteM, MemWriteM;
    logic [31:0] ReadData, ReadDataW, WriteDataE ;
    logic [1:0]  ForwardAE, ForwardBE;
    logic        StallF, StallD, FlushE, FlushD;
                //multiple signals at one line are just to reduce the space




    Address_Generator i_ag (
        .rst      (rst      ),
        .clk      (clk      ),
		  .flag_PC	(flag_PCC),
        .PCSrcE   (PCSrcE   ),
        .StallF   (StallF   ),
        .PCPlus4F (PCPlus4F ),
        .PCTargetE(PCTargetE),
        .PCF      (PCF      )
    );
	 
	 
    Instruction_Memory i_im (
        .PCF        (PCF       ),
        .instruction(compress_wire)
    );
	 Decompress De (
			.PCF_c(PCF),
			.PCF_co(PCF_co),
			.inputA(compress_wire),
			.flag_2comm(flag_2comm),
			.flag_PCC(flag_PCC),
			.temp_inss(temp_inss),
			.Decompress_o(instruction)
	 );


    first_register i_1 (
        .clk        (clk        ),
        .rst        (rst        ),
        .StallD     (StallD     ),
        .FlushD     (FlushD     ),
        .instruction(instruction),
        .PCF        (PCF    ),
        .PCPlus4F   (PCPlus4F   ),
        .instrD     (instrD     ),
        .PCD        (PCD        ),
        .PCPlus4D   (PCPlus4D   )
    );

    PCPlus4 i_pcp4 (
        .PCF     (PCF_co   ),
        .PCPlus4F(PCPlus4F)
    );

    Instruction_Fetch i_iff (
        .instrD (instrD ),
        .A1     (A1     ),
        .A2     (A2     ),
        .RdD    (RdD    ),
        .Rs1D   (Rs1D   ),
        .Rs2D   (Rs2D   ),
        .OP     (OP     ),
        .funct3 (funct3 ),
        .funct7 (funct7 ),
        .Imm    (Imm    ),
        .funct77(funct77)
    );

    Register_File i_rf (
        .A1       (A1       ),
        .A2       (A2       ),
        .RdW      (RdW      ),
        .ResultW  (ResultW  ),
        .clk      (clk      ),
        .RegWriteW(RegWriteW),
        .rst      (rst      ),
        .RD1      (RD1      ),
        .RD2      (RD2      ),
        .checkx1  (checkx1  ),
        .checkx2  (checkx2  ),
        .checkx3  (checkx3  ),
        .checkx4  (checkx4  ),
        .checkx5  (checkx5  ),
        .checkx6  (checkx6  )
    );

    sign_extend i_se (
        .Imm    (Imm    ),
        .ImmSrcD(ImmSrcD),
        .ImmExtD(ImmExtD)
    );

    Second_register i_2 (
        .PCD         (PCD        ),
        .ImmExtD     (ImmExtD    ),
        .PCPlus4D    (PCPlus4D   ),
        .RD1         (RD1        ),
        .RD2         (RD2        ),
        .RdD         (RdD        ),
        .Rs1D        (Rs1D       ),
        .Rs2D        (Rs2D       ),
        .funct3      (funct3     ),
        .rst         (rst        ),
        .clk         (clk        ),
        .RegWriteD   (RegWriteD  ),
        .MemWriteD   (MemWriteD  ),
        .JumpD       (JumpD      ),
        .BranchD     (BranchD    ),
        .ALUSrcD     (ALUSrcD    ),
        .ZeroE       (ZeroE      ),
        .FlushE      (FlushE     ),
        .ResultSrcD  (ResultSrcD ),
        .ALUControlD (ALUControlD),
        .RegWriteE   (RegWriteE  ),
        .MemWriteE   (MemWriteE  ),
        .JumpE       (JumpE      ),
        .BranchE     (BranchE    ),
        .ALUSrcE     (ALUSrcE    ),
        .PCSrcE      (PCSrcE     ),
        .ResultSrcE  (ResultSrcE ),
        .ALUControlE (ALUControlE),
        .PCE         (PCE        ),
        .ImmExtE     (ImmExtE    ),
        .PCPlus4E    (PCPlus4E   ),
        .RD1E        (RD1E       ),
        .RD2E        (RD2E       ),
        .funct3E     (funct3E    ),
        .RdE         (RdE        ),
        .Rs1E        (Rs1E       ),
        .Rs2E        (Rs2E       )
    );

    PCTarget i_pct (
        .PCE       (PCE      ),
        .ImmExtE   (ImmExtE  ),
        .PCTargetE (PCTargetE)
    );

    mux2_alu #(32) mux_scrb (
        .WriteDataE (WriteDataE),
        .ImmExtE    (ImmExtE   ),
        .ALUSrcE    (ALUSrcE   ),
        .SrcBE      (SrcBE     )
    );

    alu i_alu (
        .SrcAE       (SrcAE      ),
        .SrcBE       (SrcBE      ),
        .ALUControlE (ALUControlE),
        .funct3E     (funct3E    ),
        .ALUResult   (ALUResult  ),
        .CarryOut    (CarryOut   ),
        .ZeroE       (ZeroE      )
    );

    third_register i_3 (
        .WriteDataE (WriteDataE),
        .ALUResult  (ALUResult ),
        .PCPlus4E   (PCPlus4E  ),
        .RdE        (RdE       ),
        .clk        (clk       ),
        .rst        (rst       ),
        .RegWriteE  (RegWriteE ),
        .MemWriteE  (MemWriteE ),
        .ResultSrcE (ResultSrcE),
        .ALUResultM (ALUResultM),
        .WriteDataM (WriteDataM),
        .PCPlus4M   (PCPlus4M  ),
        .RdM        (RdM       ),
        .RegWriteM  (RegWriteM ),
        .MemWriteM  (MemWriteM ),
		  .funct3E(funct3E),
		  .funct3M (funct3M),
        .ResultSrcM (ResultSrcM)
    );
	 

    Data_Memory i_dm (
        .WriteDataM (WriteDataM),
        .ALUResultM (ALUResultM),
        .clk        (clk       ),
        .MemWriteM  (MemWriteM ),
        .rst        (rst       ),
        .ReadData   (ReadData  ),
		  .funct3M(funct3M),
		  .funct3M_sel(funct3M_sel),
        .DM0        (DM0       )
    );
	 LS_sel sel (
		  .funct3M(funct3M_sel),
		  .ReadData(ReadData),
		  .select(select_ls),
		  .lw(lw),
		  .lb(lb),
		  .lbu(lbu),
		  .lh(lh),
		  .lhu(lhu)
	 
	 
	 
	 );
	 mux5to1 muxx (
	 .RD(RD),
	 .select(select_ls),
	 .lw(lw),
	 .lb(lb),
	 .lbu(lbu),
	 .lh(lh),
	 .lhu(lhu)
	 
	 
	 );

    fourth_register i_4 (
        .ALUResultM (ALUResultM),
        .ReadData   (RD  ),
        .PCPlus4M   (PCPlus4M  ),
        .RdM        (RdM       ),
        .rst        (rst       ),
        .clk        (clk       ),
        .RegWriteM  (RegWriteM ),
        .ResultSrcM (ResultSrcM),
        .ALUResultW (ALUResultW),
        .ReadDataW  (ReadDataW ),
        .PCPlus4W   (PCPlus4W  ),
        .RdW        (RdW       ),
        .ResultSrcW (ResultSrcW),
        .RegWriteW  (RegWriteW )
    );
    mux3 #(32) mux1 (
        .ALUResultW (ALUResultW),
        .ReadDataW  (ReadDataW ),
        .PCPlus4W   (PCPlus4W  ),
        .ResultSrcW (ResultSrcW),
        .ResultW    (ResultW   )
    );

    Controller i_c (
        .OP          (OP         ),
        .funct77     (funct77    ),
        .funct3      (funct3     ),
        .funct7      (funct7     ),
        .MemWriteD   (MemWriteD  ),
        .ALUSrcD     (ALUSrcD    ),
        .RegWriteD   (RegWriteD  ),
        .BranchD     (BranchD    ),
        .JumpD       (JumpD      ),
        .ResultSrcD  (ResultSrcD ),
        .ALUControlD (ALUControlD),
        .ImmSrcD     (ImmSrcD    )
    );

    hazard_unit i_hu (
        .Rs1E      (Rs1E      ),
        .Rs2E      (Rs2E      ),
        .RdM       (RdM       ),
        .RdW       (RdW       ),
        .Rs1D      (Rs1D      ),
        .Rs2D      (Rs2D      ),
        .RdE       (RdE       ),
        .ResultSrcE(ResultSrcE),
        .RegWriteM (RegWriteM ),
        .RegWriteW (RegWriteW ),
        .PCSrcE    (PCSrcE    ),
		  .flag_PC	 (flag_PCC),
        .StallF    (StallF    ),
        .StallD    (StallD    ),
        .FlushE    (FlushE    ),
        .FlushD    (FlushD    ),
        .ForwardAE (ForwardAE ),
        .ForwardBE (ForwardBE )
    );

    mux5 #(32) muxxx (
        .RD1E      (RD1E      ),
        .ResultW   (ResultW   ),
        .ALUResultM(ALUResultM),
        .ForwardAE (ForwardAE ),
        .SrcAE     (SrcAE     )
    );

    mux4 #(32) muxxxxx (
        .RD2E      (RD2E      ),
        .ResultW   (ResultW   ),
        .ALUResultM(ALUResultM),
        .ForwardBE (ForwardBE ),
        .WriteDataE(WriteDataE)
    );
	 
	assign test = funct3M; 
	assign PCFF = PCF;
endmodule
