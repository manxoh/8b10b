/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Encoder                                                 //
//   Combine Block                                                 //
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
// FILE NAME      : e8b10b_comb.sv
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
// PURPOSE  : 8b10b Encoder Combine - Stage 3
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

module e8b10b_comb (
  input        clk_i,
  input        rstn_i,
  input        ena_i,
  input  [5:0] d6_i,
  input  [3:0] d4_i,
  input  [5:0] k6_i,
  input  [3:0] k4_i,
  input        k_i,
  input        kerr_i,
  input        d6_alt_i,
  input        d4_alt_i,
  input        d4_invrd_i,
  input        dflip_i,
  input        kflip_i,
  input        sc_nrd_i,
  input        sc_prd_i,
  input        rd_i,
  input        rdf_i,

  output reg [9:0] d_o,
  output reg       kerr_o,
  output           rdcasc_o,
  output reg       rd_o
);

// generate Running Disparity
always @(posedge clk_i, negedge rstn_i)
  if      (!rstn_i) rd_o <= 1'b0; //negative running disparity
  else if ( ena_i ) rd_o <= rdcasc_o;

wire   rdi      = (rdf_i ? rd_i : rd_o);
assign rdcasc_o = rdi ^ (k_i ? kerr_i | kflip_i : dflip_i);

// generate kerr
always @(posedge clk_i)
  kerr_o <= k_i & kerr_i;

// generate b6 output
wire [5:0] b6 = k_i ? (kerr_i ? 6'b111100 : k6_i) : d6_i;
wire b6_inv = rdi & (k_i | d6_alt_i);

// generate b4 output
reg [3:0] b4;
always @(k_i or kerr_i or k4_i or rdi or sc_prd_i or sc_nrd_i or d4_i)
  if      ( k_i           ) b4 = kerr_i ? 4'b0101 : k4_i;
  else if ( rdi & sc_prd_i) b4 = 4'b0001;
  else if (~rdi & sc_nrd_i) b4 = 4'b0001;
  else                      b4 = d4_i;

wire b4_inv = k_i ? rdi : d4_alt_i & ~(rdi ^ d4_invrd_i);

// generate data output
always @(posedge clk_i,negedge rstn_i)
  if (!rstn_i) d_o <= 10'h0;
  else         d_o <= {b4 ^ {4{b4_inv}}, b6 ^ {6{b6_inv}}};
endmodule

`pragma protect end
