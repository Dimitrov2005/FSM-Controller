class Transaction extends uvm_sequence_item;
   `uvm_object_utils(Transaction);

   rand bit x1;
   rand bit x2;
   
   bit cs;
   constraint not_equal {x1!=x2 ;}

     function new(string name="");
	super.new(name);
     endfunction // new
      
     
endclass // Transaction

