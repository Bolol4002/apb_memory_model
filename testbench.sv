`timescale 1ns/1ps

module tb_apb_memory;

    reg pclk, prst;
    reg [7:0] paddr;
    reg pwrite, psel, penable;
    reg [7:0] pwdata;
    reg load, fetch;
    wire [7:0] prdata;
    wire pready, pslverr;

    // Instantiate DUT
    apb_memory dut (
        .pclk(pclk), .prst(prst),
        .paddr(paddr), .pwrite(pwrite), .pwdata(pwdata),
        .psel(psel), .penable(penable),
        .load(load), .fetch(fetch),
        .prdata(prdata), .pready(pready), .pslverr(pslverr)
    );

    // Clock generation
    always #5 pclk = ~pclk;

    initial begin
        // For waveform viewing
        $dumpfile("apb_memory.vcd");
        $dumpvars(0, tb_apb_memory);

        pclk = 0;
        prst = 1; load = 0; fetch = 0;
        psel = 0; penable = 0; pwrite = 0;
        paddr = 0; pwdata = 0;

        #10 prst = 0;

        // Load memory from hex
        load = 1;
        #10 load = 0;

        // Write example
        psel = 1; penable = 1; pwrite = 1;
        paddr = 8'd5; pwdata = 8'hA5;
        #10;

        // Read example
        pwrite = 0;
        paddr = 8'd5;
        #10;

        // Dump memory
        fetch = 1;
        #10 fetch = 0;

        #50 $finish;
    end

endmodule
