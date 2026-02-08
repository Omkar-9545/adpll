module controller (
    input wire rst_n,
    input wire up,         // Filtered UP signal
    input wire dn,         // Filtered DN signal
    input wire [7:0] coarse_in, // Initial Coarse code from Decoder
    input wire tdc_done,   // Flag to switch from Coarse to Fine mode
    output reg [7:0] dco_code // Combined Control Word
);

    reg [7:0] fine_tune;

    // --- Fine Tuning Loop ---
    // Active continuously to track phase error
    always @(posedge up or posedge dn or negedge rst_n) begin
        if (!rst_n) begin
            fine_tune <= 8'd0; // Start at 0 offset
        end else begin
            if (up)
                fine_tune <= fine_tune + 1;
            else if (dn)
                fine_tune <= fine_tune - 1;
        end
    end

    // --- Mode Switching (Coarse -> Fine) ---
    always @(*) begin
        if (!tdc_done) begin
            // During startup/calibration, use the Coarse Code from Decoder
            dco_code = coarse_in; 
        end else begin
            // In lock state, add the Fine Tune offset to the Coarse base
            dco_code = coarse_in + fine_tune;
        end
    end

endmodule
