/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Encoder                                                 //
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
// FILE NAME      : e8b10b_top.sv
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
// PURPOSE  : 8b10b Encoder Top Level
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
//   Instantiations      : e8b10b_p, e8b10b_k, e8b10b_d, e8b10b_ctrl,
//                         e8b10b_comb
//   Synthesizable (y/n) : Yes
//   Other               :                                         
// -FHDR-------------------------------------------------------------


module e8b10b_top (
  input        clk_i,
  input        rstn_i,
  input        ena_i,
  input  [7:0] d_i,
  input        k_i,
  input        rd_i,
  input        rdf_i,
  output [9:0] d_o,
  output       kerr_o,
  output       rdcasc_o,
  output       rd_o
);
`pragma protect begin

wire       k2, k3, kerr, kflip, ena3;
wire [7:0] d2;
wire [5:0] k6, d6;
wire [3:0] k4, d4;
wire       d4_alt, d6_alt, d4_invrd;
wire       dflip, sc_nrd, sc_prd;


// Hookup modules
//stage1
e8b10b_p e8b10b_p (
  .clk_i  ( clk_i  ),
  .rstn_i ( rstn_i ),
  .ena_i  ( ena_i  ),
  .d_i    ( d_i    ),
  .k_i    ( k_i    ),
  .ena3_o ( ena3   ),
  .d2_o   ( d2     ),
  .k2_o   ( k2     ),
  .k3_o   ( k3     )
);

//stage2
e8b10b_k e8b10b_k (
  .clk_i   ( clk_i  ),
  .d_i     ( d2     ),
  .k_i     ( k2     ),
  .kerr_o  ( kerr   ),
  .k6_o    ( k6     ),
  .k4_o    ( k4     ),
  .kflip_o ( kflip  )
);

e8b10b_d e8b10b_d (
  .clk_i  ( clk_i ),
  .rstn_i ( rstn_i ),
  .d_i    ( d2    ),
  .d4_o   ( d4    ),
  .d6_o   ( d6    )
);

e8b10b_ctrl e8b10b_ctrl (
  .clk_i      ( clk_i    ),
  .rstn_i     ( rstn_i   ),
  .d_i        ( d2       ),
  .d4_alt_o   ( d4_alt   ),
  .d6_alt_o   ( d6_alt   ),
  .d4_invrd_o ( d4_invrd ),
  .dflip_o    ( dflip    ),
  .sc_nrd_o   ( sc_nrd   ),
  .sc_prd_o   ( sc_prd   )
);

//stage3
e8b10b_comb e8b10b_comb (
  .clk_i      ( clk_i    ),
  .rstn_i     ( rstn_i   ),
  .ena_i      ( ena3     ),
  .d6_i       ( d6       ),
  .d4_i       ( d4       ),
  .k6_i       ( k6       ),
  .k4_i       ( k4       ),
  .k_i        ( k3       ),
  .kerr_i     ( kerr     ),
  .d6_alt_i   ( d6_alt   ),
  .d4_alt_i   ( d4_alt   ),
  .d4_invrd_i ( d4_invrd ),
  .dflip_i    ( dflip    ), 
  .kflip_i    ( kflip    ),
  .sc_nrd_i   ( sc_nrd   ),
  .sc_prd_i   ( sc_prd   ),
  .rd_i       ( rd_i     ),
  .rdf_i      ( rdf_i    ),
  .d_o        ( d_o      ),
  .kerr_o     ( kerr_o   ),
  .rdcasc_o   ( rdcasc_o ),
  .rd_o       ( rd_o     )
);

`pragma protect end
endmodule
