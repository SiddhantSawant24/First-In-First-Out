module fifo(clk_i,clr_i,wdata_i,rdata_o,wr_en_i,rd_en_i,full_o,empty_o,wr_error_o,rd_error_o);
parameter DEPTH=16;
parameter WIDTH=8;
parameter PTR_ADDR=$clog2(DEPTH);

//declaring input ports
input clk_i,clr_i,wr_en_i,rd_en_i;
input [WIDTH-1:0]wdata_i;

//declaring output ports
output reg [WIDTH-1:0]rdata_o;
output reg full_o,empty_o,wr_error_o,rd_error_o;

//declaring memory
reg [WIDTH-1:0] buffer[DEPTH-1:0];
reg [PTR_ADDR-1:0] wr_ptr,rd_ptr;
reg wr_toggle_f,rd_toggle_f;

integer i;


//Write and Read Operations
always @(posedge clk_i)begin
wr_error_o=0;
rd_error_o=0;
	if(clr_i)begin  //set all reg datatypes to zero
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
		if(wr_en_i)begin
			if(full_o)begin
				wr_error_o=1;
				end
			else begin
				buffer[wr_ptr]=wdata_i; //write the data into buffer
					if (wr_ptr==DEPTH-1) wr_toggle_f=~wr_toggle_f; //checking condition for rollover
				wr_ptr=wr_ptr+1;
				end
			end
		end

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

// Conditions for full and empty
always @(posedge clk_i)begin
full_o=0;
empty_o=0;
	if((wr_ptr==rd_ptr)&&(wr_toggle_f!=rd_toggle_f))begin
		full_o=1;
		end
	else begin
		full_o=0;
		end


	if((wr_ptr==rd_ptr)&&(wr_toggle_f==rd_toggle_f))begin
		empty_o=1;
		end
	else begin
		empty_o=0;
		end
	end
endmodule

		

