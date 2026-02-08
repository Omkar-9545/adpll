module decoder #(
    parameter CHAIN_LEN = 128,
    parameter BIT_WIDTH = 8 // Width of the output Coarse Code
)(
    input wire [CHAIN_LEN-1:0] tdc_in_a,
    input wire [CHAIN_LEN-1:0] tdc_in_b,
    output reg [BIT_WIDTH-1:0] coarse_tune
);

    integer i;
    reg [BIT_WIDTH-1:0] count_a;
    reg [BIT_WIDTH-1:0] count_b;

    always @(*) begin
        // 1. Thermometer to Binary Conversion
        count_a = 0;
        count_b = 0;
        
        for (i = 0; i < CHAIN_LEN; i = i + 1) begin
            if (tdc_in_a[i]) count_a = count_a + 1;
            if (tdc_in_b[i]) count_b = count_b + 1;
        end

        // 2. Logic to determine Coarse Tune
        // The paper implies this value sets the initial frequency.
        // We average or select the valid reading to estimate the period.
        // Simplified logic based on "Two-Cycle" estimation:
        if (count_a > 0)
            coarse_tune = count_a; // Priority to coarse chain if valid
        else
            coarse_tune = count_b;
    end

endmodule
