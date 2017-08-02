class my_test extends uvm_test;
   `uvm_component_utils(my_test)
     Environment env;
   env_config env_cfg;
   agent_config agent_cfg;
   personIn personIn_h;
   personOut personOut_h;
   randSeq randSeq_h;
   Sequence Sequence_h;
      int num=1;
      
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction // new
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      env_cfg=env_config::type_id::create("env_cfg",this);
      agent_cfg=agent_config::type_id::create("agent_cfg",this);
      
      if(!uvm_config_db#(virtual iface)::get
         (this,"","viface",agent_cfg.viface))
	begin
	 `uvm_error("TINF"," iface not found");
	end
      
	    //--------create agnt config files and assign them to env_cgf/
	    env_cfg.agent_cfg=agent_cfg;
      
	    uvm_config_db#(env_config)::set
	    (this,"*","env_cfg",env_cfg);

	    env=Environment::type_id::create("env",this);
	    
   endfunction // build_phase
	  

  task run_phase(uvm_phase phase);
      
     Sequence_h=Sequence::type_id::create("Sequence_h",this);
     phase.raise_objection(this);
    repeat(num) //default repeat num in sequence is 1, total : 1x256
      begin
	 
	   repeat(9050)begin
	      assert(Sequence_h.randomize() with {state_h dist{0:/90,
						      1:/3,
						      2:/3,
	      					      3:/4};
					  }
		)else `uvm_error("RANDENUM","Enum Rand failed");
            Sequence_h.start(env.agent.seq);
           end
         repeat(9050)
	   begin
	      assert(Sequence_h.randomize() with {state_h dist{0:/4,
						      1:/3,
						      2:/90,
	      					      3:/3};
					  }
		)else `uvm_error("RANDENUM","Enum Rand failed");
               Sequence_h.start(env.agent.seq);	
              end
     end
     phase.drop_objection(this);
   endtask


 endclass:my_test // base_test
	    