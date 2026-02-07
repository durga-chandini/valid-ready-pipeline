  module tb;
    logic clk;
    logic rst_n;
    logic in_valid;
    logic in_ready;
    logic [31:0] in_data;
    logic out_valid;
    logic out_ready;
    logic [31:0] out_data;

    pipeline_reg dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .in_ready(in_ready),
        .in_data(in_data),
        .out_valid(out_valid),
        .out_ready(out_ready),
        .out_data(out_data)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
      $dumpfile("dump.vcd");
      $dumpvars(0, tb);
    end
       
    initial begin
        rst_n    = 0;
        in_valid = 0;
        in_data  = 0;
        out_ready= 0;

        // RESET
        #20 rst_n = 1;

        // SEND DATA, DOWNSTREAM NOT READY
        #10;
        in_valid = 1;
        in_data  = 32'hAAAA;
        out_ready= 0;

        // NOW DOWNSTREAM READY
        #20;
        out_ready = 1;

        // SEND ANOTHER DATA
        #10;
        in_data = 32'hBBBB;

        #20;
        in_valid = 0;

        #30;
        $finish;
    end

endmodule
