class h_agent extends uvm_agent;
  `uvm_component_utils(h_agent)

   uvm_analysis_port#(r_transaction) agent_ap_expected;

   r_sequencer		seqer;
   r_driver		drv;
   h_monitor	h_mon_expected;

   function new(string name, uvm_component parent);
	super.new(name, parent);
   endfunction
  
 function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent_ap_expected = new("agent_ap_expected" , this);
	seqer	= r_sequencer::type_id::create($sformatf("%s.seqer",get_name() ), this); 
        drv		= r_driver::type_id::create("drv" , this);
        h_mon_expected = h_monitor::type_id::create("h_mon_expected" , this);
   endfunction

   function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqer.seq_item_export);
        h_mon_expected.mon_ap_expected.connect(agent_ap_expected);
   endfunction
endclass

