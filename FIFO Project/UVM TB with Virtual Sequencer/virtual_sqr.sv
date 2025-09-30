class virtual_sqr extends uvm_sequencer; //It will have the handles of all the sequencers.....it will act as the admin who schedules allthe classes by connecting to the trainer and monitors which class is going on and at what time. Here basically the virtual sequencer will handle when to write and when to read....in normal sequencer first we do write and then read
	write_sqr write_sqr_i;
	read_sqr read_sqr_i;

 	`uvm_component_utils(virtual_sqr)
  	`NEW_COMP
	
endclass
