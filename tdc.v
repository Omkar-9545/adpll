module tdc #(
    parameter CHAIN_LEN = 128 // Length of the delay chain
)(
    input wire clk_ref,    // Reference Clock
    input wire clk_dco,    // DCO Output (Fast Clock)
    input wire rst_n,
    output reg [CHAIN_LEN-1:0] tdc_out_a, // Coarse measurement
    output reg [CHAIN_LEN-1:0] tdc_out_b  // Fine measurement
);

    // --- Delay Chains ---
    // In a real synthesis flow, these must be "dont_touch" or instantiated cells
    // to prevent optimization. For behavioral simulation:
    
    wire [CHAIN_LEN-1:0] delay_chain_a;
    wire [CHAIN_LEN-1:0] delay_chain_b;
    
    genvar i;
    generate
        // TDC A: Coarse Chain (Larger Delay)
        assign delay_chain_a[0] = clk_dco; 
        for (i = 1; i < CHAIN_LEN; i = i + 1) begin : chain_a
            assign #2 delay_chain_a[i] = delay_chain_a[i-1]; // #2 simulates larger delay
        end

        // TDC B: Fine Chain (Smaller Delay)
        assign delay_chain_b[0] = clk_dco;
        for (i = 1; i < CHAIN_LEN; i = i + 1) begin : chain_b
            assign #1 delay_chain_b[i] = delay_chain_b[i-1]; // #1 simulates smaller delay
        end
    endgenerate

    // --- Sampling Registers ---
    // Capture the state of the chains on the rising edge of clk_ref
    always @(posedge clk_ref or negedge rst_n) begin
        if (!rst_n) begin
            tdc_out_a <= 0;
            tdc_out_b <= 0;
        end else begin
            tdc_out_a <= delay_chain_a;
            tdc_out_b <= delay_chain_b;
        end
    end

endmodule
