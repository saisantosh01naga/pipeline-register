module pipeline_reg #(
    parameter DATA_W = 32
)(
    input  logic                 clk,
    input  logic                 rst_n,

    // Input interface
    input  logic                 in_valid,
    output logic                 in_ready,
    input  logic [DATA_W-1:0]    in_data,

    // Output interface
    output logic                 out_valid,
    input  logic                 out_ready,
    output logic [DATA_W-1:0]    out_data
);

    logic full;
    logic [DATA_W-1:0] data_q;

    // Ready when empty or when downstream is ready
    assign in_ready  = ~full || out_ready;
    assign out_valid = full;
    assign out_data  = data_q;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            full   <= 1'b0;
            data_q <= '0;
        end else begin
            // Data consumed by downstream
            if (full && out_ready)
                full <= 1'b0;

            // Accept new data
            if (in_valid && in_ready) begin
                data_q <= in_data;
                full   <= 1'b1;
            end
        end
    end

endmodule
