class wr_tx extends uvm_sequence_item;
  parameter int WIDTH = `WIDTH;
  rand bit wr_en;
  rand bit [WIDTH-1:0] data;
  rand int write_delay;
  `uvm_object_utils_begin(wr_tx)
  	`uvm_field_int(wr_en, UVM_ALL_ON)
  `uvm_field_int(data, UVM_ALL_ON)
  `uvm_field_int(write_delay, UVM_ALL_ON)
  `uvm_object_utils_end
  `NEW_OBJ
  
  constraint soft_c{
    soft write_delay == 0;
  }
  
endclass
