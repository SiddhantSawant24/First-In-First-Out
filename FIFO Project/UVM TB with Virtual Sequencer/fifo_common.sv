`define NEW_COMP\
function new(string name, uvm_component parent);\
	super.new(name,parent);\
endfunction

`define NEW_OBJ\
function new(string name="");\
	super.new(name);\
endfunction

`define ADDR_WIDTH 8
`define WIDTH 8
`define DEPTH 8
`define MAX_WR_DELAY 13
`define MAX_RD_DELAY 10

class fifo_common;
  static int num_matches;
  static int num_mismatches;
endclass
