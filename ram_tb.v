`include "defines.v"

module ram_tb;

reg clk, rst, wr_rd, en;
reg [`addr_width-1:0] addr;
reg [`data_width-1:0] data_in;
wire en_out;
wire [`data_width-1:0] data_out;

ram dut(clk, rst, wr_rd, en, addr, data_in, data_out, en_out);

// Local test variables
reg [`addr_width-1:0] addr_t;
reg [`data_width-1:0] data_out_t;
reg [`data_width-1:0] temp[`data_depth-1:0];

// Clock generation
initial begin
  clk = 0;
  forever #5 clk = ~clk;
end

// Reset logic
initial begin
  rst = 0;
  en = 0;
  #10;
  en = 1;
  rst = 1;
end

// Main test sequence
initial begin
  repeat(20)begin
  #20;
  data_write();
  @(posedge clk);
  @(posedge clk);
  data_read();
  comp();
end
  #1000 $finish;
end

task data_write;
begin
  wr_rd = 1; // write
  addr = $random;
  data_in = $random;
  addr_t = addr;
  temp[addr_t] = data_in;

  @(posedge clk); // Let RAM capture values
  $display("TB: Write done: Addr=%h, Data=%h", addr, data_in);
end
endtask

task data_read;
begin
  wr_rd = 0; // read
  addr = addr_t;

  @(posedge clk); // setup read
  @(posedge en_out); // wait for read to complete
  data_out_t = data_out;
  $display("TB: Read done: Addr=%h, Data=%h", addr, data_out_t);
end
endtask

task comp;
begin
  if (temp[addr_t] == data_out_t) begin
    $display("? RAM TEST PASSED");
  end else begin
    $display("? RAM TEST FAILED");
    $display("Expected: %h, Got: %h", temp[addr_t], data_out_t);
  end
end
endtask

endmodule

