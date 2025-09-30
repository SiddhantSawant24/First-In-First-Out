class rd_tx extends uvm_sequence_item;
  parameter int WIDTH = `WIDTH;
   rand bit rd_en;
  bit [WIDTH-1:0] data;
  rand int delay;
  `uvm_object_utils_begin(rd_tx)
 	 `uvm_field_int(rd_en, UVM_ALL_ON)
 	 `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end
  `NEW_OBJ
  
   constraint soft_c{
    soft delay == 0;
  }
  
endclass

