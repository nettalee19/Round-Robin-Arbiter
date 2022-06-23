class s_monitor extends uvm_monitor;
   `uvm_component_utils(s_monitor)

   uvm_analysis_port#(r_transaction) mon_ap_actual;
     bit [15:0] timeout_limit = ({16{1'b1}} -1) ;
  int counter = 0;


   virtual s_interface sinf;

   function new(string name, uvm_component parent);
	super.new(name, parent);
   endfunction

   function void build_phase(uvm_phase phase);
	super.build_phase(phase);
     	uvm_config_db#(virtual s_interface)::get(this, "" , "s_interface" , sinf);
	mon_ap_actual = new("mon_ap_expected" , this);
   endfunction
  
   task run_phase(uvm_phase phase);
      r_transaction r_tran;
      r_tran = r_transaction::type_id::create("r_tran" , this);
      
      forever begin
        @(posedge sinf.clk) begin

		
	fork : mon_fork
	  begin	
	    wait(sinf.ack_bus);


		r_tran.data_bus_rd  = sinf.data_bus_rd;
		r_tran.rd          = sinf.rd_bus;
		r_tran.wr	   = sinf.wr_bus;
		r_tran.addr	   = sinf.add_bus;
		r_tran.be	   = sinf.byte_en;
		r_tran.dwr	   = sinf.data_bus_wr;
		r_tran.cpu	   = sinf.cpu_out;
		r_tran.ack[0]	= sinf.ack_bus;
		r_tran.ack[1]	= 0;
		`uvm_info("s_monitor", r_tran.sprint(), UVM_MEDIUM);

		disable mon_fork;

    	  end
	
	   begin	
	    while(counter < timeout_limit)begin
		@(posedge sinf.clk);
		counter = counter + 1;
	     end
		//$display("------ counter---- %d" , counter);

		if(counter == timeout_limit)begin
		r_tran.data_bus_rd  = sinf.data_bus_rd;
		r_tran.rd          = sinf.rd_bus;
		r_tran.wr	   = sinf.wr_bus;
		r_tran.addr	   = sinf.add_bus;
		r_tran.be	   = sinf.byte_en;
		r_tran.dwr	   = sinf.data_bus_wr;
		r_tran.cpu	   = sinf.cpu_out;
		r_tran.ack[0]	= 1;
		r_tran.ack[1]	= 1;
		`uvm_info("s_to_monitor", r_tran.sprint(), UVM_LOW);

	  end
	  
	  disable mon_fork;
	end
   
join_any

         
	`uvm_info("mon_ss" , $sformatf(" %h dta_rd   %h addr %d counter" ,sinf.data_bus_rd , sinf.add_bus, counter) , UVM_MEDIUM)
	 counter = 0;


		//Send the transaction to the analysis port
            	//`uvm_info(" ", $sformatf("Monitor Actual enable=%d, a=%d, b=%d,sum=%d", mon_inf.enable, mon_inf.a, mon_inf.b, mon_inf.sum), UVM_MEDIUM)
		mon_ap_actual.write(r_tran);
	   // end
	end
      end
   endtask

endclass

