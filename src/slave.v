module slave (input sclk , input CPHA , input CPOL ,input check1 ,input cs,
              input reg [7:0] init_data , input load , //input reset ,
              input MOSI , output reg [7:0] slave_data , output reg MISO);
always @*
begin
if (load==1 )//&& ~cs)
begin
#1
if (cs==0)
 slave_data=init_data;
end
end
always @ (posedge sclk )
begin
if (cs==0)
begin
if (check1==1)
  begin
    if (CPHA==0)
  begin
      MISO <= slave_data[0];
  end
  else
  begin
      slave_data <=slave_data >> 1;
      slave_data[7] <= MOSI;
  end
  end  
end
end
always @ (negedge sclk )
begin
if (cs==0)
begin
if (check1==1)
begin
  if (CPHA==0)
  begin
      slave_data <=slave_data >> 1;
      slave_data[7] <= MOSI;
  end
  else
  begin
      MISO <= slave_data[0];
  end
end
end
end
endmodule
