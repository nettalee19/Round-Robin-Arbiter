class r_driver extends uvm_driver#(r_transaction);
   `uvm_component_utils(r_driver)

    virtual h_interface hinf;

   function new(string name, uvm_component parent);
	   super.new(name, parent);
   endfunction

   function void build_phase(uvm_phase phase);
	   super.build_phase(phase);
      	
	   uvm_config_db#(virtual h_interface)::get(this , "" , "h_interface", hinf);

   endfunction

   task run_phase(uvm_phase phase);
	   wait(!hinf.reset_n);
	   wait(hinf.reset_n);
	   drive();
   endtask

   virtual task drive();
       r_transaction r_tran;
     
    	 forever begin

     	        //Gets a transaction from the sequencer and stores it in the variable 'adder_tran'
            	seq_item_port.get_next_item(r_tran); 

		assert(r_tran.rd != r_tran.wr);

          	 @(posedge hinf.clk);
	               
           		hinf.rd     <= r_tran.rd;
		        hinf.wr     <= r_tran.wr;
		        hinf.addr   <= r_tran.addr;
  			hinf.dwr    <= r_tran.dwr;
  			hinf.be     <= r_tran.be;
			hinf.cpu    <= r_tran.cpu;

			wait(hinf.ack[0]); //till there is ack
				 			  	
             		//Informs the sequencer that the current operation with the transaction was finished 
			seq_item_port.item_done();
              		
			@(posedge hinf.clk);

			hinf.rd <= 1'b0;
			hinf.wr <= 1'b0;
			
	  end
   endtask
endclass
