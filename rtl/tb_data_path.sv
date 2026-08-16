`timescale 1ns/1ps

module tb_data_path;
    logic clk;
    logic reset;
    string program_file_path; // path to .hex program file
    int unsigned cycle_count;

    data_path dut (
        .clk (clk),
        .rst (reset)
    );

    always #5 clk = ~clk; // 100 MHz frequency, 1 cycle = 10ns

    initial begin
        if (!$value$plusargs("PROGRAM=%s", program_file_path))
            $fatal(1, "Missing +PROGRAM=<file>");
        $readmemh(program_file_path, dut.instr_mem_i.rom);

        clk = 0;
        reset = 1;
        #20;
        reset = 0;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            cycle_count <= 0;
        end


        // TODO: add more error logs on a fatal error, comment out later
            // failing pc, pipeline state, etc.
        // check if pc gets close to 0x40294 (termination area)

        if (dut.data_mem_i.mem.exists(32'h2000_0000)) begin
            if (dut.data_mem_i.mem[32'h2000_0000] == 8'b0) begin
                $display(
                    "RVCP-SUMMARY: TEST PASSED - Test File \"%s\"",
                    program_file_path
                );
                $finish;
            end else if (dut.data_mem_i.mem[32'h2000_0000] == 8'b1) begin
                $fatal(
                    1,
                    "RVCP-SUMMARY: TEST FAILED - Test File \"%s\"",
                    program_file_path
                );
            end else begin
                $fatal(
                    1,
                    "RVCP-SUMMARY: INCORRECT TERMINATION VALUE \"%b\" - Test File \"%s\"",
                    dut.data_mem_i.mem[32'h2000_0000],
                    program_file_path
                );
            end
        end

        if (cycle_count >= 1000000) begin
            $fatal(
                1,
                "RVCP-SUMMARY: TEST TIMED OUT - Test File \"%s\"",
                program_file_path
            );
        end

        cycle_count <= cycle_count + 1;
    end
endmodule
