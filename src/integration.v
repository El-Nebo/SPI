module integration (input CPOL , input CPHA ,input  [7:0] init_master,input  reg [7:0] init_slave, input clk , input reset ,
 input mas_load , input s_load ,input [1:0] select , output [7:0] master_data , output  [7:0] slave_data_1 , 
 output  [7:0] slave_data_2,output  [7:0] slave_data_3 , output check_end);
wire MISO ;
wire MISO1,MISO2,MISO3;
wire MOSI;
wire check;
wire sclk;
wire cs1 , cs2 , cs3;
master mas (CPOL , CPHA , clk , reset , select , MISO ,init_master ,mas_load,master_data,MOSI,sclk,cs1 , cs2 , cs3,check );
slave s1(sclk,CPHA,CPOL,check,cs1 ,init_slave , s_load , MOSI ,slave_data_1 ,MISO1);
slave s2(sclk,CPHA,CPOL,check,cs2 ,init_slave , s_load , MOSI ,slave_data_2 ,MISO2);
slave s3(sclk,CPHA,CPOL,check,cs3 ,init_slave , s_load , MOSI ,slave_data_3 ,MISO3);  
assign MISO = 	(cs1==0)?MISO1:
		(cs2==0)?MISO2:
		(cs3==0)?MISO3:1'b0;
endmodule
