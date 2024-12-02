  
`define _ERROR_ 257
`define _BANG 258
`define _BANGEQ 259
`define _PERCENT 260
`define _AMP 261
`define _DAMP 262
`define _LPAREN 263
`define _RPAREN 264
`define _STAR 265
`define _DSTAR 266
`define _PLUS 267
`define _DPLUS 268
`define _COMMA 269
`define _MINUS 270
`define _DMINUS 271
`define _SLASH 272
`define _COLON 273
`define _SEMI 274
`define _LT 275
`define _DLT 276
`define _LDARROW 277
`define _EQ 278
`define _DEQ 279
`define _GT 280
`define _GTEQ 281
`define _DGT 282
`define _QUESTION 283
`define _LBRACK 284
`define _RBRACK 285
`define _CARET 286
`define _KW_bin 287
`define _KW_break 288
`define _KW_ceil 289
`define _KW_continue 290
`define _KW_defined 291
`define _KW_else 292
`define _KW_elsif 293
`define _KW_fatal 294
`define _KW_floor 295
`define _KW_for 296
`define _KW_forever 297
`define _KW_function 298
`define _KW_hex 299
`define _KW_if 300
`define _KW_48 301
`define _KW_log2 302
`define _KW_print 303
`define _KW_procedure 304
`define _KW_regrd 305
`define _KW_regwr 306
`define _KW_return 307
`define _KW_sys 308
`define _KW_var 309
`define _KW_wait 310
`define _KW_while 311
`define _LBRACE 312
`define _BAR 313
`define _DBAR 314
`define _RBRACE 315
`define _TILDE 316
`define T_AnyChars 317
`define T_BinaryNumber 318
`define T_Decimal_Number 319
`define T_HexNumber 320
`define T_Real_Number 321
`define _IDENT_ 322
`define YYNTOKENS 194
`define YYERRCODE 256
  //#line 5 "C.y"
