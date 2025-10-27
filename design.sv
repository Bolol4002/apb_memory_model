
module apb_memory (
    input         pclk,
    input         prst,
    input  [7:0]  paddr,
    input         pwrite,
    input  [7:0]  pwdata,
    input         psel,
    input         penable,
    input         load,
    input         fetch,
    output reg [7:0] prdata,
    output reg    pready,
    output reg    pslverr
);

    reg [7:0] mem [0:127];
    integer i;

    always @(posedge pclk or posedge prst) begin
        if (prst) begin
            for (i = 0; i < 128; i = i + 1)
                mem[i] <= 8'h00;
            pready  <= 1'b0;
            pslverr <= 1'b0;
            prdata  <= 8'h00;
        end
        else begin
            if (load) begin
                $readmemh("image_i.hex", mem);
                $display("Memory initialized from image_i.hex");
            end
            if (fetch) begin
                $writememh("image_o.hex", mem);
                $display("Memory dumped to image_o.hex");
            end

            if (!penable)
                pready <= 1'b0;
            else begin
                pready <= 1'b1; 
                if (psel) begin
                    if (paddr < 128) begin
                        pslverr <= 1'b0;
                        if (pwrite) begin
                            mem[paddr] <= pwdata;
                            $display("WRITE: Addr=%0d Data=%0h", paddr, pwdata);
                        end else begin
                            prdata <= mem[paddr];
                            $display("READ : Addr=%0d Data=%0h", paddr, mem[paddr]);
                        end
                    end else begin
                        pslverr <= 1'b1; 
                    end
                end
            end
        end
    end

endmodule
