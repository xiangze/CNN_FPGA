module filter3x3(
		 input 		    clk,
		 input 		    resetn,
		 input 		    relu,
		 input [7:0] 	    relu_c,
		 
	         {% for i in fn %} {% for j in fn %}
		 input signed [9:0] w{{j}}_{{i}},
 		 {% endfor %} {% endfor %}
		 input signed [9:0] b,
	         {% for i in fn %} {% for j in fn %}		 
		 input signed [9:0] x{{j}}_{{i}},
 		 {% endfor %} {% endfor %}
		 output signed 	    reg [9:0] out
		 );

   assign 		    clip=1;
   
   {% for i in fn %}
   wire [9:0] 		      out{{i}};
   prodsum3 p0(.clk(clk), .resetn(resetn),.clip(clip),
	       {% for j in fn %}
	       .w{{j}}(w{{j}}_{{i}}[9:0]),
	       .x{{j}}(x{{j}}_{{i}}[9:0]),
	       {% endfor %}
	       .out(out{{i}}[9:0]));
   {% endfor %}

   wire [20:0] 		      no;
   wire [9:0] 		      no_clip;
   wire [17:0] 		      no_nrelu;
     
   assign no=out0+out1+out2+b;
   assign no_clip=$signed((no[20]&(!&no[19:18]))?-512:(!no[20]&|no[19:18])?512:{no[20],no[17:9]});
   assign no_nrelu=no_clip*relu_c;
   
   always@(posedge clk or negedge resetn)
     if(!resetn)
       out<=0;
     else if(relu)   
       out<=(no_clip[20]?0:no_clip)+(~no_clip[20]?0:no_nrelu[17:8]);
     else
       out<=no_clip;

endmodule
 
