class read_drv extends uvm_driver#(rd_tx);
  virtual fifo_intf vif;
  uvm_analysis_port#(rd_tx) ap_port;
  `uvm_component_utils(read_drv)
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
    wait (vif.clr_i == 0);
    forever begin
      seq_item_port.get_next_item(req);
      ap_port.write(req);
      drive_tx(req);
      seq_item_port.item_done();
    end
  endtask
  
  task drive_tx(rd_tx tx);
    @(posedge vif.rd_clk_i);
    vif.rd_en_i=1;
    
    @(posedge vif.rd_clk_i);
    tx.data=vif.rdata_o;
    vif.rd_en_i=0;
    repeat(tx.delay) @(posedge vif.rd_clk_i);
  endtask
endclass

