`include "defines.v"

module ram(clk, rst, wr_rd, en, addr, data_in, data_out, en_out);
  input clk, rst, wr_rd, en;
  input [`addr_width-1:0] addr;
  input [`data_width-1:0] data_in;
  output reg en_out;
  output reg [`data_width-1:0] data_out;

  reg [`data_width-1:0] mem[`data_depth-1:0];
  integer i;

  // Main RAM logic
  always @(posedge clk) begin
    if (!rst) begin
      // synchronous reset
      for (i = 0; i < `data_depth; i = i + 1)
        mem[i] <= 0;
      data_out <= 0;
      en_out <= 0;
      $display("Reset: Mem cleared");
    end
    else if (en) begin
      if (wr_rd) begin
        // write operation
        mem[addr] <= data_in;
        $display("Write: Mem[%0h] <= %0h", addr, data_in);
        en_out <= 0;
      end
      else begin
        // read operation
        data_out <= mem[addr];
        en_out <= 1;
        $display("Read: Mem[%0h] => %0h", addr, mem[addr]);
      end
    end else begin
      en_out <= 0;
    end
  end

  // Clear en_out one cycle later
  always @(posedge clk) begin
    if (en_out)
      en_out <= 0;
  end
endmodule

