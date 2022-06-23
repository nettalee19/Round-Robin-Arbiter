class s_agent extends uvm_agent;
  `uvm_component_utils(s_agent)

   uvm_analysis_port#(r_transaction) agent_ap_actual;

   s_driver drv;
   s_monitor   s_mon_actual;

   function new(string name, uvm_component parent);
	super.new(name, parent);
   endfunction

  function void build_phase(uvm_phase phase);
        super.build_phase(phase);
	drv		= s_driver::type_id::create("drv" , this);
        agent_ap_actual = new("agent_ap_actual" , this);
        s_mon_actual = s_monitor::type_id::create("s_mon_actual" , this);
   endfunction

   function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        s_mon_actual.mon_ap_actual.connect(agent_ap_actual);
   endfunction

endclass


