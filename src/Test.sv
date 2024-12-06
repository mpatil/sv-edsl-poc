/* -*- sv -*- File generated by the BNF Converter (bnfc 2.9.6). */

/****************************************************************************/
/*                                                                          */
/* This test will parse a file, print the abstract syntax tree, and then    */
/* pretty-print the result.                                                 */
/*                                                                          */
/****************************************************************************/

import C_pkg::*;

program automatic test;

  initial begin : prog
    automatic string filename = "test.w";
    automatic string test_str = "";
    automatic Program parse_tree;
    automatic Interp i = new();
    automatic PrintAbsyn p = new();
    automatic ShowAbsyn q = new();

    if ($value$plusargs("input=%s", filename))
      parse_tree = pProgram(filename);
    else
      parse_tree = psProgram(test_str);
    if (parse_tree) begin

      p.print(parse_tree);
      $write("%s\n", p.buf_);

      q.show(parse_tree);
      //$write("%s\n", q.buf_);

      i.interpret(parse_tree);
    end
  end
endprogram
