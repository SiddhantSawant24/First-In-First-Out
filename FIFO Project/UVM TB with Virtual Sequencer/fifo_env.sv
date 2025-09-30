class fifo_env extends uvm_env;
	write_agent write_agent_i;
	read_agent read_agent_i;
  	fifo_sbd sbd;
	virtual_sqr virtual_sqr_i;

	`uvm_component_utils(fifo_env)
	`NEW_COMP

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		write_agent_i=write_agent::type_id::create("write_agent_i",this);
		read_agent_i=read_agent::type_id::create("read_agent_i",this);   
      		sbd=fifo_sbd::type_id::create("sbd",this);

 		virtual_sqr_i=virtual_sqr::type_id::create("virtual_sqr_i",this);

      
	endfunction
  
    function void connect_phase(uvm_phase phase);
      write_agent_i.mon.ap_port.connect(sbd.imp_write);
      read_agent_i.mon.ap_port.connect(sbd.imp_read);
      virtual_sqr_i.write_sqr_i=write_agent_i.sqr; //mapping actual signals to the virtual sequencer
      virtual_sqr_i.read_sqr_i=read_agent_i.sqr; //mapping actual signals to the virtual sequencer

    endfunction
      
      
endclass

