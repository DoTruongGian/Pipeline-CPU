module main_tb;
    // Clock and reset signals
    logic clk;
    logic rst;

    // Outputs from the main module
    logic [31:0] checkx1;
    logic [31:0] checkx2;
    logic [31:0] checkx3;
    logic [31:0] checkx4;
    logic [31:0] checkx5;
    logic [31:0] checkx6;
    logic [31:0] DM0;
    logic [2:0] test;
    logic flag_2comm;
	 logic [31:0] temp_inss;
	 logic flag_PCC;
	 logic [31:0] PCFF;
    logic [31:0] instruction;

    // Instantiate the module under test (MUT)
    main mut (
        .clk(clk),
        .rst(rst),
        .checkx1(checkx1),
        .checkx2(checkx2),
        .checkx3(checkx3),
        .checkx4(checkx4),
        .checkx5(checkx5),
        .checkx6(checkx6),
        .DM0(DM0),
		  .PCFF(PCFF),
	.flag_2comm(flag_2comm),
		  .flag_PCC(flag_PCC),
		  .temp_inss(temp_inss),
        .test(test),
        .instruction(instruction)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end

    // Stimulus process
    initial begin
        // Initialize reset
        rst = 1;
        #20;
        rst = 0;

        // Apply test vectors
        // Add your test cases here. For example:
        // Test case 1: Initial reset state
        #100;
        
        // Test case 2: Apply some inputs and observe outputs
        // (Adjust as needed for your specific module functionality)

        // End of simulation
        #50000;
        $finish;
    end

    // Monitor the signals
    initial begin
        $monitor("Time: %0dns, checkx1: %h, checkx2: %h, checkx3: %h, checkx4: %h, checkx5: %h, checkx6: %h, DM0: %h, test: %b, instruction: %h",
                 $time, checkx1, checkx2, checkx3, checkx4, checkx5, checkx6, DM0, test, instruction);
    end

    // Dump waves (optional)
    initial begin
        $dumpfile("main_tb.vcd");
        $dumpvars(0, main_tb);
    end
endmodule