`include "Absyn.svh"
`include "bio.svh"
`include "Lexer.svh"

Biobuf b;

typedef struct { int i; } YY_BUFFER_STATE;

function int yywrap();
  return 1;
endfunction


static Program  YY_RESULT_Program_ = null;


  //#line 23 "C.y"
typedef struct
{
  int    _int;
  byte   _char;
  real   _double;
  string _string;
  Program  program_;
  ListStmt_Item  liststmt_item_;
  Stmt_Item  stmt_item_;
  ListExpr  listexpr_;
  Var_Assignment  var_assignment_;
  Jump_Stmt  jump_stmt_;
  FuncOrProcCall  funcorproccall_;
  Builtin_Task  builtin_task_;
  Builtin_Fn  builtin_fn_;
  Bar  bar_;
  Print_Arg  print_arg_;
  ListPrint_Arg  listprint_arg_;
  Proc_Definition  proc_definition_;
  Func_Definition  func_definition_;
  Definition  definition_;
  Formal_Arg  formal_arg_;
  ListFormal_Arg  listformal_arg_;
  Else_If  else_if_;
  ListElse_If  listelse_if_;
  Else_Opt  else_opt_;
  Conditional_Stmt  conditional_stmt_;
  Loop_Stmt  loop_stmt_;
  For_Init_Opt  for_init_opt_;
  Expr_Opt  expr_opt_;
  For_Step_Opt  for_step_opt_;
  Op  op_;
  Expr  expr_;
  Primary  primary_;
  Range_Expr_Opt  range_expr_opt_;
  Range_Expr  range_expr_;
  Unary_Operator  unary_operator_;
  Inc_Or_Dec_Operator  inc_or_dec_operator_;
  Number  number_;
  String_Literal  string_literal_;
} YYSTYPE;
  //#line 66 "C.y"
task yyerror(string str);
  $display("error: line %0d: %s at %s\n", yy_mylinenumber, str, string'(yytext)); //'
  $fatal;
endtask

task execerror(string s, string t);   /* recover from run-time error */
  if (s != "") $write(" %s ", s);
    if (t != "") $write(" %s ", t);
    $fatal (1, $psprintf("\nFATAL ERROR: line %0d near \"%s\": exiting!!!\n\n", yy_mylinenumber, string'(yytext))); //'
endtask



  //#line 201 "C.y"
/*`include "Lexer.svh"*/
  static bit  yydebug;           //do I want debug output?
  int yynerrs;            //number of errors so far
  int yyerrflag;          //was there an error?
  int yychar = -1;             //the current working character

  //###############################################################
  // method: debug
  //###############################################################
  function void debug(string msg);
    if (yydebug)
      $display(msg);
  endfunction


  //########## STATE STACK ##########
  
  int statestk[$]; //state stack
  //###############################################################
  // methods: state stack push,pop,drop,peek
  //###############################################################
  function void state_push(int state);
    statestk.push_front(state);
  endfunction

  function state_pop();
    return statestk.pop_front();
  endfunction

  function void state_drop(int cnt);
    statestk = statestk[cnt:$];
  endfunction

  static string ascii[] = {"\\0","SOH","STX","ETX","EOT","ENQ","ACK","\\a","\\b","\\t","\\n","\\v","\\f","\\r","SO","SI",
        "DLE","DC1","DC2","DC3","DC4","NAK","SYN","ETB","CAN","EM","SUB","ESC","FS","GS","RS","US",
        "SPACE","!","\"","#","$","%","&","’","(",")","*","+",",","-",".","/",
        "0","1","2","3","4","5","6","7","8","9",":",";","<","=",">","?",
        "@","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O",
        "P","Q","R","S","T","U","V","W","X","Y","Z","[","\\","]","^","_",
        "`","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o",
        "p","q","r","s","t","u","v","w","x","y","z","{","|","}","~","DEL"};

  //###############################################################
  // method: init_stacks : allocate and prepare stacks
  //###############################################################
  function bit init_stacks();
    val_init();
    if (ascii.size() <= 128) init_debug();
    return 1;
  endfunction

  typedef YYSTYPE svtype;
  //########## SEMANTIC VALUES ##########
  //## **user defined:svtype

  string   yytext_;//user variable to return contextual strings
  svtype yyval; //used to return semantic vals from action routines
  svtype yylval;//the 'lval' (result) I got from yylex()
  svtype valstk[$];

  //###############################################################
  // methods: value stack push,pop,drop,peek.
  //###############################################################

  function void val_init();
  //  yyval  = new ();
  //  yylval = new ();
  endfunction

  function void val_push(svtype val);
    valstk.push_front(val);
  endfunction

  function svtype val_pop();
    return valstk.pop_front();
  endfunction

  function void val_drop(int cnt);
    valstk = valstk[cnt:$];
  endfunction

  function svtype dup_yyval(svtype val);
    return val;
  endfunction

  //#### end semantic value section ####
  static int  yylhs[] = { -1,
      0,    1,    1,    2,    2,    2,    2,    2,    2,    2,
      2,    2,    2,    2,    2,    3,    3,    3,    4,    5,
      5,    5,    6,    7,    7,    7,    7,    8,    8,    8,
      8,    8,    8,    8,    9,   10,   10,   10,   10,   11,
     11,   12,   13,   14,   15,   16,   16,   16,   17,   18,
     18,   19,   19,   20,   21,   21,   21,   22,   22,   22,
     23,   23,   24,   24,   24,   25,   25,   25,   25,   25,
     25,   25,   26,   27,   27,   27,   28,   28,   29,   29,
     29,   30,   30,   31,   31,   31,   31,   31,   31,   32,
     32,   33,   33,   34,   34,   34,   34,   35,   35,   36,
     36,   37,   37,   38,   38,   39,   39,   40,   40,   41,
     41,   42,   42,   43,   43,   44,   44,   45,   45,   46,
     46,   46,   46,   47,   47,   48,   48,   48,   48,   49,  0
  };
  static int  yylen[] = { 2,
      1,    0,    2,    3,    3,    2,    1,    3,    1,    2,
      3,    2,    1,    1,    2,    0,    1,    3,    4,    1,
      1,    2,    4,    4,    8,    4,    4,    6,    8,    4,
      4,    4,    4,    4,    1,    1,    1,    4,    4,    1,
      3,    2,    2,    5,    1,    0,    1,    3,    5,    0,
      2,    0,    2,    7,    5,    9,    2,    0,    1,    2,
      0,    1,    0,    1,    2,    1,    1,    1,    1,    1,
      1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
      1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
      1,    1,    3,    2,    1,    1,    1,    3,    1,    3,
      1,    3,    1,    3,    1,    3,    1,    3,    1,    3,
      1,    5,    1,    2,    1,    0,    3,    1,    3,    1,
      1,    1,    1,    1,    1,    1,    1,    1,    1,    1,  0
  };
  static int  yydefred[] = { 2,
      0,    0,   20,   21,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    2,    0,    3,    0,
      0,    0,    0,   13,   14,    7,    9,    0,    0,   57,
      0,   43,    0,    0,   42,    0,  122,    0,  120,  121,
      0,    0,    0,    0,    0,    0,    0,  123,  127,  126,
    128,  129,    0,   96,   95,   22,   97,    0,  101,    0,
      0,    0,    0,  111,    0,    0,   92,    0,  115,    0,
      0,    0,    0,    0,    0,  124,  125,    0,    0,    0,
      6,   10,   15,   12,    0,    0,    0,   59,    0,    0,
      0,    0,    0,  130,    0,    0,    0,   37,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,  114,   73,
      0,   76,   74,   75,    0,   77,   78,    0,   79,   80,
     81,    0,   89,   84,   83,   85,   88,   86,   87,   82,
      0,    0,   90,   91,    0,    0,    0,   94,    4,    5,
      0,    0,   11,    0,    0,    0,    0,    0,    8,   27,
     60,    0,   45,    0,    0,    0,    0,    0,    0,   24,
      0,   93,    0,    0,    0,    0,    0,    0,    0,   98,
    100,    0,    0,    0,    0,  110,    0,   26,    0,   23,
      0,    0,  117,    0,    0,    0,    0,   50,    0,    0,
     41,    0,   30,   34,   31,    0,   32,    0,   33,    0,
     55,   18,    0,    0,   48,   44,    0,   39,   38,    0,
      0,    0,    0,    0,   64,    0,    0,    0,   51,   54,
      0,    0,   28,   65,    0,   53,    0,   25,    0,   56,
      0,   29,    0,   49,  0
  };
  static int  yydgoto[] = { 1,
      2,   19,  144,   20,   21,   54,   23,   55,   99,   95,
     96,   24,   25,   32,  154,  155,  219,  207,  220,   26,
     27,   89,   56,  216,    0,  111,  115,  118,  122,  131,
    132,  135,   57,   58,   59,   60,   61,   62,   63,   64,
     65,  145,   67,   79,  147,   68,   80,   69,   98,0 
  };
  static int  yysindex[] = { 0,
      0,  334,    0,    0, -251, -243,  334, -308, -228, -221,
   -308, -186,  -59, -230, -122,  -91,    0, -210,    0, -158,
    -94,  -87,  -84,    0,    0,    0,    0,  -59, -134,    0,
    -80,    0,  -59, -187,    0,  -59,    0,  -59,    0,    0,
    -71,  -67,  -66,  -63,  -61,  -60,  -58,    0,    0,    0,
      0,    0, -248,    0,    0,    0,    0,  -57,    0,  -74,
   -171, -254, -225,    0, -249,  -77,    0, -233,    0, -193,
    -55,  -59,  -59,  305,  -59,    0,    0,  -59,  -64,  -52,
      0,    0,    0,    0, -216, -105,  -51,    0,  -50,  -95,
   -204,  -34,  -29,    0,  -31,  -25,  -77,    0,  -28,  -77,
   -180,  -59,  -82,  -59,  -19,  -59,  -59,  -72,    0,    0,
    -59,    0,    0,    0,  -59,    0,    0,  -59,    0,    0,
      0,  -59,    0,    0,    0,    0,    0,    0,    0,    0,
    -59,  -59,    0,    0,  -59,  -59,  -51,    0,    0,    0,
   -170, -159,    0,  -17, -261, -136,  -37,  -59,    0,    0,
      0,  -59,    0,  -18,  -14,  334,  -59,  -59, -187,    0,
    -59,    0, -157,  -12, -155,  -59, -147,  -16,  -10,    0,
      0,  -74, -171, -254, -265,    0, -252,    0,  334,    0,
    -59,  -59,    0,  -77,   -8,  -95,  334,    0, -145, -141,
      0, -201,    0,    0,    0,   -6,    0,  -59,    0,  -59,
      0,    0,  -77,  -54,    0,    0,  -98,    0,    0,  -59,
    -13, -139, -249, -100,    0,    3,  334,    2,    0,    0,
   -137,  -59,    0,    0,  334,    0,  -59,    0, -124,    0,
   -119,    0,  334,    0, 0 
  };
  static int  yyrindex[] = { 0,
      0,  255,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,   -4,    0,    0,    0,    0,   -7,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,   -1,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,   60,    0,    0,    0,    0,  116,    0,  158,
    242, -236, -107,    0, -163,    4,    0,    0,    0,   -7,
      0,    0,    0,    0,    5,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,   -7,    0,    0,    8,
      0,    0,    0,    0,   10,    0, -108,    0,    0,    6,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,   60,    0,    0,    0,
      0,    0,    0,    0,   12,  -21,    0,    0,    0,    0,
      0,   -4,    0,   13,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    5,    0,    0,    0,    0,
      0,  200,  284,  309, -104,    0,    0,    0,    0,    0,
      5,    0,    0, -111,    0,    8,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,   -3,   15,    0,    0,    1,    0,    0,    0,
      0,    0,  -48,   -7,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,0 
  };
  static int  yygindex[] = { 0,
    263,   -5, -150,  -11,    0,   -2,    0,    0,  174,    0,
    124,    0,    0,  273,    0,   99,    0,    0,    0,    0,
      0,    0,  134,    0,    0,    0,    0,    0,    0,    0,
      0,    0,  219,    0,  -45,  170,  168,  161,  162,  165,
   -127,   -9,    0,  -47,    0,    0,   79,    0,  188,0 
  };
