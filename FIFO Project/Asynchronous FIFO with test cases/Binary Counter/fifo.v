module fifo(wr_clk_i,rd_clk_i,clr_i,wdata_i,rdata_o,wr_en_i,rd_en_i,,full_o,empty_o,wr_error_o,rd_error_o);
parameter DEPTH=16;
parameter WIDTH=8;
parameter PTR_ADDR=$clog2(DEPTH);

input wr_clk_i,rd_clk_i,clr_i,wr_en_i,rd_en_i;
input [WIDTH-1:0]wdata_i;

output reg [WIDTH-1:0]rdata_o;
output reg full_o,empty_o,wr_error_o,rd_error_o;

//internal registers
reg [PTR_ADDR-1:0]wr_ptr,rd_ptr,rd_ptr_wr_clk_i,wr_ptr_rd_clk_i;
reg wr_toggle_f,rd_toggle_f,rd_toggle_f_wr_clk_i,wr_toggle_f_rd_clk_i;

//declaring buffer
reg[WIDTH-1:0] buffer[DEPTH-1:0];

integer i;

always @(posedge wr_clk_i)begin
	if (clr_i)begin
		rdata_o=0;
		full_o=0;
		empty_o=1;
		wr_error_o=0;
		rd_error_o=0;
		wr_ptr=0;
		rd_ptr=0;
		wr_toggle_f=0;
		rd_toggle_f=0;
		for(i=0;i<DEPTH;i=i+1)begin
			buffer[i]=0;
		end
	end

	else begin
		wr_error_o=0;
			if(wr_en_i)begin
				if(full_o)begin
					wr_error_o=1;
				end
				else begin
				buffer[wr_ptr]=wdata_i;
					if (wr_ptr==DEPTH-1) wr_toggle_f=~wr_toggle_f;
				wr_ptr=wr_ptr+1;
				end
			end
		end
	end

always @(posedge rd_clk_i)begin
	rd_error_o=0;
	if (clr_i !=1)begin
		if(rd_en_i)begin
			if(empty_o)begin
				rd_error_o=1;
				end
			else begin
				rdata_o=buffer[rd_ptr];
					if(rd_ptr==DEPTH-1) rd_toggle_f=~rd_toggle_f;
				rd_ptr=rd_ptr+1;
				end
			end
		end
	end

//synchronization
always @(posedge wr_clk_i)begin
	rd_ptr_wr_clk_i<=rd_ptr;
	rd_toggle_f_wr_clk_i<=rd_toggle_f;
	end

always @(posedge rd_clk_i)begin
	wr_ptr_rd_clk_i<=wr_ptr;
	wr_toggle_f_rd_clk_i<=wr_toggle_f;
	end

always @(*)begin
	full_o=0;
	empty_o=0;

	if((wr_ptr == rd_ptr_wr_clk_i)&&(wr_toggle_f != rd_toggle_f_wr_clk_i))begin
		full_o=1;
	end
	else begin
		full_o=0;
	end


	if((wr_ptr_rd_clk_i == rd_ptr)&&(wr_toggle_f_rd_clk_i == rd_toggle_f))begin
		empty_o=1;
	end
	else begin
		empty_o=0;
	end
end
endmodule




