/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Encoder                                                 //
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

  reg ena, k, rd, rdf;
  reg kerr, rdo, rdcasc;
  reg [7:0] din;
  reg [9:0] dout;
begin
    $fscanf(fd,"%b,%b,%b,%b,%2h,%b,%3h,%b,%b\n",ena,k,rd,rdf,din,kerr,dout,rdo,rdcasc);
    enai       <= ena;
    ki         <= k;
    rdi        <= rd;
    rdfi       <= rdf;
    di         <= din;
    kerr_ref   <= kerr;
    do_ref     <= dout;
    rdo_ref    <= rdo;
    rdcasc_ref <= rdcasc;
    @(posedge clk);
end
endtask


task tst_enc;
  integer i;
  integer fd;
begin
  $display("-----------------------------------------------------");
  $display("- 8b10b encoder D-character encoding test");
  $display("-----------------------------------------------------");

  reset_error_counters();
  enai=0;

  rstn = 1'b0;
  repeat(5) @(negedge clk);
  rstn = 1'b1;

  $display ("Streaming data test");
  fd = $fopen("../Dstream.tst","r");
  for (i = 0; i <= 8'hff; i = i +1)
  begin
      read_vector(fd);
  end
  $fclose(fd);

  $display ("Random data test");
  fd = $fopen("../Drnd.tst","r");
  for (i = 0; i <= 'hff; i = i +1)
  begin
      read_vector(fd);
  end
  $fclose(fd);

  test_done();
end		
endtask


task tst_k;
  integer i;
  integer fd;
begin
  $display("-----------------------------------------------------");
  $display("- 8b10b encoder K-character encoding test");
  $display("-----------------------------------------------------");

  reset_error_counters();
  enai=0;

  rstn = 1'b0;
  repeat(5) @(negedge clk);
  rstn = 1'b1;

  $display ("Streaming data test");
  fd = $fopen("../Kstream.tst","r");
  for (i = 0; i <= 'h1ff; i = i +1)
  begin
      read_vector(fd);
  end
  $fclose(fd);

  $display ("Random data test");
  fd = $fopen("../Krnd.tst","r");
  for (i = 0; i <= 'h1ff; i = i +1)
  begin
      read_vector(fd);
  end

  test_done();
end
endtask


task tst_full;
  integer i;
  integer fd;
begin
  $display("-----------------------------------------------------");
  $display("- 8b10b encoder Full test");
  $display("-----------------------------------------------------");

  reset_error_counters();
  enai = 0;

  rstn = 1'b0;
  repeat(5) @(negedge clk);
  rstn = 1'b1;

  $display ("Streaming data test");
  fd = $fopen("../stream.tst","r");
  for (i = 0; i <= 'h1fff; i = i +1)
  begin
      read_vector(fd);
  end
  $fclose(fd);

  $display ("Random data test");
  fd = $fopen("../rnd.tst","r");
  for (i = 0; i <= 1_000_000; i = i +1)
  begin
      read_vector(fd);
  end
  $fclose(fd);

  test_done();
end
endtask