`define YYTABLESIZE 656
  int  yytable[] = { 22,
     52,   30,   71,   66,   22,  109,  119,  181,  177,  133,
    125,   28,  133,   31,   75,  196,  130,   88,   85,   29,
    200,  136,  107,   91,   97,  107,  100,  107,  101,   38,
    202,  120,  107,  123,   33,   78,  107,  107,  107,  107,
    107,   34,  107,  107,  107,  107,  107,  150,  107,  124,
    125,  126,   75,  127,  128,  129,  130,   76,  121,  156,
     77,  134,  141,  142,  134,  170,  136,  210,  146,  171,
     37,   22,  213,   78,  151,   38,   36,  107,  136,   39,
    139,  136,   40,  162,   49,   50,   51,   52,  137,  109,
     78,   70,  163,  178,  165,  116,  167,  100,  117,   92,
    113,   41,  136,   42,  179,  113,  193,   43,  195,  113,
    113,   93,  136,   44,   45,   81,  197,   46,  208,  113,
     47,  113,  209,  136,  223,  136,  228,  136,   48,   94,
     49,   50,   51,   52,   53,  136,  182,  136,  184,  232,
     72,  136,   66,  136,  233,  136,  136,  189,  190,   97,
    188,  192,   19,   22,  109,   36,  109,  108,  136,  108,
     36,  109,   19,  136,  108,  109,  109,   76,  108,  108,
     77,   73,  203,  201,   86,  109,   22,  109,  108,   82,
    108,  206,   90,   78,   22,  112,   83,   87,  212,   84,
    113,  102,  215,  217,  218,  103,  104,  114,   37,  105,
    221,  106,  107,   38,  108,  136,  109,   39,  110,  108,
     40,  226,  229,  148,   22,  112,   87,  231,  140,  230,
    112,  149,   22,  152,  112,  112,  153,  234,  157,   41,
     22,   42,   78,  158,  112,   43,  112,  159,  160,  164,
    161,   44,   45,  166,   94,   46,  180,  183,   47,  187,
    186,  194,  198,  199,    1,  222,   48,  211,   49,   50,
     51,   52,   53,  118,  227,  204,  225,  214,   16,   61,
    116,   46,   58,   40,   35,   17,   47,   62,   63,   74,
    168,  119,  191,   35,  205,  185,  138,  172,   52,  173,
     52,  174,  224,  175,   52,  169,   52,   52,   52,  176,
     52,    0,    0,   52,   52,    0,   52,   52,    0,   52,
     52,   52,   52,    0,    0,   52,    0,    0,  116,  116,
    116,  116,   52,  116,  116,  116,  116,    0,  116,  116,
      0,  116,  116,  116,  116,  116,  116,    0,  116,  116,
    116,  116,  116,    0,  116,  116,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,  116,  116,   99,   99,   99,   99,    0,   99,
     99,    0,   99,    0,   99,   99,    0,   99,   99,   99,
     99,   99,   99,    0,   99,   99,   99,   99,   99,    0,
     99,   99,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,  103,    0,  103,  103,
      0,  103,    0,    0,  103,    0,  103,  103,   99,   99,
    103,  103,  103,  103,  103,    0,  103,  103,  103,  103,
    103,    0,  103,  103,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,  102,    0,
    102,  102,    0,  102,    0,    0,  102,    0,  102,  102,
    103,  103,  102,  102,  102,  102,  102,    0,  102,  102,
    102,  102,  102,    0,  102,  102,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    105,    0,  105,  105,    0,  105,    0,    0,    0,    0,
    105,    0,  102,  102,  105,  105,  105,  105,  105,    0,
    105,  105,  105,  105,  105,    0,  105,  105,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,  104,    0,  104,  104,    0,  104,    0,    0,
      0,    0,  104,    0,  105,  105,  104,  104,  104,  104,
    104,    0,  104,  104,  104,  104,  104,  106,  104,  104,
    106,    0,  106,    0,    0,    0,    0,  106,    0,    0,
      0,  106,  106,  106,  106,  106,    0,  106,  106,  106,
    106,  106,    3,  106,    4,    0,  104,  104,    5,    0,
      6,    7,    8,    0,    9,    0,    0,   10,   11,    0,
     12,   13,    0,   14,   15,   16,   17,    0,    0,  143,
      0,    3,  106,    4,    0,    0,   18,    5,    0,    6,
      7,    8,    0,    9,    0,    0,   10,   11,    0,   12,
     13,    0,   14,   15,   16,   17,    0,    0,    0,    0,
      0,    0,    0,    0,    0,   18,0 
  };
  int  yycheck[] = { 2,
      0,    7,   14,   13,    7,   53,  261,  269,  136,  262,
    276,  263,  262,  322,  263,  166,  282,   29,   28,  263,
    273,  283,  259,   33,   34,  262,   36,  264,   38,  263,
    181,  286,  269,  259,  263,  284,  273,  274,  275,  276,
    277,  263,  279,  280,  281,  282,  283,  264,  285,  275,
    276,  277,  263,  279,  280,  281,  282,  268,  313,  264,
    271,  314,   72,   73,  314,  111,  283,  269,   78,  115,
    258,   74,  200,  284,   86,  263,  263,  314,  283,  267,
    274,  283,  270,  264,  318,  319,  320,  321,  322,  137,
    284,  322,  102,  264,  104,  267,  106,  107,  270,  287,
    264,  289,  283,  291,  264,  269,  264,  295,  264,  273,
    274,  299,  283,  301,  302,  274,  264,  305,  264,  283,
    308,  285,  264,  283,  264,  283,  264,  283,  316,  317,
    318,  319,  320,  321,  322,  283,  273,  283,  148,  264,
    263,  283,  152,  283,  264,  283,  283,  157,  158,  159,
    156,  161,  264,  156,  262,  264,  264,  262,  283,  264,
    269,  269,  274,  283,  269,  273,  274,  268,  273,  274,
    271,  263,  182,  179,  309,  283,  179,  285,  283,  274,
    285,  187,  263,  284,  187,  260,  274,  322,  198,  274,
    265,  263,  204,  292,  293,  263,  263,  272,  258,  263,
    210,  263,  263,  263,  263,  283,  314,  267,  266,  314,
    270,  217,  222,  278,  217,  264,  322,  227,  274,  225,
    269,  274,  225,  274,  273,  274,  322,  233,  263,  289,
    233,  291,  284,  263,  283,  295,  285,  269,  264,  322,
    269,  301,  302,  263,  317,  305,  264,  285,  308,  264,
    269,  264,  269,  264,    0,  269,  316,  264,  318,  319,
    320,  321,  322,  285,  263,  274,  264,  322,  264,  274,
    278,  264,  274,  264,  269,  264,  264,  274,  264,   17,
    107,  285,  159,   11,  186,  152,   68,  118,  288,  122,
    290,  131,  214,  132,  294,  108,  296,  297,  298,  135,
    300,   -1,   -1,  303,  304,   -1,  306,  307,   -1,  309,
    310,  311,  312,   -1,   -1,  315,   -1,   -1,  259,  260,
    261,  262,  322,  264,  265,  266,  267,   -1,  269,  270,
     -1,  272,  273,  274,  275,  276,  277,   -1,  279,  280,
    281,  282,  283,   -1,  285,  286,   -1,   -1,   -1,   -1,
     -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
     -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
     -1,   -1,  313,  314,  259,  260,  261,  262,   -1,  264,
    265,   -1,  267,   -1,  269,  270,   -1,  272,  273,  274,
    275,  276,  277,   -1,  279,  280,  281,  282,  283,   -1,
    285,  286,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
     -1,   -1,   -1,   -1,   -1,   -1,  259,   -1,  261,  262,
     -1,  264,   -1,   -1,  267,   -1,  269,  270,  313,  314,
    273,  274,  275,  276,  277,   -1,  279,  280,  281,  282,
    283,   -1,  285,  286,   -1,   -1,   -1,   -1,   -1,   -1,
     -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  259,   -1,
    261,  262,   -1,  264,   -1,   -1,  267,   -1,  269,  270,
    313,  314,  273,  274,  275,  276,  277,   -1,  279,  280,
    281,  282,  283,   -1,  285,  286,   -1,   -1,   -1,   -1,
     -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
    259,   -1,  261,  262,   -1,  264,   -1,   -1,   -1,   -1,
    269,   -1,  313,  314,  273,  274,  275,  276,  277,   -1,
    279,  280,  281,  282,  283,   -1,  285,  286,   -1,   -1,
     -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
     -1,   -1,  259,   -1,  261,  262,   -1,  264,   -1,   -1,
     -1,   -1,  269,   -1,  313,  314,  273,  274,  275,  276,
    277,   -1,  279,  280,  281,  282,  283,  259,  285,  286,
    262,   -1,  264,   -1,   -1,   -1,   -1,  269,   -1,   -1,
     -1,  273,  274,  275,  276,  277,   -1,  279,  280,  281,
    282,  283,  288,  285,  290,   -1,  313,  314,  294,   -1,
    296,  297,  298,   -1,  300,   -1,   -1,  303,  304,   -1,
    306,  307,   -1,  309,  310,  311,  312,   -1,   -1,  315,
     -1,  288,  314,  290,   -1,   -1,  322,  294,   -1,  296,
    297,  298,   -1,  300,   -1,   -1,  303,  304,   -1,  306,
    307,   -1,  309,  310,  311,  312,   -1,   -1,   -1,   -1,
     -1,   -1,   -1,   -1,   -1,  322,0 
  };
`define YYFINAL 1
`ifndef YYDEBUG
`define YYDEBUG 0
`endif
`define YYMAXTOKEN 322
  static string yyname[] = {
  "end-of-file","","","","","","","","","","","","","",
  "","","","","","","","","","","","","","","","",
  "","","","","","","","","","","","","","","","",
  "","","","","","","","","","","","","","","","",
  "","","","","","","","","","","","","","","","",
  "","","","","","","","","","","","","","","","",
  "","","","","","","","","","","","","","","","",
  "","","","","","","","","","","","","","","","",
  "","","","","","","","","","","","","","","","",
  "","","","","","","","","","","","","","","","",
  "","","","","","","","","","","","","","","","",
  "","","","","","","","","","","","","","","","",
  "","","","","","","","","","","","","","","","",
  "","","","","","","","","","","","","","","","",
  "","","","","","","","","","","","","","","","",
  "","","","","","","","","","","","","","","","",
  "","","","_ERROR_","_BANG","_BANGEQ","_PERCENT","_AMP","_DAMP","_LPAREN",
  "_RPAREN","_STAR","_DSTAR","_PLUS","_DPLUS","_COMMA","_MINUS","_DMINUS",
  "_SLASH","_COLON","_SEMI","_LT","_DLT","_LDARROW","_EQ","_DEQ","_GT","_GTEQ",
  "_DGT","_QUESTION","_LBRACK","_RBRACK","_CARET","_KW_bin","_KW_break",
  "_KW_ceil","_KW_continue","_KW_defined","_KW_else","_KW_elsif","_KW_fatal",
  "_KW_floor","_KW_for","_KW_forever","_KW_function","_KW_hex","_KW_if","_KW_48",
  "_KW_log2","_KW_print","_KW_procedure","_KW_regrd","_KW_regwr","_KW_return",
  "_KW_sys","_KW_var","_KW_wait","_KW_while","_LBRACE","_BAR","_DBAR","_RBRACE",
  "_TILDE","T_AnyChars","T_BinaryNumber","T_Decimal_Number","T_HexNumber",
  "T_Real_Number","_IDENT_","" 
  };
  static string yyrule[] = {
    "$accept : Program",
    "Program : ListStmt_Item",
    "ListStmt_Item :",
    "ListStmt_Item : ListStmt_Item Stmt_Item",
    "Stmt_Item : _KW_var _IDENT_ _SEMI",
    "Stmt_Item : _KW_var Var_Assignment _SEMI",
    "Stmt_Item : Var_Assignment _SEMI",
    "Stmt_Item : Conditional_Stmt",
    "Stmt_Item : _IDENT_ Inc_Or_Dec_Operator _SEMI",
    "Stmt_Item : Loop_Stmt",
    "Stmt_Item : Jump_Stmt _SEMI",
    "Stmt_Item : _LBRACE ListStmt_Item _RBRACE",
    "Stmt_Item : Builtin_Task _SEMI",
    "Stmt_Item : Proc_Definition",
    "Stmt_Item : Func_Definition",
    "Stmt_Item : FuncOrProcCall _SEMI",
    "ListExpr :",
    "ListExpr : Expr",
    "ListExpr : Expr _COMMA ListExpr",
    "Var_Assignment : _IDENT_ Range_Expr_Opt _EQ Expr",
    "Jump_Stmt : _KW_break",
    "Jump_Stmt : _KW_continue",
    "Jump_Stmt : _KW_return Expr_Opt",
    "FuncOrProcCall : _IDENT_ _LPAREN ListExpr _RPAREN",
    "Builtin_Task : _KW_print _LPAREN ListPrint_Arg _RPAREN",
    "Builtin_Task : _KW_regwr _LPAREN Bar _COMMA Expr _COMMA Expr _RPAREN",
    "Builtin_Task : _KW_wait _LPAREN Expr _RPAREN",
    "Builtin_Task : _KW_fatal _LPAREN Expr _RPAREN",
    "Builtin_Fn : _KW_regrd _LPAREN Bar _COMMA Expr _RPAREN",
    "Builtin_Fn : _KW_48 _LPAREN _LPAREN ListExpr _RPAREN _COMMA Expr _RPAREN",
    "Builtin_Fn : _KW_ceil _LPAREN Expr _RPAREN",
    "Builtin_Fn : _KW_floor _LPAREN Expr _RPAREN",
    "Builtin_Fn : _KW_log2 _LPAREN Expr _RPAREN",
    "Builtin_Fn : _KW_sys _LPAREN String_Literal _RPAREN",
    "Builtin_Fn : _KW_defined _LPAREN _IDENT_ _RPAREN",
    "Bar : Expr",
    "Print_Arg : Expr",
    "Print_Arg : String_Literal",
    "Print_Arg : _KW_hex _LPAREN Expr _RPAREN",
    "Print_Arg : _KW_bin _LPAREN Expr _RPAREN",
    "ListPrint_Arg : Print_Arg",
    "ListPrint_Arg : Print_Arg _COMMA ListPrint_Arg",
    "Proc_Definition : _KW_procedure Definition",
    "Func_Definition : _KW_function Definition",
    "Definition : _IDENT_ _LPAREN ListFormal_Arg _RPAREN Stmt_Item",
    "Formal_Arg : _IDENT_",
    "ListFormal_Arg :",
    "ListFormal_Arg : Formal_Arg",
    "ListFormal_Arg : Formal_Arg _COMMA ListFormal_Arg",
    "Else_If : _KW_elsif _LPAREN Expr _RPAREN Stmt_Item",
    "ListElse_If :",
    "ListElse_If : ListElse_If Else_If",
    "Else_Opt :",
    "Else_Opt : _KW_else Stmt_Item",
    "Conditional_Stmt : _KW_if _LPAREN Expr _RPAREN Stmt_Item ListElse_If Else_Opt",
    "Loop_Stmt : _KW_while _LPAREN Expr _RPAREN Stmt_Item",
    "Loop_Stmt : _KW_for _LPAREN For_Init_Opt _SEMI Expr_Opt _SEMI For_Step_Opt _RPAREN Stmt_Item",
    "Loop_Stmt : _KW_forever Stmt_Item",
    "For_Init_Opt :",
    "For_Init_Opt : Var_Assignment",
    "For_Init_Opt : _KW_var Var_Assignment",
    "Expr_Opt :",
    "Expr_Opt : Expr",
    "For_Step_Opt :",
    "For_Step_Opt : Var_Assignment",
    "For_Step_Opt : _IDENT_ Inc_Or_Dec_Operator",
    "Op : Op1",
    "Op : Op2",
    "Op : Op3",
    "Op : Op4",
    "Op : Op5",
    "Op : Op6",
    "Op : Op7",
    "Op7 : _DSTAR",
    "Op6 : _STAR",
    "Op6 : _SLASH",
    "Op6 : _PERCENT",
    "Op5 : _PLUS",
    "Op5 : _MINUS",
    "Op4 : _AMP",
    "Op4 : _CARET",
    "Op4 : _BAR",
    "Op3 : _DGT",
    "Op3 : _DLT",
    "Op2 : _LT",
    "Op2 : _LDARROW",
    "Op2 : _GT",
    "Op2 : _GTEQ",
    "Op2 : _DEQ",
    "Op2 : _BANGEQ",
    "Op1 : _DAMP",
    "Op1 : _DBAR",
    "Expr9 : Primary",
    "Expr9 : _LPAREN Expr _RPAREN",
    "Expr8 : Unary_Operator Expr9",
    "Expr8 : Builtin_Fn",
    "Expr8 : FuncOrProcCall",
    "Expr8 : Expr9",
    "Expr7 : Expr8 Op7 Expr7",
    "Expr7 : Expr8",
    "Expr6 : Expr6 Op6 Expr7",
    "Expr6 : Expr7",
    "Expr5 : Expr5 Op5 Expr6",
    "Expr5 : Expr6",
    "Expr4 : Expr4 Op4 Expr5",
    "Expr4 : Expr5",
    "Expr3 : Expr3 Op3 Expr4",
    "Expr3 : Expr4",
    "Expr2 : Expr3 Op2 Expr3",
    "Expr2 : Expr3",
    "Expr1 : Expr1 Op1 Expr2",
    "Expr1 : Expr2",
    "Expr : Expr _QUESTION Expr1 _COLON Expr1",
    "Expr : Expr1",
    "Primary : _IDENT_ Range_Expr_Opt",
    "Primary : Number",
    "Range_Expr_Opt :",
    "Range_Expr_Opt : _LBRACK Range_Expr _RBRACK",
    "Range_Expr : Expr",
    "Range_Expr : Expr _COLON Expr",
    "Unary_Operator : _PLUS",
    "Unary_Operator : _MINUS",
    "Unary_Operator : _BANG",
    "Unary_Operator : _TILDE",
    "Inc_Or_Dec_Operator : _DPLUS",
    "Inc_Or_Dec_Operator : _DMINUS",
    "Number : T_Decimal_Number",
    "Number : T_BinaryNumber",
    "Number : T_HexNumber",
    "Number : T_Real_Number",
    "String_Literal : T_AnyChars",
    ""
  };

  //###############################################################
  // method: dump_stacks : show n levels of the stacks
  //###############################################################
  function void dump_stacks(int count);
    int i;
    debug($psprintf("=index==state====value=  "));
    for (i=0;i<count;i++)
      debug($psprintf(" %0d %0d %p", i, statestk[i], valstk[i]));
    debug("======================");
  endfunction

  //###############################################################
  // method: yylexdebug : check lexer state
  //###############################################################
  function void yylexdebug(int state,int ch);
    string s;
    if (ch < 0) ch=0;
    if (ch <= `YYMAXTOKEN) //check index bounds
      s = yyname[ch];    //now get it
    if (s == "")
      s = "illegal-symbol";
    debug($psprintf("state %0d, reading %0d (%0s)", state, ch, s));
  endfunction



  //The following are now global, to aid in error reporting
  int yyn;       //next next thing to do
  int yym;       //
  int yystate;   //current parsing state from state table
  string yys;    //current token string
  
  //###############################################################
  // method: yyparse : parse input and execute indicated items
  //###############################################################
  function int yyparse();
    bit doaction;
    init_stacks();
    yynerrs = 0;
    yyerrflag = 0;
    //yychar = -1;          //impossible char forces a read
    yystate=0;            //initial state
    state_push(yystate);  //save it
    val_push(yylval);     //save empty value
    while (1) begin //until parsing is done, either correctly, or w/error
      doaction=1;
      debug("loop"); 
      //#### NEXT ACTION (from reduction table)
      for (yyn = yydefred[yystate]; yyn == 0; yyn = yydefred[yystate]) begin
        debug($psprintf("yyn:%0d  state:%0d  yychar: %s (%0d)", yyn, yystate, ascii[yychar], yychar));
        if (yychar < 0) begin     //we want a char?
          yychar = yylex();  //get next token
          debug($psprintf(" next yychar: %s (%0d)",ascii[yychar], yychar));
          //#### ERROR CHECK ####
          if (yychar < 0) begin   //it it didn't work/error
            yychar = 0;      //change it to default string (no -1!)
            if (yydebug)
              yylexdebug(yystate,yychar);
          end
        end//yychar<0
        yyn = yysindex[yystate];  //get amount to shift by (shift index)
        if (yyn != 0) begin
          yyn += yychar;
          if (yyn >= 0 && yyn <= `YYTABLESIZE && yycheck[yyn] == yychar) begin
            debug($psprintf("state %0d, shifting to state %0d", yystate,yytable[yyn]));
            //#### NEXT STATE ####
            yystate = yytable[yyn];//we are in a new state
            state_push(yystate);   //save it
            val_push(yylval);      //push our lval as the input for next rule
            yychar = -1;           //since we have 'eaten' a token, say we need another
            if (yyerrflag > 0)     //have we recovered an error?
               --yyerrflag;        //give ourselves credit
            doaction=0;            //but don't process yet
            break;                 //quit the yyn=0 loop
          end
        end
        yyn = yyrindex[yystate];  //reduce
        if (yyn != 0) begin
          yyn += yychar;
          if (yyn >= 0 && yyn <= `YYTABLESIZE && yycheck[yyn] == yychar) begin //we reduced!
            debug("reduce");
            yyn = yytable[yyn];
            doaction=1; //get ready to execute
            break;      //drop down to actions
          end else begin
            execerror("Cannot recover from parse error", yys);
            $finish;
          end
        end
        else //ERROR RECOVERY
        begin
          if (yyerrflag==0) begin
            yyerror("syntax error");
            yynerrs++;
          end
          if (yyerrflag < 3) begin //low error count?
            yyerrflag = 3;
            while (1) begin  //do until break
              yyn = yysindex[statestk[0]];
              if (yyn != 0) begin
                yyn += `YYERRCODE;
                if (yyn >= 0 && yyn <= `YYTABLESIZE && yycheck[yyn] == `YYERRCODE) begin
                  debug($psprintf("state %0d, error recovery shifting to state %0d ", statestk[0], yytable[yyn]));
                  yystate = yytable[yyn];
                  state_push(yystate);
                  val_push(yylval);
                  doaction=0;
                  break;
                end
              end
              else
              begin
                debug($psprintf("error recovery discarding state %0d ", statestk[0]));
                state_pop();
                val_pop();
              end
            end
          end
          else //discard this token
          begin
            if (yychar == 0)
              return 1; //yyabort
            if (yydebug) begin
              yys = "";
              if (yychar <= `YYMAXTOKEN) yys = yyname[yychar];
              if (yys == "") yys = "illegal-symbol";
              debug($psprintf("state %0d, error recovery discards token  %s (%0d)", yystate, ascii[yychar], yys));
            end
            yychar = -1;  //read another
          end
        end  //end error recovery
      end   //yyn=0 loop
      if (!doaction)   //any reason not to proceed?
        continue;      //skip action
      yym = yylen[yyn];          //get count of terminals on rhs
      debug($psprintf("state %0d, reducing %0d by rule %0d (%s)", yystate, yym, yyn, yyrule[yyn]));
      if (yym>0)                 //if count of rhs not 'nil'
        yyval = valstk[yym-1]; //get current semantic value
      yyval = dup_yyval(yyval);  //duplicate yyval if ParserVal is used as semantic value
      case(yyn)
      //########## USER-SUPPLIED ACTIONS ##########
      1:  //#line 205 "C.y"
      begin
          yyval.program_ = Program1::new (valstk[0].liststmt_item_);YY_RESULT_Program_ = yyval.program_; 
      end
      2:  //#line 207 "C.y"
      begin
          yyval.liststmt_item_ = ListStmt_Item::new(); 
      end
      3:  //#line 208 "C.y"
      begin
          valstk[1].liststmt_item_.v.push_back(valstk[0].stmt_item_); yyval.liststmt_item_ = valstk[1].liststmt_item_; 
      end
      4:  //#line 210 "C.y"
      begin
          yyval.stmt_item_ = VarDeclStmt::new (valstk[1]._string); 
      end
      5:  //#line 211 "C.y"
      begin
          yyval.stmt_item_ = VarAssDeclStmt::new (valstk[1].var_assignment_); 
      end
      6:  //#line 212 "C.y"
      begin
          yyval.stmt_item_ = AssignmentStmt::new (valstk[1].var_assignment_); 
      end
      7:  //#line 213 "C.y"
      begin
          yyval.stmt_item_ = ConditionalStmt::new (valstk[0].conditional_stmt_); 
      end
      8:  //#line 214 "C.y"
      begin
          yyval.stmt_item_ = IncDecOpStmt::new (valstk[2]._string, valstk[1].inc_or_dec_operator_); 
      end
      9:  //#line 215 "C.y"
      begin
          yyval.stmt_item_ = LoopStmt::new (valstk[0].loop_stmt_); 
      end
      10:  //#line 216 "C.y"
      begin
          yyval.stmt_item_ = JumpStmt::new (valstk[1].jump_stmt_); 
      end
      11:  //#line 217 "C.y"
      begin
          yyval.stmt_item_ = BlockStmt::new (valstk[1].liststmt_item_); 
      end
      12:  //#line 218 "C.y"
      begin
          yyval.stmt_item_ = BuiltInStmt::new (valstk[1].builtin_task_); 
      end
      13:  //#line 219 "C.y"
      begin
          yyval.stmt_item_ = ProcDefStmt::new (valstk[0].proc_definition_); 
      end
      14:  //#line 220 "C.y"
      begin
          yyval.stmt_item_ = FuncDefStmt::new (valstk[0].func_definition_); 
      end
      15:  //#line 221 "C.y"
      begin
          yyval.stmt_item_ = ProcCallStmt::new (valstk[1].funcorproccall_); 
      end
      16:  //#line 223 "C.y"
      begin
          yyval.listexpr_ = ListExpr::new(); 
      end
      17:  //#line 224 "C.y"
      begin
          yyval.listexpr_ = ListExpr::new(); yyval.listexpr_.v.push_back(valstk[0].expr_); 
      end
      18:  //#line 225 "C.y"
      begin
          valstk[0].listexpr_.v.push_back(valstk[2].expr_); yyval.listexpr_ = valstk[0].listexpr_; 
      end
      19:  //#line 227 "C.y"
      begin
          yyval.var_assignment_ = Assignment::new (valstk[3]._string, valstk[2].range_expr_opt_, valstk[0].expr_); 
      end
      20:  //#line 229 "C.y"
      begin
          yyval.jump_stmt_ = Break::new (); 
      end
      21:  //#line 230 "C.y"
      begin
          yyval.jump_stmt_ = Continue::new (); 
      end
      22:  //#line 231 "C.y"
      begin
          yyval.jump_stmt_ = Return::new (valstk[0].expr_opt_); 
      end
      23:  //#line 233 "C.y"
      begin
          valstk[1].listexpr_.v.reverse ;yyval.funcorproccall_ = Call::new (valstk[3]._string, valstk[1].listexpr_); 
      end
      24:  //#line 235 "C.y"
      begin
          valstk[1].listprint_arg_.v.reverse ;yyval.builtin_task_ = Print::new (valstk[1].listprint_arg_); 
      end
      25:  //#line 236 "C.y"
      begin
          yyval.builtin_task_ = RegWr::new (valstk[5].bar_, valstk[3].expr_, valstk[1].expr_); 
      end
      26:  //#line 237 "C.y"
      begin
          yyval.builtin_task_ = Wait::new (valstk[1].expr_); 
      end
      27:  //#line 238 "C.y"
      begin
          yyval.builtin_task_ = Fatal::new (valstk[1].expr_); 
      end
      28:  //#line 240 "C.y"
      begin
          yyval.builtin_fn_ = RegRd::new (valstk[3].bar_, valstk[1].expr_); 
      end
      29:  //#line 241 "C.y"
      begin
          valstk[4].listexpr_.v.reverse ;yyval.builtin_fn_ = WaitInterrupt::new (valstk[4].listexpr_, valstk[1].expr_); 
      end
      30:  //#line 242 "C.y"
      begin
          yyval.builtin_fn_ = Ceil::new (valstk[1].expr_); 
      end
      31:  //#line 243 "C.y"
      begin
          yyval.builtin_fn_ = Floor::new (valstk[1].expr_); 
      end
      32:  //#line 244 "C.y"
      begin
          yyval.builtin_fn_ = Log2::new (valstk[1].expr_); 
      end
      33:  //#line 245 "C.y"
      begin
          yyval.builtin_fn_ = Sys::new (valstk[1].string_literal_); 
      end
      34:  //#line 246 "C.y"
      begin
          yyval.builtin_fn_ = IsDefd::new (valstk[1]._string); 
      end
      35:  //#line 248 "C.y"
      begin
          yyval.bar_ = Bar_::new (valstk[0].expr_); 
      end
      36:  //#line 250 "C.y"
      begin
          yyval.print_arg_ = PrExpr::new (valstk[0].expr_); 
      end
      37:  //#line 251 "C.y"
      begin
          yyval.print_arg_ = PrString::new (valstk[0].string_literal_); 
      end
      38:  //#line 252 "C.y"
      begin
          yyval.print_arg_ = PrHex::new (valstk[1].expr_); 
      end
      39:  //#line 253 "C.y"
      begin
          yyval.print_arg_ = PrBin::new (valstk[1].expr_); 
      end
      40:  //#line 255 "C.y"
      begin
          yyval.listprint_arg_ = ListPrint_Arg::new(); yyval.listprint_arg_.v.push_back(valstk[0].print_arg_); 
      end
      41:  //#line 256 "C.y"
      begin
          valstk[0].listprint_arg_.v.push_back(valstk[2].print_arg_); yyval.listprint_arg_ = valstk[0].listprint_arg_; 
      end
      42:  //#line 258 "C.y"
      begin
          yyval.proc_definition_ = ProcDef::new (valstk[0].definition_); 
      end
      43:  //#line 260 "C.y"
      begin
          yyval.func_definition_ = FuncDef::new (valstk[0].definition_); 
      end
      44:  //#line 262 "C.y"
      begin
          valstk[2].listformal_arg_.v.reverse ;yyval.definition_ = Defn::new (valstk[4]._string, valstk[2].listformal_arg_, valstk[0].stmt_item_); 
      end
      45:  //#line 264 "C.y"
      begin
          yyval.formal_arg_ = Formal::new (valstk[0]._string); 
      end
      46:  //#line 266 "C.y"
      begin
          yyval.listformal_arg_ = ListFormal_Arg::new(); 
      end
      47:  //#line 267 "C.y"
      begin
          yyval.listformal_arg_ = ListFormal_Arg::new(); yyval.listformal_arg_.v.push_back(valstk[0].formal_arg_); 
      end
      48:  //#line 268 "C.y"
      begin
          valstk[0].listformal_arg_.v.push_back(valstk[2].formal_arg_); yyval.listformal_arg_ = valstk[0].listformal_arg_; 
      end
      49:  //#line 270 "C.y"
      begin
          yyval.else_if_ = ElsIf::new (valstk[2].expr_, valstk[0].stmt_item_); 
      end
      50:  //#line 272 "C.y"
      begin
          yyval.listelse_if_ = ListElse_If::new(); 
      end
      51:  //#line 273 "C.y"
      begin
          valstk[1].listelse_if_.v.push_back(valstk[0].else_if_); yyval.listelse_if_ = valstk[1].listelse_if_; 
      end
      52:  //#line 275 "C.y"
      begin
          yyval.else_opt_ = ElseIsEmpty::new (); 
      end
      53:  //#line 276 "C.y"
      begin
          yyval.else_opt_ = ElseIsElse::new (valstk[0].stmt_item_); 
      end
      54:  //#line 278 "C.y"
      begin
          yyval.conditional_stmt_ = If::new (valstk[4].expr_, valstk[2].stmt_item_, valstk[1].listelse_if_, valstk[0].else_opt_); 
      end
      55:  //#line 280 "C.y"
      begin
          yyval.loop_stmt_ = While::new (valstk[2].expr_, valstk[0].stmt_item_); 
      end
      56:  //#line 281 "C.y"
      begin
          yyval.loop_stmt_ = For::new (valstk[6].for_init_opt_, valstk[4].expr_opt_, valstk[2].for_step_opt_, valstk[0].stmt_item_); 
      end
      57:  //#line 282 "C.y"
      begin
          yyval.loop_stmt_ = forever__(valstk[0].stmt_item_); 
      end
      58:  //#line 284 "C.y"
      begin
          yyval.for_init_opt_ = ForInitIsEmpty::new (); 
      end
      59:  //#line 285 "C.y"
      begin
          yyval.for_init_opt_ = ForInitIsInit::new (valstk[0].var_assignment_); 
      end
      60:  //#line 286 "C.y"
      begin
          yyval.for_init_opt_ = ForInitIsVarInit::new (valstk[0].var_assignment_); 
      end
      61:  //#line 288 "C.y"
      begin
          yyval.expr_opt_ = ExprIsEmpty::new (); 
      end
      62:  //#line 289 "C.y"
      begin
          yyval.expr_opt_ = ExprIsExpr::new (valstk[0].expr_); 
      end
      63:  //#line 291 "C.y"
      begin
          yyval.for_step_opt_ = ForStepIsEmpty::new (); 
      end
      64:  //#line 292 "C.y"
      begin
          yyval.for_step_opt_ = ForStepIsAssignment::new (valstk[0].var_assignment_); 
      end
      65:  //#line 293 "C.y"
      begin
          yyval.for_step_opt_ = ForStepIsIncOrDec::new (valstk[1]._string, valstk[0].inc_or_dec_operator_); 
      end
      66:  //#line 295 "C.y"
      begin
          yyval.op_ = valstk[0].op_; 
      end
      67:  //#line 296 "C.y"
      begin
          yyval.op_ = valstk[0].op_; 
      end
      68:  //#line 297 "C.y"
      begin
          yyval.op_ = valstk[0].op_; 
      end
      69:  //#line 298 "C.y"
      begin
          yyval.op_ = valstk[0].op_; 
      end
      70:  //#line 299 "C.y"
      begin
          yyval.op_ = valstk[0].op_; 
      end
      71:  //#line 300 "C.y"
      begin
          yyval.op_ = valstk[0].op_; 
      end
      72:  //#line 301 "C.y"
      begin
          yyval.op_ = valstk[0].op_; 
      end
      73:  //#line 303 "C.y"
      begin
          yyval.op_ = Pow::new (); 
      end
      74:  //#line 305 "C.y"
      begin
          yyval.op_ = Mul::new (); 
      end
      75:  //#line 306 "C.y"
      begin
          yyval.op_ = Div::new (); 
      end
      76:  //#line 307 "C.y"
      begin
          yyval.op_ = Mod::new (); 
      end
      77:  //#line 309 "C.y"
      begin
          yyval.op_ = Add::new (); 
      end
      78:  //#line 310 "C.y"
      begin
          yyval.op_ = Sub::new (); 
      end
      79:  //#line 312 "C.y"
      begin
          yyval.op_ = LAnd::new (); 
      end
      80:  //#line 313 "C.y"
      begin
          yyval.op_ = Xor::new (); 
      end
      81:  //#line 314 "C.y"
      begin
          yyval.op_ = LOr::new (); 
      end
      82:  //#line 316 "C.y"
      begin
          yyval.op_ = Rsh::new (); 
      end
      83:  //#line 317 "C.y"
      begin
          yyval.op_ = Lsh::new (); 
      end
      84:  //#line 319 "C.y"
      begin
          yyval.op_ = Lt::new (); 
      end
      85:  //#line 320 "C.y"
      begin
          yyval.op_ = Leq::new (); 
      end
      86:  //#line 321 "C.y"
      begin
          yyval.op_ = Gt::new (); 
      end
      87:  //#line 322 "C.y"
      begin
          yyval.op_ = Geq::new (); 
      end
      88:  //#line 323 "C.y"
      begin
          yyval.op_ = Eq::new (); 
      end
      89:  //#line 324 "C.y"
      begin
          yyval.op_ = Neq::new (); 
      end
      90:  //#line 326 "C.y"
      begin
          yyval.op_ = And::new (); 
      end
      91:  //#line 327 "C.y"
      begin
          yyval.op_ = Or::new (); 
      end
      92:  //#line 329 "C.y"
      begin
          yyval.expr_ = ExprPrim::new (valstk[0].primary_); 
      end
      93:  //#line 330 "C.y"
      begin
          yyval.expr_ = valstk[1].expr_; 
      end
      94:  //#line 332 "C.y"
      begin
          yyval.expr_ = ExprUnary::new (valstk[1].unary_operator_, valstk[0].expr_); 
      end
      95:  //#line 333 "C.y"
      begin
          yyval.expr_ = ExprBltin::new (valstk[0].builtin_fn_); 
      end
      96:  //#line 334 "C.y"
      begin
          yyval.expr_ = ExprFuncCall::new (valstk[0].funcorproccall_); 
      end
      97:  //#line 335 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; 
      end
      98:  //#line 337 "C.y"
      begin
          yyval.expr_ = op_(valstk[2].expr_, valstk[1].op_, valstk[0].expr_); 
      end
      99:  //#line 338 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; 
      end
      100:  //#line 340 "C.y"
      begin
          yyval.expr_ = op_(valstk[2].expr_, valstk[1].op_, valstk[0].expr_); 
      end
      101:  //#line 341 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; 
      end
      102:  //#line 343 "C.y"
      begin
          yyval.expr_ = op_(valstk[2].expr_, valstk[1].op_, valstk[0].expr_); 
      end
      103:  //#line 344 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; 
      end
      104:  //#line 346 "C.y"
      begin
          yyval.expr_ = op_(valstk[2].expr_, valstk[1].op_, valstk[0].expr_); 
      end
      105:  //#line 347 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; 
      end
      106:  //#line 349 "C.y"
      begin
          yyval.expr_ = op_(valstk[2].expr_, valstk[1].op_, valstk[0].expr_); 
      end
      107:  //#line 350 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; 
      end
      108:  //#line 352 "C.y"
      begin
          yyval.expr_ = op_(valstk[2].expr_, valstk[1].op_, valstk[0].expr_); 
      end
      109:  //#line 353 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; 
      end
      110:  //#line 355 "C.y"
      begin
          yyval.expr_ = op_(valstk[2].expr_, valstk[1].op_, valstk[0].expr_); 
      end
      111:  //#line 356 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; 
      end
      112:  //#line 358 "C.y"
      begin
          yyval.expr_ = ExprTernary::new (valstk[4].expr_, valstk[2].expr_, valstk[0].expr_); 
      end
      113:  //#line 359 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; 
      end
      114:  //#line 361 "C.y"
      begin
          yyval.primary_ = PrimIdent::new (valstk[1]._string, valstk[0].range_expr_opt_); 
      end
      115:  //#line 362 "C.y"
      begin
          yyval.primary_ = PrimNumber::new (valstk[0].number_); 
      end
      116:  //#line 364 "C.y"
      begin
          yyval.range_expr_opt_ = RangeExprIsEmpty::new (); 
      end
      117:  //#line 365 "C.y"
      begin
          yyval.range_expr_opt_ = RangeExprIsRange::new (valstk[1].range_expr_); 
      end
      118:  //#line 367 "C.y"
      begin
          yyval.range_expr_ = RangeExprBit::new (valstk[0].expr_); 
      end
      119:  //#line 368 "C.y"
      begin
          yyval.range_expr_ = RangeExprRange::new (valstk[2].expr_, valstk[0].expr_); 
      end
      120:  //#line 370 "C.y"
      begin
          yyval.unary_operator_ = UnaryPlus::new (); 
      end
      121:  //#line 371 "C.y"
      begin
          yyval.unary_operator_ = UnaryMinus::new (); 
      end
      122:  //#line 372 "C.y"
      begin
          yyval.unary_operator_ = UnaryNot::new (); 
      end
      123:  //#line 373 "C.y"
      begin
          yyval.unary_operator_ = UnaryComp::new (); 
      end
      124:  //#line 375 "C.y"
      begin
          yyval.inc_or_dec_operator_ = Incr::new (); 
      end
      125:  //#line 376 "C.y"
      begin
          yyval.inc_or_dec_operator_ = Decr::new (); 
      end
      126:  //#line 378 "C.y"
      begin
          yyval.number_ = Decimal::new (valstk[0]._string); 
      end
      127:  //#line 379 "C.y"
      begin
          yyval.number_ = Binary::new (valstk[0]._string); 
      end
      128:  //#line 380 "C.y"
      begin
          yyval.number_ = Hex::new (valstk[0]._string); 
      end
      129:  //#line 381 "C.y"
      begin
          yyval.number_ = Real::new (valstk[0]._string); 
      end
      130:  //#line 383 "C.y"
      begin
          yyval.string_literal_ = StringLit::new (valstk[0]._string); 
      end
      //########## END OF USER-SUPPLIED ACTIONS ##########
      endcase //case
      //#### Now let's reduce... ####
      debug("reduce");
      state_drop(yym);             //we just reduced yylen states
      yystate = statestk[0];     //get new state
      val_drop(yym);               //corresponding value drop
      yym = yylhs[yyn];            //select next TERMINAL(on lhs)
      if (yystate == 0 && yym == 0) begin//done? 'rest' state and at first TERMINAL
        debug($psprintf("After reduction, shifting from state 0 to state %0d",`YYFINAL));
        yystate = `YYFINAL;         //explicitly say we're done
        state_push(`YYFINAL);       //and save it
        val_push(yyval);           //also save the semantic value of parsing
        if (yychar < 0) begin      //we want another character?
          yychar = yylex();        //get next character
          debug($psprintf(" next yychar: %s (%0d)",ascii[yychar], yychar));
          if (yychar<0) yychar=0;  //clean, if necessary
          if (yydebug)
            yylexdebug(yystate,yychar);
        end
        if (yychar == 0)          //Good exit (if lex returns 0 ;-)
           break;                 //quit the loop--all DONE
      end//if yystate
      else                        //else not done yet
      begin                         //get next state and push, for next yydefred[]
        yyn = yygindex[yym];      //find out where to go
        if (yyn != 0) begin
          yyn += yystate;
          if (yyn >= 0 && yyn <= `YYTABLESIZE && yycheck[yyn] == yystate)
            yystate = yytable[yyn]; //get new state
          else
            yystate = yydgoto[yym]; //else go to new defred
        end
        else
          yystate = yydgoto[yym]; //else go to new defred
        debug($psprintf("after reduction, shifting from state %0d to state %0d", statestk[0], yystate));
        state_push(yystate);     //going again, so push state & val...
        val_push(yyval);         //for next action
      end
    end//main loop
    return 0;//yyaccept!!
  endfunction
  //## end of method parse() ######################################
  

  //###############################################################
  task init_debug();
    automatic int idx = `YYMAXTOKEN - `YYNTOKENS;
    ascii = new [`YYNTOKENS + 128] (ascii);
    for (int l = 128; l <= 128 + `YYNTOKENS; l++, idx++) begin
      ascii[l] = yyname[idx];
    end
  endtask
  

  //#line 387 "C.y"


/* Entrypoint: parse Program from file. */
function Program pProgram(string filename);
  b = Bopen(filename, `OREAD);
  yy_mylinenumber = 1;
  initialize_lexer(0);
  if (yyparse())
    return null; /* Failure */
  else
    return YY_RESULT_Program_;/* Success */
endfunction

/* Entrypoint: parse Program from string. */
`ifdef XXX
function int psProgram(string str);
  b = Bopen(filename, `OREAD);
  yy_mylinenumber = 1;
  initialize_lexer(0);
  if (yyparse())
    return null; /* Failure */
  else
    return YY_RESULT_Program_;/* Success */
endfunction
`endif



