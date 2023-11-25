/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Decoder                                                 //
//   Top Level                                                     //
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
// FILE NAME      : d8b10b_top.sv
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
// PURPOSE  : 8b10b Decoder Top Level
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
//   Instantiations      : d8b10b_b, d8b10b_err, d8b10b_disp, d8b10b_comb
//   Synthesizable (y/n) : Yes
//   Other               :                                         
// -FHDR-------------------------------------------------------------


module d8b10b_top (
  input        clk_i,
  input        rstn_i,
  input        ena_i,
  input  [9:0] d_i,
  input        rd_i,
  input        rdf_i,
  output [7:0] d_o,
  output       k_o,
  output       k28_5_o, //indicates that the NEXT character is K28.5
  output       cerr_o,
  output       rdcasc_o,
  output       rd_o,
  output       rderr_o
);

`pragma protect begin

wire [4:0] b5;
wire [2:0] b3;
wire       k;
wire       pd6c, nd6c, pd4c, nd4c;
wire       pd6e, nd6e, pd4e, nd4e;
wire       cerr, kerr, derr;

reg dena;
always @(posedge clk_i) dena <= ena_i;

// Hookup modules
//stage1
d8b10b_b d8b10b_b (
  .clk_i   ( clk_i   ),
  .rstn_i  ( rstn_i  ),
  .ena_i   ( ena_i   ),
  .d_i     ( d_i     ),
  .k_o     ( k       ),
  .k28_5_o ( k28_5_o ),
  .b3_o    ( b3      ),
  .b5_o    ( b5      )
);

d8b10b_err d8b10b_err (
  .clk_i   ( clk_i   ),
  .rstn_i  ( rstn_i  ),
  .ena_i   ( ena_i   ),
  .d_i     ( d_i     ),
  .cerr_o  ( cerr    ),
  .kerr_o  ( kerr    )
);

d8b10b_disp d8b10b_disp (
  .clk_i   ( clk_i  ),
  .rstn_i  ( rstn_i ),
  .d_i     ( d_i    ),
  .pd6c_o  ( pd6c   ),
  .nd6c_o  ( nd6c   ),
  .pd4c_o  ( pd4c   ),
  .nd4c_o  ( nd4c   ),
  .pd6e_o  ( pd6e   ),
  .nd6e_o  ( nd6e   ),
  .pd4e_o  ( pd4e   ),
  .nd4e_o  ( nd4e   )
);

//stage2
d8b10b_comb d8b10b_comb (
  .clk_i    ( clk_i    ),
  .rstn_i   ( rstn_i   ),
  .ena_i    ( dena     ),
  .k_i      ( k        ),
  .k_o      ( k_o      ),
  .b5_i     ( b5       ),
  .b3_i     ( b3       ),
  .d_o      ( d_o      ),
  .cerr_i   ( cerr     ),
  .kerr_i   ( kerr     ),
  .cerr_o   ( cerr_o   ),
  .pd6c_i   ( pd6c     ),
  .nd6c_i   ( nd6c     ),
  .pd4c_i   ( pd4c     ),
  .nd4c_i   ( nd4c     ),
  .pd6e_i   ( pd6e     ),
  .nd6e_i   ( nd6e     ),
  .pd4e_i   ( pd4e     ),
  .nd4e_i   ( nd4e     ),
  .rd_i     ( rd_i     ),
  .rdf_i    ( rdf_i    ),
  .rdcasc_o ( rdcasc_o ),
  .rd_o     ( rd_o     ),
  .rderr_o  ( rderr_o  )
);

`pragma protect end
endmodule
