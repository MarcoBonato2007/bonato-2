`timescale 1ns/1ps

module tb_data_path;
    logic clk;
    logic reset;
    string elf_path; // can be left empty, used for debug info
    string hex_path;
    int unsigned max_cycle_count;
    int unsigned cycle_count;

    data_path dut (
        .clk (clk),
        .rst (reset)
    );

    function void print_info (); // shown on error
        $display("Fetch stage information");
            $display("PC value: %h", dut.pc_i.currentpc); 
            $display("Instruction: %h", dut.instr_mem_i.instr);
            $display("\n");

        $display("Decode stage information");
            $display("PC value: %h", dut.if_id_q.pc);
            $display("ALU op: %b", dut.decoder_i.alu_op);
            $display("Funct3: %b", dut.decoder_i.funct3);
            $display("rs1: %h", dut.decoder_i.rs1);
            $display("rs1 value: %h", dut.regfile_i.rs1_val);
            $display("rs2: %h", dut.decoder_i.rs2);
            $display("rs2 value: %h", dut.regfile_i.rs2_val);
            $display("rd: %h", dut.decoder_i.rd);
            $display("Mem mode: %b", dut.decoder_i.mem_mode);
            $display("ALU in1 sel: %b", dut.decoder_i.alu_in1_sel);
            $display("ALU in2 sel: %b", dut.decoder_i.alu_in2_sel);
            $display("RF in sel: %b", dut.decoder_i.rf_in_sel);
            $display("Is conditional: %b", dut.decoder_i.is_cond);
            $display("Next PC is branch: %b", dut.decoder_i.nextpc_is_branch);
            $display("Immediate: %h", dut.decoder_i.imm);
            $display("\n");

        $display("Execute stage information");
            $display("PC value: %h", dut.id_ex_q.pc);
            $display("ALU op: %b", dut.id_ex_q.alu_op);
            $display("Funct3: %b", dut.id_ex_q.funct3);
            $display("rs1: %h", dut.id_ex_q.rs1);
            $display("rs1 value: %h", dut.id_ex_q.rs1_val);
            $display("rs2: %h", dut.id_ex_q.rs2);
            $display("rs2 value: %h", dut.id_ex_q.rs2_val);
            $display("rd: %h", dut.id_ex_q.rd);
            $display("Mem mode: %b", dut.id_ex_q.mem_mode);
            $display("ALU in1 sel: %b", dut.id_ex_q.alu_in1_sel);
            $display("ALU in2 sel: %b", dut.id_ex_q.alu_in2_sel);
            $display("RF in sel: %b", dut.id_ex_q.rf_in_sel);
            $display("Is conditional: %b", dut.id_ex_q.is_cond);
            $display("Next PC is branch: %b", dut.id_ex_q.nextpc_is_branch);
            $display("Immediate: %h", dut.id_ex_q.imm);
            $display("ALU out: %h", dut.alu_i.alu_out);
            $display("Comparison result: %b", dut.comparison_result_ex);
            $display("\n");

        $display("Memory stage information");
            $display("PC+4: %h", dut.ex_mem_q.pcplus4);
            $display("ALU out: %h", dut.ex_mem_q.alu_out);
            $display("rs2 value: %h", dut.ex_mem_q.rs2_val);
            $display("rd: %h", dut.ex_mem_q.rd);
            $display("Mem mode: %b", dut.ex_mem_q.mem_mode);
            $display("RF in sel: %b", dut.ex_mem_q.rf_in_sel);
            $display("Mem out: %h", dut.data_mem_i.mem_out);
            $display("\n");

        $display("Writeback stage information");
            $display("PC+4: %h", dut.mem_wb_q.pcplus4);
            $display("ALU out: %h", dut.mem_wb_q.alu_out);
            $display("rd: %h", dut.mem_wb_q.rd);
            $display("RF in sel: %b", dut.mem_wb_q.rf_in_sel);
            $display("Mem out: %h", dut.mem_wb_q.mem_out);
            $display("\n");

        $dumpflush;
    endfunction

    always #5 clk = ~clk; // 100 MHz frequency, 1 cycle = 10ns

    initial begin
        if (!$value$plusargs("ELF=%s", elf_path))
            $fatal(1, "Missing +ELF=<file>");
        if (!$value$plusargs("HEX=%s", hex_path))
            $fatal(1, "Missing +HEX=<file>");
        if (!$value$plusargs("MAX_CYCLES=%d", max_cycle_count))
            $fatal(1, "Missing +MAX_CYCLES=<value>");

        $readmemh(hex_path, dut.instr_mem_i.rom);

        // comment out if not debugging
        // $dumpfile("waveform.vcd");
        // $dumpvars(0, tb_data_path);

        clk = 0;
        reset = 1;
        #20;
        reset = 0;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            cycle_count <= 0;
        end

        if (dut.data_mem_i.mem.exists(32'h2000_0000)) begin
            if (dut.data_mem_i.mem[32'h2000_0000] == 8'b0) begin
                $display(
                    "RVCP-SUMMARY: TEST PASSED - Test File \"%s\"",
                    elf_path
                );
                $finish;
            end else if (dut.data_mem_i.mem[32'h2000_0000] == 8'b1) begin
                print_info();
                $fatal(
                    1,
                    "RVCP-SUMMARY: TEST FAILED - Test File \"%s\"",
                    elf_path
                );
            end else begin
                print_info();
                $fatal(
                    1,
                    "RVCP-SUMMARY: INCORRECT TERMINATION VALUE \"%b\" - Test File \"%s\"",
                    dut.data_mem_i.mem[32'h2000_0000],
                    elf_path
                );
            end
        end

        if (cycle_count >= max_cycle_count) begin
            print_info();
            $fatal(
                1,
                "RVCP-SUMMARY: TEST TIMED OUT - Test File \"%s\"",
                elf_path
            );
        end

        cycle_count <= cycle_count + 1;
    end
endmodule
