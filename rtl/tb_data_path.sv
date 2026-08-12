`timescale 1ns/1ps

module tb_data_path;
    logic clk;
    logic reset;

    data_path dut (
        .clk (clk),
        .rst (reset)
    );

    always #5 clk = ~clk; // 100 MHz frequency, 1 cycle = 10ns

    initial begin
        clk = 0;
        reset = 1;

        #20;
        reset = 0;

        #1000; // wait 1000 nanoseconds (100 cycles)

        $display("Simulation completed successfully.");
        $finish;
    end

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_data_path);
    end
endmodule
