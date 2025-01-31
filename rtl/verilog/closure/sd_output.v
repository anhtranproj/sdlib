//----------------------------------------------------------------------
// Srdy/Drdy output block
//
// Halts timing on all signals except ic_drdy
// ic_drdy is a combinatorial path from p_drdy
//
// Naming convention: c = consumer, p = producer, i = internal interface
//----------------------------------------------------------------------
// Author: Guy Hutchison
//----------------------------------------------------------------------
//
// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.
//
// In jurisdictions that recognize copyright laws, the author or authors
// of this software dedicate any and all copyright interest in the
// software to the public domain. We make this dedication for the benefit
// of the public at large and to the detriment of our heirs and
// successors. We intend this dedication to be an overt act of
// relinquishment in perpetuity of all present and future rights to this
// software under copyright law.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
// OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// For more information, please refer to <http://unlicense.org/> 
//----------------------------------------------------------------------

// Clocking statement for synchronous blocks.
`ifndef SDLIB_CLOCKING 
 `define SDLIB_CLOCKING posedge clk
`endif

// delay unit for nonblocking assigns, default is to #1
`ifndef SDLIB_DELAY 
 `define SDLIB_DELAY 
`endif

module sd_output
  #(parameter width = 8)
  (
   input              clk,
   input              reset,
   input              ic_srdy,
   output reg         ic_drdy,
   input [width-1:0]  ic_data,

   output reg         p_srdy,
   input              p_drdy,
   output reg [width-1:0] p_data
   );

//   reg      load;   // true when data will be loaded into p_data
//   reg      nxt_p_srdy;
// 
//   always @*
//     begin
//       ic_drdy = p_drdy | !p_srdy;
//       load  = ic_srdy & ic_drdy;
//       nxt_p_srdy = load | (p_srdy & !p_drdy);
//     end
//   
//   always @(`SDLIB_CLOCKING)
//     begin
//       if (reset)
//  begin
//    p_srdy <= `SDLIB_DELAY 0;
//  end
//       else
//  begin
//    p_srdy <= `SDLIB_DELAY nxt_p_srdy;
//  end // else: !if(reset)
//     end // always @ (posedge clk)
// 
//   always @(posedge clk)
//     if (load)
//       p_data <= `SDLIB_DELAY ic_data;

    //====== Rewritten by Anh Tran (Andrew)
    assign ic_drdy = ~p_srdy | p_drdy;
    
    always @(posedge clk) begin
        if (reset) 
            p_srdy <= 1'b0;
        else if (ic_srdy)
            p_srdy <= 1'b1;
        else if (ic_drdy)
            p_srdy <= 1'b0;
    end

    always @(posedge clk) begin
        if (ic_srdy & ic_drdy)
            p_data <= ic_data;
    end

endmodule // it_output
