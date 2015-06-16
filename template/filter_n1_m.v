module filter_n1_m_{{nn1}}_{{nm1}}(
		  input 		       clk,
		  input 		       resetn,
		  input 		       clip,
		  input 		       relu,
		  input [7:0] 		       relu_c,
  					       {% for k in m1 %}
  					       {% for i in fn %} {% for j in fn %}
		  input signed [{{width-1}}:0] w{{k}}_{{j}}_{{i}},
					       {%- endfor %} {%- endfor %} {%- endfor %}
					       {% for k in n1 %} 
					       {% for i in fn %} {% for j in fn %}
		  input signed [{{width-1}}:0] x{{k}}_{{j}}_{{i}},
					       {%- endfor %} {%- endfor %}
					       {%- endfor %}
		 
  	          {% for k in n1 %}
		  input signed [{{width-1}}:0] b{{k}};
		  {%- endfor %} 
		  output signed reg [9:0] out
		 );
   

     filter_n1_{{nm1}} filter_n1_(
			       .clk(clk), .resetn(resetn),.clip(clip),
			       {% for k in m1 %}			       
  			       {% for i in fn %} {% for j in fn %}
			       .w_{{k}}_{{j}}_{{i}}(w{{m}}_{{k}}_{{j}}_{{i}}[{{width-1}}:0]),
			       .x_{{k}}_{{j}}_{{i}}(x{{k}}_{{j}}_{{i}}[{{width-1}}:0]),
			       {%- endfor %} {%- endfor %}
			       .b{{k}}(b{{m}}_{{k}}),	       
			       {%- endfor %}
			       .out(_out[{{width-1}}:0]),
			       .relu(0),.relu_c(0)
			       );


   reg [{{width*2}}:0] no;
   wire [{{width-1}}:0] no_clip;
   wire [{{width-1+8}}:0] no_nrelu;
   
   {% counter("cnt","cnt=={{nn1/nm1}}") %}

   {{a}}
     if(!resetn)
       cnt<=0;
     else if(cnt=={{nn1/nm1}})
       cnt<=0;
     else
       cnt<=cnt+1;

   {{a}}
     if(!resetn)
       no<=0;
     else if(cnt=={{nn1/nm1}})
       no<=0;
     else
       no<=_out+no;
   
   assign no_clip=$signed((no[20]&(!&no[19:18]))?-512:(!no[20]&|no[19:18])?512:{no[20],no[17:9]});
   assign no_nrelu=no_clip*relu_c;
   
   always@(posedge clk or negedge resetn)
     if(!resetn)
       out<=0;
     else if(relu)   
       out<=(no_clip[{{width-1}}]?0:no_clip)+(~no_clip[{{width-1}}]?0:no_nrelu[{{width-1+8}}:8]);
     else if(clip)   
       out<=no_clip;
     else
       out<={no[20:11]};       

endmodule