/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Encoder                                                 //
//   Data Character Block                                          //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2014-2023 ROA Logic BV                //
//             www.roalogic.com                                    //
//                                                                 //
//   This source file may be used and distributed without          //
//   restriction provided that this copyright statement is not     //
//   removed from the file and that any derivative work contains   //
//   the original copyright notice and the associated disclaimer.  //
//                                                                 //
//      THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY        //
//   EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED     //
//   TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS     //
//   FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR OR     //
//   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,  //
//   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT  //
//   NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;  //
//   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)      //
//   HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     //
//   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR  //
//   OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS          //
//   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  //
//                                                                 //
/////////////////////////////////////////////////////////////////////

// +FHDR -  Semiconductor Reuse Standard File Header Section  -------
// FILE NAME      : e8b10b_d.sv
// DEPARTMENT     :
// AUTHOR         : rherveille
// AUTHOR'S EMAIL :
// ------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE        AUTHOR      DESCRIPTION
// 1.0     20-12-2014  rherveille  initial release
// ------------------------------------------------------------------
// KEYWORDS : 8b10b encoder
// ------------------------------------------------------------------
// PURPOSE  : 8b10b Encoder Data Character - Stage 2
// ------------------------------------------------------------------
// PARAMETERS
//  NONE
// ------------------------------------------------------------------
// REUSE ISSUES 
//   Reset Strategy      : external asynchronous active low; rstn_i
//   Clock Domains       : 1, clk_i, rising edge
//   Critical Timing     : 
//   Test Features       : na
//   Asynchronous I/F    : no
//   Scan Methodology    : na
//   Instantiations      : na 
//   Synthesizable (y/n) : Yes
//   Other               :                                         
// -FHDR-------------------------------------------------------------


`pragma protect begin

module e8b10b_d (
  input            clk_i,
  input            rstn_i,
  input      [7:0] d_i,

  output reg [5:0] d6_o,
  output reg [3:0] d4_o
);


// generate Dfghj values (assume negative disparity)
always @(posedge clk_i, negedge rstn_i)
  if (!rstn_i)
    d4_o <= 4'b0010;
  else
  (* synthesis, parallel_case *)
  case (d_i[7:5])
    4'd0: d4_o <= 4'b0010;
    4'd1: d4_o <= 4'b1001;
    4'd2: d4_o <= 4'b1010;
    4'd3: d4_o <= 4'b1100;
    4'd4: d4_o <= 4'b0100;
    4'd5: d4_o <= 4'b0101;
    4'd6: d4_o <= 4'b0110;
    4'd7: d4_o <= 4'b1000;
  endcase

// generate Dabcdei values (assume negative disparity)
always @(posedge clk_i,negedge rstn_i)
  if (!rstn_i)
    d6_o <= 6'b111001;
  else
  (* synthesis, parallel_case *)
  case (d_i[4:0])
    5'd0:  d6_o <= 6'b111001;
    5'd1:  d6_o <= 6'b101110;
    5'd2:  d6_o <= 6'b101101;
    5'd3:  d6_o <= 6'b100011;
    5'd4:  d6_o <= 6'b101011;
    5'd5:  d6_o <= 6'b100101;
    5'd6:  d6_o <= 6'b100110;
    5'd7:  d6_o <= 6'b000111;
    5'd8:  d6_o <= 6'b100111;
    5'd9:  d6_o <= 6'b101001;
    5'd10: d6_o <= 6'b101010;
    5'd11: d6_o <= 6'b001011;
    5'd12: d6_o <= 6'b101100;
    5'd13: d6_o <= 6'b001101;
    5'd14: d6_o <= 6'b001110;
    5'd15: d6_o <= 6'b111010;
    5'd16: d6_o <= 6'b110110;
    5'd17: d6_o <= 6'b110001;
    5'd18: d6_o <= 6'b110010;
    5'd19: d6_o <= 6'b010011;
    5'd20: d6_o <= 6'b110100;
    5'd21: d6_o <= 6'b010101;
    5'd22: d6_o <= 6'b010110;
    5'd23: d6_o <= 6'b010111;
    5'd24: d6_o <= 6'b110011;
    5'd25: d6_o <= 6'b011001;
    5'd26: d6_o <= 6'b011010;
    5'd27: d6_o <= 6'b011011;
    5'd28: d6_o <= 6'b011100;
    5'd29: d6_o <= 6'b011101;
    5'd30: d6_o <= 6'b011110;
    5'd31: d6_o <= 6'b110101;
  endcase

endmodule

`pragma protect end

