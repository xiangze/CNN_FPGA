module filter_n2_{{nn1}}_{{nn2}}(
		 input 			       clk,
		 input 			       resetn,
		 input 			       clip,
		 input 			       relu,
		 input [7:0] 		       relu_c,
		 {% for m in n2 %}       {% for k in n1 %}
	         {% for i in fn %} {% for j in fn %}
		 input signed [{{width-1}}:0]  w{{m}}_{{k}}_{{j}}_{{i}},
 	         {%- endfor %} {%- endfor %}
 		 input signed [{{width-1}}:0]  b{{m}}_{{k}};
 		 {%- endfor %} {%- endfor %}

		 {% for k in n1 %}
		 {% for i in fn %} {% for j in fn %}
		 input signed [{{width-1}}:0] x{{k}}_{{j}}_{{i}},
		 {%- endfor %} {%- endfor %}
		 {%- endfor %}
		 
		 {% for k in n2 %} 
		 output signed [{{width-1}}:0] out{{k}}
		 {%- endfor %}
		 );
   
   {% for m in n2 %}
     filter_n1_{{nn1}} filter_n1_{{m}}(
			       .clk(clk), .resetn(resetn),.clip(clip),
			       {% for k in n1 %}			       
  			       {% for i in fn %} {% for j in fn %}
			       .w_{{k}}_{{j}}_{{i}}(w{{m}}_{{k}}_{{j}}_{{i}}[{{width-1}}:0]),
			       .x_{{k}}_{{j}}_{{i}}(x{{k}}_{{j}}_{{i}}[{{width-1}}:0]),
			       {%- endfor %} {%- endfor %}
			       .b{{k}}(b{{m}}_{{k}}),	       
			       {%- endfor %}
			       .out(out{{m}}[{{width-1}}:0]),
			       .relu(relu),.relu_c(relu_c[7:0])
			       );
   {%- endfor %}
     
endmodule