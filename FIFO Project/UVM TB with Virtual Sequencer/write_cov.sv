class write_cov extends uvm_subscriber#(wr_tx);
  wr_tx tx;
  `uvm_component_utils(write_cov)
  
  covergroup wr_cg;
    WR_DELAY_CP : coverpoint tx.write_delay {
      bins ZERO = {0};
      bins LOWER = {[1:3]};
      bins MEDIUM = {[4:6]};
      bins HIGHER = {[7:`MAX_WR_DELAY]};
      
    }
  endgroup
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    wr_cg=new();
  endfunction
  
  function void write(wr_tx t);
    $cast(tx, t);
    wr_cg.sample();
  endfunction
endclass
