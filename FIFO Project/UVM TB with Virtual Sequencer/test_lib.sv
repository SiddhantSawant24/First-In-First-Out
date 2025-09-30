class fifo_base_test extends uvm_test;
fifo_env env;
`uvm_component_utils(fifo_base_test)
`NEW_COMP

  function void build_phase(uvm_phase phase);
	env = fifo_env::type_id::create("env",this);	
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction
  
  function void report_phase(uvm_phase phase);
    if (fifo_common::num_mismatches > 0 || fifo_common::num_matches == 0)begin
      `uvm_error("STATUS", $psprintf("TEST FAIL, num_matches = %0d, num_mismatches = %0d",fifo_common::num_matches, fifo_common::num_mismatches))
    end
    else begin
      `uvm_info("STATUS", $psprintf("TEST PASSED, num_matches = %0d, num_mismatches = %0d",fifo_common::num_matches, fifo_common::num_mismatches), UVM_LOW)
    end
  endfunction
  
endclass


class wr_rd_fifo_test extends fifo_base_test;
`uvm_component_utils(wr_rd_fifo_test)
`NEW_COMP
  
  function void build_phase(uvm_phase phase);
	env = fifo_env::type_id::create("env",this);
    uvm_resource_db#(int)::set("GLOBAL","WRITE_COUNT",`DEPTH,this);
    uvm_resource_db#(int)::set("GLOBAL","READ_COUNT",`DEPTH,this);
endfunction
  
  task run_phase(uvm_phase phase);
    write_seq write_seq_i;
    read_seq read_seq_i;
    write_seq_i = write_seq::type_id::create("write_seq_i");
    read_seq_i = read_seq::type_id::create("read_seq_i");
    
    phase.raise_objection(this);
    phase.phase_done.set_drain_time(this,100);
   		write_seq_i.start(env.write_agent_i.sqr);
    	read_seq_i.start(env.read_agent_i.sqr);
    phase.drop_objection(this);
    
  endtask
endclass


class fifo_full_error_test extends fifo_base_test;
`uvm_component_utils(fifo_full_error_test)
`NEW_COMP
  
  function void build_phase(uvm_phase phase);
	env = fifo_env::type_id::create("env",this);
    uvm_resource_db#(int)::set("GLOBAL","WRITE_COUNT",`DEPTH+1,this);
    uvm_resource_db#(int)::set("GLOBAL","READ_COUNT",0,this);
endfunction
  
  task run_phase(uvm_phase phase);
    write_seq write_seq_i;
    write_seq::type_id::create("write_seq_i");
   
    
    phase.raise_objection(this);
    phase.phase_done.set_drain_time(this,100);
   		write_seq_i.start(env.write_agent_i.sqr);
    phase.drop_objection(this);
    
  endtask
endclass

class fifo_read_error_test extends wr_rd_fifo_test;
`uvm_component_utils(fifo_read_error_test)
`NEW_COMP
  
  function void build_phase(uvm_phase phase);
	env = fifo_env::type_id::create("env",this);
    uvm_resource_db#(int)::set("GLOBAL","WRITE_COUNT",`DEPTH,this);
    uvm_resource_db#(int)::set("GLOBAL","READ_COUNT",`DEPTH+1,this);	
endfunction
  
endclass

class concurrent_write_read_test extends wr_rd_fifo_test;
`uvm_component_utils(concurrent_write_read_test)
`NEW_COMP
  
  function void build_phase(uvm_phase phase);
	env = fifo_env::type_id::create("env",this);
    uvm_resource_db#(int)::set("GLOBAL","WRITE_COUNT",200,this);
    uvm_resource_db#(int)::set("GLOBAL","READ_COUNT",200,this);	
endfunction
  
   task run_phase(uvm_phase phase);
    write_delay_seq write_seq_i;
    read_delay_seq read_seq_i;
    write_seq_i = write_delay_seq::type_id::create("write_seq_i");
    read_seq_i = read_delay_seq::type_id::create("read_seq_i");
    
    phase.raise_objection(this);
    phase.phase_done.set_drain_time(this,100);
     fork
   		write_seq_i.start(env.write_agent_i.sqr);
    	read_seq_i.start(env.read_agent_i.sqr);
     join
    phase.drop_objection(this);
    
  endtask
endclass


class virtual_sqr_wr_rd_fifo_test extends fifo_base_test;
`uvm_component_utils(virtual_sqr_wr_rd_fifo_test )
`NEW_COMP
  
  function void build_phase(uvm_phase phase);
	env = fifo_env::type_id::create("env",this);
    uvm_resource_db#(int)::set("GLOBAL","WRITE_COUNT",`DEPTH,this);
    uvm_resource_db#(int)::set("GLOBAL","READ_COUNT",`DEPTH,this);
endfunction
  
  task run_phase(uvm_phase phase);
    wr_rd_virtual_seq virtual_seq;
    virtual_seq = wr_rd_virtual_seq::type_id::create("virtual_seq");
    
    phase.raise_objection(this);
    phase.phase_done.set_drain_time(this,100);
   		virtual_seq.start(env.virtual_sqr_i);
    phase.drop_objection(this);
    
  endtask
endclass





