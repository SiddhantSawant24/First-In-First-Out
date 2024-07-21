`include "fifo.v"
module tb;
parameter DEPTH=16;
parameter WIDTH=8;
parameter PTR_WIDTH=$clog2(DEPTH);

reg wr_clk_i,rd_clk_i,clr_i,wr_en_i,rd_en_i;
reg [WIDTH-1:0]wdata_i;

wire [WIDTH-1:0]rdata_o;
wire full_o,empty_o,wr_error_o,rd_error_o;

wire [PTR_WIDTH-1:0]wr_ptr,rd_ptr,rd_ptr_gray_wr_clk_i,wr_ptr_gray_rd_clk_i,rd_ptr_gray,wr_ptr_gray;
wire wr_toggle_f,rd_toggle_f,rd_toggle_f_wr_clk_i,wr_toggle_f_rd_clk_i;

wire [WIDTH-1:0] buffer[DEPTH-1:0];

integer i;

reg [500:0]testcase;

fifo #(.DEPTH(DEPTH),.WIDTH(WIDTH),.PTR_WIDTH(PTR_WIDTH)) dut (.*);

always #5 wr_clk_i=~wr_clk_i;
always #10 rd_clk_i=~rd_clk_i;

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
		@(posedge wr_clk_i);
		wr_en_i=1;
		wdata_i=$random();
		end
	@(posedge wr_clk_i)
		reset();
	end
endtask

task read(input integer start_loc, input integer inc_loc);
	begin
	for(i=start_loc;i<=start_loc+inc_loc;i=i+1)begin
		@(posedge rd_clk_i);
		rd_en_i=1;
	end
	@(posedge rd_clk_i);
		reset();
	end
endtask

initial begin
wr_clk_i=0;
rd_clk_i=0;
clr_i=1;
reset();
#30;
clr_i=0;
$value$plusargs("testcase=%s",testcase);
	case (testcase)
		"write_only":begin
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
#1000;
$finish();
end
endmodule
	


			
		
		


	


