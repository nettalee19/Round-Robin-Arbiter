class h_monitor extends uvm_monitor;
   `uvm_component_utils(h_monitor)

   uvm_analysis_port#(r_transaction) mon_ap_expected;

   virtual h_interface hinf;

   r_transaction r_tran;
	
   //For coverage
   r_transaction r_tran_cov;
   //Define coverpoints
   /*covergroup arbiter_cov;
   	rd_cp:     coverpoint r_tran_cov.rd;
  	wr_cp:     coverpoint r_tran_cov.wr;
	cross rd_cp, wr_cp;
   endgroup*/
  
   function new(string name, uvm_component parent);
	super.new(name, parent);
	//adder_cov = new;
   endfunction

   function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db#(virtual h_interface)::get(this , "" , "h_interface" , hinf);
	mon_ap_expected= new("mon_ap_expected" , this);
   endfunction
  
   task run_phase(uvm_phase phase);
     r_tran = r_transaction::type_id::create("r_tran", this);

	forever begin
         // @(posedge hinf.clk);
	 // wait(hinf.reset_n == 1'b1)
          @(posedge hinf.clk);
	  wait(hinf.ack[0]);
		r_tran.rd = hinf.rd;
		r_tran.wr = hinf.wr;
		r_tran.addr = hinf.addr;
		r_tran.be = hinf.be;
		r_tran.dwr = hinf.dwr;
		r_tran.cpu =hinf.cpu;
		r_tran.data_bus_rd = hinf.drd;
		r_tran.ack[0]	= hinf.ack[0];
		r_tran.ack[1]	=  hinf.ack[1];
		`uvm_info("h_monitor", r_tran.sprint(), UVM_LOW);


		`uvm_info("monhh" , $sformatf(" %h drd  %h addr " ,hinf.drd , hinf.addr) , UVM_MEDIUM)
	


	    	//Coverage
	    	/*r_tran_cov = r_tran;
	    	r_cov.sample();*/
	    /*	//Send the transaction to the analysis port
          	`uvm_info(" ", $sformatf("Monitor Expected enable=%d, a=%d, b=%d,sum=%d", mon_inf.enable, mon_inf.a, mon_inf.b, mon_inf.sum), UVM_MEDIUM)*/
	    	mon_ap_expected.write(r_tran);
  		 @(posedge hinf.clk);


            
	  
	end
   endtask
endclass

