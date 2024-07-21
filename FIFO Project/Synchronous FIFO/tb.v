`include "fifo.v"
module tb;
parameter DEPTH=16;
parameter WIDTH=8;
parameter PTR_ADDR=$clog2(DEPTH);

//declaring input ports
reg clk_i,clr_i,wr_en_i,rd_en_i;
reg [WIDTH-1:0]wdata_i;

//declaring output ports
wire [WIDTH-1:0]rdata_o;
wire full_o,empty_o,wr_error_o,rd_error_o;

//declaring memory
wire [WIDTH-1:0] buffer[DEPTH-1:0];
wire [PTR_ADDR-1:0] wr_ptr,rd_ptr;
wire wr_toggle_f,rd_toggle_f;

reg [300:0]testcase;

integer i;

fifo #(.DEPTH(DEPTH),.WIDTH(WIDTH),.PTR_ADDR(PTR_ADDR)) dut (.*);

always #5 clk_i=~clk_i;

task reset();
	begin
	wr_en_i=0;
	rd_en_i=0;
	wdata_i=0;
	end
endtask

task write(input integer start_loc, input integer inc_loc);
	begin
	for(i=start_loc;i<=start_loc+inc_loc;i=i+1)begin
		@(posedge clk_i);
		wr_en_i=1;
		wdata_i=$random();
		end
	
	@(posedge clk_i);
	reset();
	end
endtask

task read(input integer start_loc, input integer inc_loc);
	begin
	for(i=start_loc;i<=start_loc+inc_loc;i=i+1)begin
		@(posedge clk_i);
		rd_en_i=1;
		end

	@(posedge clk_i);
	reset();
	end
endtask


initial begin
clk_i=0;
clr_i=1;
reset();
#30;
clr_i=0;
$value$plusargs("testcase=%s",testcase);
	case (testcase)
		"full_write":begin
			write(0,DEPTH-1);
		end

		"write_read":begin
			write(0,DEPTH-1);
			read(0,DEPTH-1);
		end

		"write_error":begin
			write(0,DEPTH+2);
			read(0,DEPTH-1);
		end

		"read_error":begin
			write(0,DEPTH-1);
			read(0,DEPTH+2);
		end
	endcase
end



initial begin 
#500;
$finish();
end

endmodule



