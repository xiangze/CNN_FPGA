module filter3_lb(
		 input 		     clk,
		 input 		     resetn,
		 input 		     relu,
		 input 		     en,
  		 {% for i in fn %}  		 {% for j in fn %}		  
		 input signed [9:0]  w{{i}}_{{j}},
		 {% endfor %}		 {% endfor %}
		 input signed [9:0]  b,
		 input signed [9:0]  xin,
		 output signed [9:0] out
		  );
   
   reg ren;
   {{reg}}
     if(!resetn)
       ren<=0;
     else
       ren<=en;

   reg [10:0] waddr;
   reg [10:0] raddr;
    
   {{reg}}
     if(!resetn)
	waddr<=0;
     else if(!en)   
	waddr<=0;
     else
	waddr<=waddr+1;

   {{reg}}
     if(!resetn)
	raddr<=0;
     else if(!ren)   
	raddr<=0;
     else
	raddr<=raddr+1;
     
   {% for k in fn %}      
     wire [9:0] 			     xin{{k}};
     wire [9:0] 			     xout{{k}};
   {% if k==0 %}
     assign  xin{{k}}=xin;
   {% else %}
     assign  xin{{k}}=out{{k-1}};
   {% endif %}    

     linebuffer l{{k}}(
  	         .clk(clk), .resetn(resetn),
		 .out		(xout{{k}}[9:0]),
		 .ren		(ren),
		 .wen		(en),
		 .waddr		(waddr[10:0]),
		 .raddr		(raddr[10:0]),
		 .in		(xin{{k}}[9:0]));
   {% endfor %}

   {% for i in fn %} {% for j in fn %}
     reg [9:0]      x_{{i}}_{{j}};
   {{reg}}
     if(!resetn)
       x_{{i}}_{{j}}<=0;
     else
       {%- if j==0 -%}
       x_{{i}}_{{j}}<=xout{{i}};
       {%- else -%}
       x_{{i}}_{{j}}<=x_{{i}}_{{j-1}};
       {%- endif -%}
   {% endfor %}	 {% endfor %}
     
   filter3x3 filter(
		    // Outputs
		    .clk		(clk),.resetn(resetn),
		    .relu		(relu),
  		    {% for i in fn %}	 {% for j in fn %}		  		    
		    .w{{i}}_{{j}}	(w{{i}}_{{j}}[9:0]),
		    {% endfor %}	 {% endfor %}		    
		    .b			(b[9:0]),
  		    {% for i in fn %}	 {% for j in fn %}
		    .x{{i}}_{{j}}	(x{{i}}_{{j}}[9:0]),
		    {% endfor %}	 {% endfor %}		    
		    .out		(out[9:0]));
endmodule