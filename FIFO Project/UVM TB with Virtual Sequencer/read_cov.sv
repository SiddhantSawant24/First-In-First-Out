class read_cov extends uvm_subscriber#(rd_tx);
  rd_tx tx;
  `uvm_component_utils(read_cov)
  
  covergroup rd_cg;
    RD_DELAY_CP : coverpoint tx.delay {
      bins ZERO = {0};
      bins LOWER = {[1:3]};
      bins MEDIUM = {[4:6]};
      bins HIGHER = {[7:`MAX_RD_DELAY]};
    }
  endgroup
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    rd_cg=new();
  endfunction
  
  function void write(rd_tx t);
    $cast(tx, t);
    rd_cg.sample();
  endfunction
endclass

