/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Decoder                                                 //
//   Testbench Tests                                               //
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

task read_vector;
  input integer fd;

  reg       ena, ko, k28_5, rd, rdf;
  reg       cerr, rdo, rdcasc, rderr;
  reg [9:0] din;
  reg [7:0] dout;
begin
    $fscanf(fd,"%b,%3h,%b,%b,%2h,%b,%b,%b,%b,%b,%b\n",ena,din,rd,rdf,dout,ko,k28_5,cerr,rdo,rdcasc,rderr);
    enai       <= ena;
    di         <= din;
    rdi        <= rd;
    rdfi       <= rdf;
    do_ref     <= dout;
    ko_ref     <= ko;
    k28_5_ref  <= k28_5;
    cerr_ref   <= cerr;
    rdo_ref    <= rdo;
    rdcasc_ref <= rdcasc;
    rderr_ref  <= rderr;
    @(posedge clk);
end
endtask



task tst_simple;
  integer fd;
  integer i;
begin
  $display("-----------------------------------------------------");
  $display("- 8b10b decoder simple data test");
  $display("-----------------------------------------------------");

  reset_error_counters(); 
  enai=0;
  rdfi=0;
  rdi =0;

  rstn = 1'b0;
  repeat(5) @(negedge clk);
  rstn = 1'b1;

  fd = $fopen("../simple.tst","r");
  for (i = 0; i <= 300_000; i = i +1)
  begin
      read_vector(fd);
  end

  $fclose(fd);

  test_done();
end
endtask



task tst_rnd;
  integer fd;
  integer i;
begin
  $display("\n");
  $display("-----------------------------------------------------");
  $display("- 8b10b decoder random data test");
  $display("-----------------------------------------------------");

  reset_error_counters();
  enai=0;

  rstn = 1'b0;
  repeat(5) @(negedge clk);
  rstn = 1'b1;

  fd = $fopen("../rnd.tst","r");
  for (i = 0; i <= 1_000_000; i = i +1)
  begin
      read_vector(fd);
  end

  $fclose(fd);

  test_done();
end
endtask
