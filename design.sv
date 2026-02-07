module pipeline_reg #(
    parameter int DATA_WIDTH = 32
)(
    input  logic                  clk,
    input  logic                  rst_n,

    // Input interface
    input  logic                  in_valid,
    output logic                  in_ready,
    input  logic [DATA_WIDTH-1:0] in_data,

    // Output interface
    output logic                  out_valid,
    input  logic                  out_ready,
    output logic [DATA_WIDTH-1:0] out_data
);

    // Internal storage
    logic                  pipe_valid;
    logic [DATA_WIDTH-1:0] pipe_data;

    // Pipeline is ready when empty or when downstream can accept data
    assign in_ready = ~pipe_valid || out_ready;

    // Sequential logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pipe_valid <= 1'b0;
            pipe_data  <= '0;
        end else begin
            // Accept new data
            if (in_valid && in_ready) begin
                pipe_valid <= 1'b1;
                pipe_data  <= in_data;
            end
            // Data consumed without replacement
            else if (pipe_valid && out_ready) begin
                pipe_valid <= 1'b0;
            end
        end
    end

    // Output assignments
    assign out_valid = pipe_valid;
    assign out_data  = pipe_data;

endmodule
