module filter_n2_line(
		 input 			       clk,
		 input 			       resetn,
		 input 			       clip,
		 input 			       relu,
		 input [7:0] 		       relu_c,
		 {% for m in n2 %}       {% for k in n1 %}
	         {% for i in fn %} {% for j in fn %}
		 input signed [{{width-1}}:0]  w{{m}}_{{k}}_{{j}}_{{i}},
 	         {% endfor %} {% endfor %}
 		 input signed [{{width-1}}:0]  b{{m}}_{{k}};
 		 {% endfor %} {% endfor %}

		 {% for k in n1 %}
		 input signed [{{width-1}}:0] x{{k}},
		 {% endfor %}
		 
		 {% for k in n2 %} 
		 output signed [{{width-1}}:0] out{{k}}
		 {% endfor %}
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
     
   {% for m in n2 %}
   {% for k in fn %}      
     wire [9:0] 			     xin{{m}}_{{k}};
     wire [9:0] 			     xout{{m}}_{{k}};
   {% if k==0 %}
     assign  xin{{m}}_{{k}=x{{m}};
   {% else %}
     assign  xin{{m}}_{{k}}=out{{m}}_{{k-1}};
   {% endif %}    
     linebuffer l{{m}}_{{k}}(
  	         .clk(clk), .resetn(resetn),
		 .out		(xout{{m}}_{{k}}[9:0]),
		 .ren		(ren),
		 .wen		(en),
		 .waddr		(waddr[10:0]),
		 .raddr		(raddr[10:0]),
		 .in		(xin{{m}}_{{k}}[9:0]));
   {% endfor %}
   {% endfor %}

   {% for m in n2 %}
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

   filter_n2(
	     .clk(clk), .resetn(resetn),.clip(clip),
	     {% for m in n2 %} {% for k in n1 %}			       
	     {% for i in fn %} {% for j in fn %}
	     .w{{m}}_{{k}}_{{j}}_{{i}}(w{{m}}_{{k}}_{{j}}_{{i}}[{{width-1}}:0]),
     	     {% endfor %} {% endfor %}	     
	     .b{{m}}_{{k}}(b{{m}}_{{k}}[{{width-1}}:0]  ),
	     {% endfor %} {% endfor %}
	     {% for k in n1 %}			       
	     .x{{k}}_{{j}}_{{i}}(),    
	     {% endfor %}
	     .relu(relu),.relu_c(relu_c[7:0])
	     );

   {% endfor %}
endmodule