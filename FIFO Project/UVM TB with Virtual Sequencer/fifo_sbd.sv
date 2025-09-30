`uvm_analysis_imp_decl(_write) //UVM creates a class called uvm_analysis_imp_write and write_write method
`uvm_analysis_imp_decl(_read)  //UVM creates a class called uvm_analysis_imp_read and write_read method

class fifo_sbd extends uvm_scoreboard; //No parameters as it is many to one.
  
  uvm_analysis_imp_write#(wr_tx, fifo_sbd) imp_write;
  uvm_analysis_imp_read#(rd_tx, fifo_sbd) imp_read;
  wr_tx write_txQ[$];
  rd_tx read_txQ[$];
  wr_tx write_tx_i;
  rd_tx read_tx_i;
  
  `uvm_component_utils(fifo_sbd)
  `NEW_COMP
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    imp_write = new("imp_write",this);
    imp_read = new("imp_read", this);
  endfunction
  
  
  function void write_write(wr_tx tx);
    //Getting wr_tx from write_mon and storing in write queue
    $display("%t : Storing %h in write_txQ", $time, tx.data);
    write_txQ.push_back(tx);
  endfunction
  
  function void write_read(rd_tx tx);//Getting rd_tx from read_mon and storing in read queue
    $display("%t : Storing %h in read_txQ", $time, tx.data);
    read_txQ.push_back(tx);
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      wait(write_txQ.size() > 0 && read_txQ.size() > 0);
      write_tx_i = write_txQ.pop_front();
      read_tx_i = read_txQ.pop_front();
      if (write_tx_i.data == read_tx_i.data)begin
        fifo_common::num_matches++;
      end
      else begin
        fifo_common::num_mismatches++;
      end
    end
  endtask
 
  
endclass
