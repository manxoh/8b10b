/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Decoder                                                 //
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
// FILE NAME      : d8b10b_comb.sv
// DEPARTMENT     :
// AUTHOR         : rherveille
// AUTHOR'S EMAIL :
// ------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE        AUTHOR      DESCRIPTION
// 1.0     20-12-2014  rherveille  initial release
// ------------------------------------------------------------------
// KEYWORDS : 8b10b decoder
// ------------------------------------------------------------------
// PURPOSE  : 8b10b Decoder Combine - Stage 2
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

module d8b10b_comb (
  input            clk_i,
  input            rstn_i,
  input            ena_i,
  input            k_i,
  output reg       k_o,
  input      [4:0] b5_i,
  input      [2:0] b3_i,
  output reg [7:0] d_o,
  input            cerr_i,
  input            kerr_i,
  output reg       cerr_o,
  input            pd6c_i, nd6c_i, pd4c_i, nd4c_i,
  input            pd6e_i, nd6e_i, pd4e_i, nd4e_i,
  input            rd_i,
  input            rdf_i,
  output           rdcasc_o,
  output reg       rd_o,
  output reg       rderr_o
);

wire rdi = rdf_i ? rd_i : rd_o;

/*
 Generate RD_CASC signals
*/
// calculate the NEXT running disparity
wire   rdm       = pd6c_i | (rdi & !nd6c_i);
assign rdcasc_o  = pd4c_i | (rdm & !nd4c_i); 

always @(posedge clk_i, negedge rstn_i)
  if      (!rstn_i) rd_o <= 1'b0;
  else if ( ena_i ) rd_o <= rdcasc_o;

/*
 generate d_o
*/
always @(posedge clk_i, negedge rstn_i)
  if      (!rstn_i) d_o <= 8'h00;
  else if ( ena_i ) d_o <= {b3_i, b5_i};

/*
 generate k_o
*/
always @(posedge clk_i, negedge rstn_i)
  if      (!rstn_i) k_o <= 1'b0;
  else if ( ena_i ) k_o <= k_i;

/*
 generate cerr_o
*/
always @(posedge clk_i, negedge rstn_i)
  if      (!rstn_i) cerr_o <= 1'b0;
  else if ( ena_i ) cerr_o <= cerr_i & kerr_i;
  
/*
 generate rderr
*/
// Check current disparity versus running disparity
always @(posedge clk_i, negedge rstn_i)
  if      (!rstn_i) rderr_o <= 1'b0;
  else if ( ena_i ) rderr_o <= (!rdi & nd6e_i) | ( rdi & pd6e_i) |
                               (!rdm & nd4e_i) | ( rdm & pd4e_i);
endmodule

`pragma protect end

