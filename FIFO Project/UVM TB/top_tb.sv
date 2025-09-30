`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "fifo_common.sv"
`include "fifo.v"
`include "fifo_intf.sv"

`include "wr_tx.sv"
`include "write_seq_lib.sv"
`include "write_drv.sv"
`include "write_sqr.sv"
`include "write_mon.sv"
`include "write_cov.sv"
`include "write_agent.sv"

`include "rd_tx.sv"
`include "read_seq_lib.sv"
`include "read_drv.sv"
`include "read_sqr.sv"
`include "read_mon.sv"
`include "read_cov.sv"
`include "read_agent.sv"

`include "fifo_sbd.sv"
`include "fifo_env.sv"
`include "test_lib.sv"


module top;
parameter DEPTH=`DEPTH;
parameter WIDTH=`WIDTH;
parameter PTR_WIDTH=$clog2(DEPTH);

  fifo_intf pif();


fifo #(.DEPTH(DEPTH),.WIDTH(WIDTH),.PTR_WIDTH(PTR_WIDTH)) dut (.wr_clk_i(pif.wr_clk_i),
	.rd_clk_i(pif.rd_clk_i),
	.clr_i(pif.clr_i), //For clk and clr it doesnt matter if you write pif or not...here writing just for safety
	.wr_en_i(pif.wr_en_i),
	.wdata_i(pif.wdata_i),
	.full_o(pif.full_o),
	.rd_en_i(pif.rd_en_i),
	.rdata_o(pif.rdata_o),
	.empty_o(pif.empty_o),
	.wr_error_o(pif.wr_error_o),
	.rd_error_o(pif.rd_error_o)
);

always #5 pif.wr_clk_i=~pif.wr_clk_i;
always #10 pif.rd_clk_i=~pif.rd_clk_i;

task reset();

	begin
	pif.wr_en_i=0;
	pif.rd_en_i=0;
	pif.wdata_i=0;
    end
endtask

initial begin
	run_test("wr_rd_fifo_test");
end


initial begin
  uvm_resource_db#(virtual fifo_intf)::set("GLOBAL","PIF", pif, null);
pif.wr_clk_i=0;
pif.rd_clk_i=0;
pif.clr_i=1;
reset();
#30;
pif.clr_i=0;

#1000;
$finish();
end
  
initial begin 
	
	$dumpfile("1.vcd");
	$dumpvars();
end




endmodule

