module FIFO#(
    parameter DATA_WIDTH =8,  // size of each word
    parameter DEPTH = 16      // number of storage location
    )
    (
    input clk,
    input rst,
    input wr,
    input rd,
    input [DATA_WIDTH-1:0]din, // input data to be written
    output reg [DATA_WIDTH-1:0] dout, // output read data
    output empty,// FIFO has no data
    output full // FIFO cannot accept new data
    );

    reg [$clog2(DEPTH)-1:0] wptr =0,rptr=0;  // determines how many bits are needed to address memory
    // wptr -> points to next memory location to write
    // rptr-> points to next location to read

    reg [$clog2(DEPTH+1)-1:0] cnt=0;

    reg [DATA_WIDTH-1:0] mem [DEPTH-1:0]; // FIFO STORAGE ARRAY
    // width = 8 and 16 locations

    always @ (posedge clk)
    begin
    if(rst)begin
    wptr <= 0;
    rptr <= 0;
    cnt  <= 0;
    end

     if (wr && !full)
    begin

    mem[wptr] <=din;

    wptr <= (wptr+1) % DEPTH;
    end

     if (rd &&!empty)
    begin
    dout <= mem [rptr];
    rptr <= (rptr + 1)  % DEPTH;

    end
    case ( {wr && !full , rd && !empty})
    2'b10: cnt <= cnt + 1;
    2'b01: cnt <= cnt -1;
    default: cnt <= cnt;
    endcase
    end

    assign empty = (cnt==0);
    assign full = (cnt == DEPTH);
endmodule
interface fifo_if #(parameter DATA_WIDTH = 8,parameter DEPTH =16)();
    logic clock ,rd,wr,rst;
    logic full,empty;
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;
endinterface