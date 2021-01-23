module master (input CPOL,input CPHA,
               input clk,input reset, //,input mode ,
                input reg [1:0] select ,
               input reg MISO ,input reg [7:0] initialize_data ,input load ,
               output reg [7:0] master_data , output reg MOSI , output reg sclk ,
               output reg cs1 ,output reg cs2 ,output reg cs3 , output reg  check1 );
reg check =1;
reg [3:0] count = 4'b0000;
////////////////////////////////////////////////////////////////////////////////////
always @(posedge sclk) 
begin
if(check1 == 1)
begin
  if (CPHA==0)
  begin
      MOSI <= master_data[0];
  end
  else
  begin
      master_data <= master_data >> 1;
      master_data[7] <= MISO;
  end
end
end
always @(negedge sclk)
begin
if (check1==1)
begin
  if (CPHA==0)
  begin
      master_data <= master_data >> 1;
      master_data[7] <= MISO;
  end
  else
  begin
      MOSI <= master_data[0];
  end
end
end
////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk or reset)
begin
////////////////////////////////////////////////////////////////////////////////////////
///////////////////////// S_Clk //////////////////////////
if (reset==1)
begin  
check=1;
check1=0;
//check2=0;
count=0;
  ///////////////////////// intialize the master ////////////////
  if(load==1)
  begin
    master_data<=initialize_data;
  end
  /*else
  begin
  master_data<=8'b00000000;
  end*/
  sclk = CPOL;
  if (CPOL== CPHA)
  begin
    check1 = 1'b1;
   // check1=1'b1; ////
  end
end
//assign sclk=(CPOL==0)?0:1;
/////////////////////////////////////////////////////////
else
begin
if (CPOL==0)
//always @ (clk)
begin
  if (check==1)
  begin
    sclk=~sclk;
    check1 <= 1'b1;
    if(sclk==0)
    begin
      count = count +1 ;
    end
  end
  if (count==8 + CPHA)
  begin
    check=0;
    //count=0;
   end
end
else
//always @ (clk)
begin
  if (check==1)
  begin
    sclk=~sclk;
    check1<=1'b1;
    if(sclk==1)
      count=count+1;
  end
  if (count==9- CPHA)
  begin
    check=0;
    //count=0;
  end
end
end
//////////////////////// Choosing the slave ///////////////
if (select==1)
begin
  cs1=0; 
  cs2=1;
  cs3=1;
end
if (select==2)
begin
  cs2=0;
  cs1=1;
  cs3=1;
end
if (select==3)
begin
  cs3=0; 
  cs1=1;
  cs2=1;
end
////////////////////////////////////////////////////////////////////////////////////////////
end
endmodule 
