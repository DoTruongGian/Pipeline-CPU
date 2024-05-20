module Instruction_Memory (
    input logic [31:0] PCF,
    output logic [31:0] instruction
);
    logic [31:0] instructions_Value [255:0]; // Maximum 256 instructions can be stored

    initial begin
        // Prefer absolute paths in simulators
        $readmemh("instruction.txt", instructions_Value);
    end

    always_comb begin
        // Instead of dividing, we can ignore the least 2 LSBs
        instruction = instructions_Value[PCF[31:2]];
    end
endmodule
