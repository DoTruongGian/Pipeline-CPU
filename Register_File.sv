module Register_File (
    input logic [4:0]  A1,
    input logic [4:0]  A2,
    input logic [4:0]  RdW,
    input logic [31:0] ResultW,
    input logic        clk,
    input logic        RegWriteW,
    input logic        rst,
    output logic [31:0] RD1,
    output logic [31:0] RD2,
    output logic [31:0] checkx1,  //it is to see x1 of register file (you can ignore it if your simulator allows you to see full RF)
    output logic [31:0] checkx2,
    output logic [31:32] checkx3,
    output logic [31:0] checkx4,
    output logic [31:0] checkx5,
    output logic [31:0] checkx6
);
    logic [31:0] Registers[31:0];
    integer i;

    // Sequential block for register file updates and initialization
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                Registers[i] <= 32'd0;
            end
            Registers[28] <= 32'd6;
            Registers[22] <= 32'd4;
            Registers[18] <= 32'd6;
        end else if (RegWriteW && (|RdW)) begin // |RdW, avoid writing at x0
            Registers[RdW] <= ResultW;
        end
    end

    // Combinational block for read operations
    always_comb begin
        // Read operations
        RD1 = Registers[A1];
        RD2 = Registers[A2];

        // Output checks
        checkx1 = Registers[1];
        checkx2 = Registers[2];
        checkx3 = Registers[3];
        checkx4 = Registers[4];
        checkx5 = Registers[5];
        checkx6 = Registers[6];
    end
endmodule

