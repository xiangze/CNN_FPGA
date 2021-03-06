# CNN_FPGA
## verilog CNN generator for FPGA

feature
------
multilayor 2D-parallel FMAC is exected in one operation

requirement
------
* python 2.7.* or 3.6 jinja2
* Altera Quartus 13(recommended)/
* Xilinx Vivado 19.2(or lator)

Basic concepts of design
------
https://github.com/xiangze/CNN_FPGASoC_report/blob/master/FPGA%20SoC%E3%82%92%E7%94%A8%E3%81%84%E3%81%A6CNN%E6%BC%94%E7%AE%97.ipynb
(in japanese)

## ToDo
------

### must
* [ ] fixpoint parameter converter
* [ ] state machine
* [ ] memory(DRAM) contoroller (Qsys or Vivado)
* [ ] maxpooling

## want
* [ ] converter from t7 file
* [ ] learning function/back propagation
* [ ] soft activation functions/sigmoid,tanh
* [ ] RNN
* [ ] LSTM
* [ ] attention
* [ ] weight parameter compression/decompression(quantize/dequantize) by ARM 
* [ ] weight distiltion by ARM 
* [ ] other numarical/mathematical problems
