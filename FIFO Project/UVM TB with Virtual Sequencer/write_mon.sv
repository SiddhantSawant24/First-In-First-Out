class write_mon extends uvm_monitor;
  `uvm_component_utils(write_mon)
  virtual fifo_intf vif;
  wr_tx tx;
  uvm_analysis_port#(wr_tx) ap_port;
  `NEW_COMP
  
  function void build_phase(uvm_phase phase);
		super.build_phase(phase);
    if(!uvm_resource_db#(virtual fifo_intf)::read_by_name("GLOBAL","PIF", vif, this))
       begin
         `uvm_error("INTF","Not able to get fifo_intf from resource db")
       end
    ap_port=new("ap_port",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      @(vif.write_mon_cb);
      if(vif.write_mon_cb.wr_en_i==1)begin
        tx=wr_tx::type_id::create("tx");
        tx.data=vif.write_mon_cb.wdata_i;
        ap_port.write(tx);
      end
    end
  endtask
endclass
