module lamp(output reg cs,input x1,x2,clk,rst);
   bit [7:0]count;
   parameter     s1=3'b001,
		 s2=3'b010,
		 s3=3'b100;

   reg [2:0] state;
   reg [2:0] next;

   always@(posedge clk or posedge rst)
     begin
	if(rst) 
	  state<=3'b001; 
	else
	  state<=next;
     end
   
   always @(x1 or x2 or state)
     begin
	next=3'b001;
	case(state)
	  
	  s1: if(x1) next=s2;
	  else if(x2) next=s3;
	  else next=s1;

	  s2: if(x1) next=s1;
	  else if(x2) 
	    begin
	       next=s1;
	    end
	  else next =s2;
	  
	  s3: if(x2) next=s1;
	  else if(x1) 
	    begin 
	       next=s1;
	      
	    end
	  else next =s3;
	  
	  default : state=3'b001;
	endcase // case (state)
     end // always @ (state or x1 or x2)

   always @(posedge clk or posedge rst)
     begin
	if(rst) 
	  begin
	  count<=8'b00000000;
	     cs<=1'b0;
	  end
	
	else
	  begin 
	     case(state)
	       s2: if(next==s1 && x2 )
		count= count==255 ? count:count+1;
	       s3:
		 if(x1 && next ==s1)
		    count = count==0 ? count:count-1;
	     endcase // case (state)
	     
	     if(count)
	       cs<=1'b1;
	     else
	       cs<=1'b0;	  
	  end  
     end // always @ (posedge clk or posedge rst)
  
// always @(posedge clk)
     
endmodule // lamp


/*
 module test_lamp();
   wire cs;
   reg 	x1,x2,clk,rst;
   lamp l1(cs,x1,x2,clk,rst);

   always #5 clk=~clk;
   
   initial
     begin
	clk=0;rst=0;
	#10 rst=1;
	#11 rst=0;
	x1=1;
	x2=0;
	#13 x2=1;x1=0;
	#20 x2=0;
	#100 $finish();
     end // initial begin
 
endmodule // test_lamp
*/