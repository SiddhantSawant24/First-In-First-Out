class read_mon extends uvm_monitor;
  `uvm_component_utils(read_mon)
  virtual fifo_intf vif;
  uvm_analysis_port#(rd_tx) ap_port;
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
    rd_tx tx;
    forever begin
      @(vif.read_mon_cb);
      if(vif.rd_en_i==1)begin
        tx=rd_tx::type_id::create("tx");
        fork begin
          @(vif.read_mon_cb);
          @(vif.read_mon_cb);
        tx.data=vif.read_mon_cb.rdata_o;
        ap_port.write(tx);
        end
        join
      end
    end
  endtask
endclass
	
