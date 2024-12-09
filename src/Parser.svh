  
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
`define _KW_log2 301
`define _KW_print 302
`define _KW_procedure 303
`define _KW_regrd 304
`define _KW_regwr 305
`define _KW_return 306
`define _KW_sys 307
`define _KW_var 308
`define _KW_wait 309
`define _KW_while 310
`define _LBRACE 311
`define _BAR 312
`define _DBAR 313
`define _RBRACE 314
`define _TILDE 315
`define T_AnyChars 316
`define T_BinaryNumber 317
`define T_Decimal_Number 318
`define T_HexNumber 319
`define T_Real_Number 320
`define _IDENT_ 321
`define YYNTOKENS 193
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
  //#line 65 "C.y"
task yyerror(string str);
  $display("error: line %0d: %s at %s\n", yy_mylinenumber, str, string'(yytext)); //'
  $fatal;
endtask

task execerror(string s, string t);   /* recover from run-time error */
  if (s != "") $write(" %s ", s);
    if (t != "") $write(" %s ", t);
    $fatal (1, $psprintf("\nFATAL ERROR: line %0d near \"%s\": exiting!!!\n\n", yy_mylinenumber, string'(yytext))); //'
endtask



  //#line 198 "C.y"
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
      8,    8,    8,    9,    9,    9,    9,   10,   10,   11,
     12,   13,   14,   15,   15,   15,   16,   17,   17,   18,
     18,   19,   20,   20,   20,   21,   21,   21,   22,   22,
     23,   23,   23,   24,   24,   24,   24,   24,   24,   24,
     25,   26,   26,   26,   27,   27,   28,   28,   28,   29,
     29,   30,   30,   30,   30,   30,   30,   31,   31,   32,
     32,   33,   33,   33,   33,   34,   34,   35,   35,   36,
     36,   37,   37,   38,   38,   39,   39,   40,   40,   41,
     41,   42,   42,   43,   43,   44,   44,   45,   45,   45,
     45,   46,   46,   47,   47,   47,   47,   48,  0
  };
  static int  yylen[] = { 2,
      1,    0,    2,    3,    3,    2,    1,    3,    1,    2,
      3,    2,    1,    1,    2,    0,    1,    3,    4,    1,
      1,    2,    4,    4,    6,    4,    4,    4,    4,    4,
      4,    4,    4,    1,    1,    4,    4,    1,    3,    2,
      2,    5,    1,    0,    1,    3,    5,    0,    2,    0,
      2,    7,    5,    9,    2,    0,    1,    2,    0,    1,
      0,    1,    2,    1,    1,    1,    1,    1,    1,    1,
      1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
      1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
      3,    2,    1,    1,    1,    3,    1,    3,    1,    3,
      1,    3,    1,    3,    1,    3,    1,    3,    1,    5,
      1,    2,    1,    0,    3,    1,    3,    1,    1,    1,
      1,    1,    1,    1,    1,    1,    1,    1,  0
  };
  static int  yydefred[] = { 2,
      0,    0,   20,   21,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    2,    0,    3,    0,
      0,    0,    0,   13,   14,    7,    9,    0,    0,   55,
      0,   41,    0,    0,   40,    0,  120,    0,  118,  119,
      0,    0,    0,    0,    0,    0,  121,  125,  124,  126,
    127,    0,   94,   93,   22,   95,    0,   99,    0,    0,
      0,    0,  109,    0,    0,   90,    0,  113,    0,    0,
      0,    0,    0,    0,  122,  123,    0,    0,    0,    6,
     10,   15,   12,    0,    0,    0,   57,    0,    0,    0,
      0,    0,  128,    0,    0,    0,   35,    0,    0,    0,
      0,    0,    0,    0,    0,  112,   71,    0,   74,   72,
     73,    0,   75,   76,    0,   77,   78,   79,    0,   87,
     82,   81,   83,   86,   84,   85,   80,    0,    0,   88,
     89,    0,    0,    0,   92,    4,    5,    0,    0,   11,
      0,    0,    0,    0,    0,    8,   27,   58,    0,   43,
      0,    0,    0,    0,    0,    0,   24,    0,   91,    0,
      0,    0,    0,    0,    0,   96,   98,    0,    0,    0,
      0,  108,    0,   26,    0,   23,    0,    0,  115,    0,
      0,    0,    0,   48,    0,    0,   39,    0,   29,   33,
     30,   31,   28,   32,    0,   53,   18,    0,    0,   46,
     42,    0,   37,   36,   25,    0,    0,   62,    0,    0,
      0,   49,   52,   63,    0,   51,    0,   54,    0,    0,
     47,  0
  };
  static int  yydgoto[] = { 1,
      2,   19,  141,   20,   21,   53,   23,   54,   94,   95,
     24,   25,   32,  151,  152,  212,  202,  213,   26,   27,
     88,   55,  209,    0,  108,  112,  115,  119,  128,  129,
    132,   56,   57,   58,   59,   60,   61,   62,   63,   64,
     65,   66,   78,  144,   67,   79,   68,   97,0 
  };
  static int  yysindex[] = { 0,
      0,  -41,    0,    0, -239, -234,  -41, -270, -179, -178,
   -270, -145, -157, -202, -109,  -96,    0, -156,    0, -152,
   -135, -105, -100,    0,    0,    0,    0, -157, -291,    0,
    -77,    0, -157, -251,    0, -157,    0, -157,    0,    0,
    -67,  -66,  -62,  -61,  -60,  -59,    0,    0,    0,    0,
      0, -243,    0,    0,    0,    0,  -79,    0,  -89,  -76,
   -255, -177,    0, -240,  -74,    0, -230,    0, -102,  -68,
   -157, -157,  276, -157,    0,    0, -157,  -71,  -63,    0,
      0,    0,    0, -249, -107,  -72,    0,  -58, -104, -238,
    -32,  -19,    0,  -46,  -26,  -74,    0, -175, -229, -157,
    -73, -157, -157, -157,  -65,    0,    0, -157,    0,    0,
      0, -157,    0,    0, -157,    0,    0,    0, -157,    0,
      0,    0,    0,    0,    0,    0,    0, -157, -157,    0,
      0, -157, -157,  -72,    0,    0,    0, -222, -221,    0,
    -14, -174,  -93,  -33, -157,    0,    0,    0, -157,    0,
    -11,  -10,  -41, -157, -157, -251,    0, -157,    0, -209,
     -1, -172, -141, -140,    2,    0,    0,  -89,  -76, -255,
    -83,    0, -241,    0,  -41,    0, -157, -157,    0,  -74,
     -3, -104,  -41,    0, -124, -115,    0, -108,    0,    0,
      0,    0,    0,    0, -157,    0,    0,  -74,  -47,    0,
      0, -233,    0,    0,    0, -240, -188,    0,   11,  -41,
     13,    0,    0,    0,  -41,    0, -157,    0,  -98,  -41,
      0, 0 
  };
  static int  yyrindex[] = { 0,
      0,  260,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    3,    0,    0,    0,    0,    4,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    5,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,  -40,    0,    0,    0,    0,   59,    0,  100,  182,
    248, -148,    0, -246,    7,    0,    0,    0,    4,    0,
      0,    0,    0,   14,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    4,    0,    0,   19,    0,
      0,    0,    0,   20,    0, -206,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,  -40,    0,    0,    0,    0,    0,    0,
      0,   21,    8,    0,    0,    0,    0,    0,    3,    0,
     22,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,  141,  223,  275,
    -85,    0,    0,    0,    0,    0,   14,    0,    0, -147,
      0,   19,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    9,   23,    0,
      0,    1,    0,    0,    0, -128,    4,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,0 
  };
  static int  yygindex[] = { 0,
    271,   -5,  113,   -4,    0,   -2,    0,    0,    0,  136,
      0,    0,  285,    0,  118,    0,    0,    0,    0,    0,
      0,  153,    0,    0,    0,    0,    0,    0,    0,    0,
      0,  238,    0,  -15,  193,  194,  186,  187,  185, -119,
    -25,    0,  -48,    0,    0,  120,    0,  220,0 
  };
`define YYTABLESIZE 597
  int  yytable[] = { 22,
     50,   30,   84,  106,   22,  116,   37,   90,   96,   70,
     98,   38,   99,  173,  147,   39,   85,  111,   40,   74,
    130,  130,  111,   28,   87,  153,  111,  111,   29,   86,
    117,  195,   38,  133,  159,   91,  111,   41,  111,   42,
     77,  174,  175,   43,  133,  138,  139,   92,  142,   44,
     31,  143,   45,  133,  189,   46,  118,   34,  210,  211,
    133,  133,   34,   47,   93,   48,   49,   50,   51,   52,
     22,  131,  131,  133,  160,  206,  162,  163,  164,   75,
    148,  120,   76,   33,   34,  106,   48,   49,   50,   51,
    134,  191,  166,  158,  177,   77,  167,  121,  122,  123,
     37,  124,  125,  126,  127,   38,   74,  133,  133,   39,
    133,   75,   40,  107,   76,  107,   19,   36,   69,  180,
    107,   80,  192,  193,  107,  107,   19,   77,  185,  186,
     96,   41,  188,   42,  107,  110,  107,   43,   81,  203,
    110,  133,  133,   44,  110,  110,   45,  184,  204,   46,
     22,  142,  198,   71,  110,  205,  110,   47,  133,   48,
     49,   50,   51,   52,  107,  220,   72,  133,   82,  196,
    109,  136,   22,   83,  133,  110,  106,  201,  106,  178,
     22,   77,  111,  106,  133,   89,  107,  106,  106,  133,
    113,  219,  122,  114,  208,  100,  101,  106,  127,  106,
    102,  103,  104,  105,  216,  137,  145,   22,  133,  218,
    146,   77,   22,   86,  221,  149,  150,   22,  114,  114,
    114,  114,  156,  114,  114,  114,  114,  106,  114,  114,
    154,  114,  114,  114,  114,  114,  114,  157,  114,  114,
    114,  114,  114,  155,  114,  114,    3,  161,    4,  176,
     93,  179,    5,  183,    6,    7,    8,  182,    9,    1,
     10,   11,  190,   12,   13,  194,   14,   15,   16,   17,
    199,  114,  114,  207,  215,  217,   59,   16,   56,   18,
     60,  114,   44,   38,   17,   45,   61,   73,   50,  197,
     50,  187,  116,  117,   50,   35,   50,   50,   50,  200,
     50,  181,   50,   50,  135,   50,   50,  168,   50,   50,
     50,   50,  169,  170,   50,  171,  172,   97,   97,   97,
     97,   50,   97,   97,  165,   97,  214,   97,   97,    0,
     97,   97,   97,   97,   97,   97,    0,   97,   97,   97,
     97,   97,    0,   97,   97,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,  101,    0,
    101,  101,    0,  101,    0,    0,  101,    0,  101,  101,
     97,   97,  101,  101,  101,  101,  101,    0,  101,  101,
    101,  101,  101,    0,  101,  101,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,  100,
      0,  100,  100,    0,  100,    0,    0,  100,    0,  100,
    100,  101,  101,  100,  100,  100,  100,  100,    0,  100,
    100,  100,  100,  100,    0,  100,  100,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    103,    0,  103,  103,    0,  103,    0,    0,    0,    0,
    103,    0,  100,  100,  103,  103,  103,  103,  103,    0,
    103,  103,  103,  103,  103,    0,  103,  103,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,  102,    0,  102,  102,    0,  102,    0,    0,    0,
      0,  102,    0,  103,  103,  102,  102,  102,  102,  102,
      0,  102,  102,  102,  102,  102,  105,  102,  102,  105,
      0,  105,    0,    0,    0,    0,  105,    0,    0,    0,
    105,  105,  105,  105,  105,    0,  105,  105,  105,  105,
    105,    0,  105,  104,  102,  102,  104,    0,  104,    0,
      0,    0,    0,  104,    0,    0,    0,  104,  104,  104,
    104,  104,    0,  104,  104,  104,  104,  104,    0,  104,
    105,    0,    0,    3,    0,    4,    0,    0,    0,    5,
      0,    6,    7,    8,    0,    9,    0,   10,   11,    0,
     12,   13,    0,   14,   15,   16,   17,  104,    0,  140,
      0,    0,    0,    0,    0,    0,   18,0 
  };
  int  yycheck[] = { 2,
      0,    7,   28,   52,    7,  261,  258,   33,   34,   14,
     36,  263,   38,  133,  264,  267,  308,  264,  270,  263,
    262,  262,  269,  263,   29,  264,  273,  274,  263,  321,
    286,  273,  263,  283,  264,  287,  283,  289,  285,  291,
    284,  264,  264,  295,  283,   71,   72,  299,   74,  301,
    321,   77,  304,  283,  264,  307,  312,  264,  292,  293,
    283,  283,  269,  315,  316,  317,  318,  319,  320,  321,
     73,  313,  313,  283,  100,  195,  102,  103,  104,  268,
     85,  259,  271,  263,  263,  134,  317,  318,  319,  320,
    321,  264,  108,  269,  269,  284,  112,  275,  276,  277,
    258,  279,  280,  281,  282,  263,  263,  283,  283,  267,
    283,  268,  270,  262,  271,  264,  264,  263,  321,  145,
    269,  274,  264,  264,  273,  274,  274,  284,  154,  155,
    156,  289,  158,  291,  283,  264,  285,  295,  274,  264,
    269,  283,  283,  301,  273,  274,  304,  153,  264,  307,
    153,  177,  178,  263,  283,  264,  285,  315,  283,  317,
    318,  319,  320,  321,  313,  264,  263,  283,  274,  175,
    260,  274,  175,  274,  283,  265,  262,  183,  264,  273,
    183,  284,  272,  269,  283,  263,  266,  273,  274,  283,
    267,  217,  276,  270,  199,  263,  263,  283,  282,  285,
    263,  263,  263,  263,  210,  274,  278,  210,  283,  215,
    274,  284,  215,  321,  220,  274,  321,  220,  259,  260,
    261,  262,  269,  264,  265,  266,  267,  313,  269,  270,
    263,  272,  273,  274,  275,  276,  277,  264,  279,  280,
    281,  282,  283,  263,  285,  286,  288,  321,  290,  264,
    316,  285,  294,  264,  296,  297,  298,  269,  300,    0,
    302,  303,  264,  305,  306,  264,  308,  309,  310,  311,
    274,  312,  313,  321,  264,  263,  274,  264,  274,  321,
    274,  278,  264,  264,  264,  264,  264,   17,  288,  177,
    290,  156,  285,  285,  294,   11,  296,  297,  298,  182,
    300,  149,  302,  303,   67,  305,  306,  115,  308,  309,
    310,  311,  119,  128,  314,  129,  132,  259,  260,  261,
    262,  321,  264,  265,  105,  267,  207,  269,  270,   -1,
    272,  273,  274,  275,  276,  277,   -1,  279,  280,  281,
    282,  283,   -1,  285,  286,   -1,   -1,   -1,   -1,   -1,
     -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  259,   -1,
    261,  262,   -1,  264,   -1,   -1,  267,   -1,  269,  270,
    312,  313,  273,  274,  275,  276,  277,   -1,  279,  280,
    281,  282,  283,   -1,  285,  286,   -1,   -1,   -1,   -1,
     -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  259,
     -1,  261,  262,   -1,  264,   -1,   -1,  267,   -1,  269,
    270,  312,  313,  273,  274,  275,  276,  277,   -1,  279,
    280,  281,  282,  283,   -1,  285,  286,   -1,   -1,   -1,
     -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
    259,   -1,  261,  262,   -1,  264,   -1,   -1,   -1,   -1,
    269,   -1,  312,  313,  273,  274,  275,  276,  277,   -1,
    279,  280,  281,  282,  283,   -1,  285,  286,   -1,   -1,
     -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
     -1,  259,   -1,  261,  262,   -1,  264,   -1,   -1,   -1,
     -1,  269,   -1,  312,  313,  273,  274,  275,  276,  277,
     -1,  279,  280,  281,  282,  283,  259,  285,  286,  262,
     -1,  264,   -1,   -1,   -1,   -1,  269,   -1,   -1,   -1,
    273,  274,  275,  276,  277,   -1,  279,  280,  281,  282,
    283,   -1,  285,  259,  312,  313,  262,   -1,  264,   -1,
     -1,   -1,   -1,  269,   -1,   -1,   -1,  273,  274,  275,
    276,  277,   -1,  279,  280,  281,  282,  283,   -1,  285,
    313,   -1,   -1,  288,   -1,  290,   -1,   -1,   -1,  294,
     -1,  296,  297,  298,   -1,  300,   -1,  302,  303,   -1,
    305,  306,   -1,  308,  309,  310,  311,  313,   -1,  314,
     -1,   -1,   -1,   -1,   -1,   -1,  321,0 
  };
`define YYFINAL 1
`ifndef YYDEBUG
`define YYDEBUG 0
`endif
`define YYMAXTOKEN 321
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
  "_KW_floor","_KW_for","_KW_forever","_KW_function","_KW_hex","_KW_if",
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
    "Builtin_Task : _KW_regwr _LPAREN Expr _COMMA Expr _RPAREN",
    "Builtin_Task : _KW_wait _LPAREN Expr _RPAREN",
    "Builtin_Task : _KW_fatal _LPAREN Expr _RPAREN",
    "Builtin_Fn : _KW_regrd _LPAREN Expr _RPAREN",
    "Builtin_Fn : _KW_ceil _LPAREN Expr _RPAREN",
    "Builtin_Fn : _KW_floor _LPAREN Expr _RPAREN",
    "Builtin_Fn : _KW_log2 _LPAREN Expr _RPAREN",
    "Builtin_Fn : _KW_sys _LPAREN String_Literal _RPAREN",
    "Builtin_Fn : _KW_defined _LPAREN _IDENT_ _RPAREN",
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
      1:  //#line 202 "C.y"
      begin
          yyval.program_ = Program1::new (valstk[0].liststmt_item_); yyval.program_.line_number = yy_mylinenumber;YY_RESULT_Program_ = yyval.program_; 
      end
      2:  //#line 204 "C.y"
      begin
          yyval.liststmt_item_ = ListStmt_Item::new(); 
      end
      3:  //#line 205 "C.y"
      begin
          valstk[1].liststmt_item_.v.push_back(valstk[0].stmt_item_); yyval.liststmt_item_ = valstk[1].liststmt_item_; 
      end
      4:  //#line 207 "C.y"
      begin
          yyval.stmt_item_ = VarDeclStmt::new (valstk[1]._string); yyval.stmt_item_.line_number = yy_mylinenumber; 
      end
      5:  //#line 208 "C.y"
      begin
          yyval.stmt_item_ = VarAssDeclStmt::new (valstk[1].var_assignment_); yyval.stmt_item_.line_number = yy_mylinenumber; 
      end
      6:  //#line 209 "C.y"
      begin
          yyval.stmt_item_ = AssignmentStmt::new (valstk[1].var_assignment_); yyval.stmt_item_.line_number = yy_mylinenumber; 
      end
      7:  //#line 210 "C.y"
      begin
          yyval.stmt_item_ = ConditionalStmt::new (valstk[0].conditional_stmt_); yyval.stmt_item_.line_number = yy_mylinenumber; 
      end
      8:  //#line 211 "C.y"
      begin
          yyval.stmt_item_ = IncDecOpStmt::new (valstk[2]._string, valstk[1].inc_or_dec_operator_); yyval.stmt_item_.line_number = yy_mylinenumber; 
      end
      9:  //#line 212 "C.y"
      begin
          yyval.stmt_item_ = LoopStmt::new (valstk[0].loop_stmt_); yyval.stmt_item_.line_number = yy_mylinenumber; 
      end
      10:  //#line 213 "C.y"
      begin
          yyval.stmt_item_ = JumpStmt::new (valstk[1].jump_stmt_); yyval.stmt_item_.line_number = yy_mylinenumber; 
      end
      11:  //#line 214 "C.y"
      begin
          yyval.stmt_item_ = BlockStmt::new (valstk[1].liststmt_item_); yyval.stmt_item_.line_number = yy_mylinenumber; 
      end
      12:  //#line 215 "C.y"
      begin
          yyval.stmt_item_ = BuiltInStmt::new (valstk[1].builtin_task_); yyval.stmt_item_.line_number = yy_mylinenumber; 
      end
      13:  //#line 216 "C.y"
      begin
          yyval.stmt_item_ = ProcDefStmt::new (valstk[0].proc_definition_); yyval.stmt_item_.line_number = yy_mylinenumber; 
      end
      14:  //#line 217 "C.y"
      begin
          yyval.stmt_item_ = FuncDefStmt::new (valstk[0].func_definition_); yyval.stmt_item_.line_number = yy_mylinenumber; 
      end
      15:  //#line 218 "C.y"
      begin
          yyval.stmt_item_ = ProcCallStmt::new (valstk[1].funcorproccall_); yyval.stmt_item_.line_number = yy_mylinenumber; 
      end
      16:  //#line 220 "C.y"
      begin
          yyval.listexpr_ = ListExpr::new(); 
      end
      17:  //#line 221 "C.y"
      begin
          yyval.listexpr_ = ListExpr::new(); yyval.listexpr_.v.push_back(valstk[0].expr_); 
      end
      18:  //#line 222 "C.y"
      begin
          valstk[0].listexpr_.v.push_back(valstk[2].expr_); yyval.listexpr_ = valstk[0].listexpr_; 
      end
      19:  //#line 224 "C.y"
      begin
          yyval.var_assignment_ = Assignment::new (valstk[3]._string, valstk[2].range_expr_opt_, valstk[0].expr_); yyval.var_assignment_.line_number = yy_mylinenumber; 
      end
      20:  //#line 226 "C.y"
      begin
          yyval.jump_stmt_ = Break::new (); yyval.jump_stmt_.line_number = yy_mylinenumber; 
      end
      21:  //#line 227 "C.y"
      begin
          yyval.jump_stmt_ = Continue::new (); yyval.jump_stmt_.line_number = yy_mylinenumber; 
      end
      22:  //#line 228 "C.y"
      begin
          yyval.jump_stmt_ = Return::new (valstk[0].expr_opt_); yyval.jump_stmt_.line_number = yy_mylinenumber; 
      end
      23:  //#line 230 "C.y"
      begin
          valstk[1].listexpr_.v.reverse ;yyval.funcorproccall_ = Call::new (valstk[3]._string, valstk[1].listexpr_); yyval.funcorproccall_.line_number = yy_mylinenumber; 
      end
      24:  //#line 232 "C.y"
      begin
          valstk[1].listprint_arg_.v.reverse ;yyval.builtin_task_ = Print::new (valstk[1].listprint_arg_); yyval.builtin_task_.line_number = yy_mylinenumber; 
      end
      25:  //#line 233 "C.y"
      begin
          yyval.builtin_task_ = RegWr::new (valstk[3].expr_, valstk[1].expr_); yyval.builtin_task_.line_number = yy_mylinenumber; 
      end
      26:  //#line 234 "C.y"
      begin
          yyval.builtin_task_ = Wait::new (valstk[1].expr_); yyval.builtin_task_.line_number = yy_mylinenumber; 
      end
      27:  //#line 235 "C.y"
      begin
          yyval.builtin_task_ = Fatal::new (valstk[1].expr_); yyval.builtin_task_.line_number = yy_mylinenumber; 
      end
      28:  //#line 237 "C.y"
      begin
          yyval.builtin_fn_ = RegRd::new (valstk[1].expr_); yyval.builtin_fn_.line_number = yy_mylinenumber; 
      end
      29:  //#line 238 "C.y"
      begin
          yyval.builtin_fn_ = Ceil::new (valstk[1].expr_); yyval.builtin_fn_.line_number = yy_mylinenumber; 
      end
      30:  //#line 239 "C.y"
      begin
          yyval.builtin_fn_ = Floor::new (valstk[1].expr_); yyval.builtin_fn_.line_number = yy_mylinenumber; 
      end
      31:  //#line 240 "C.y"
      begin
          yyval.builtin_fn_ = Log2::new (valstk[1].expr_); yyval.builtin_fn_.line_number = yy_mylinenumber; 
      end
      32:  //#line 241 "C.y"
      begin
          yyval.builtin_fn_ = Sys::new (valstk[1].string_literal_); yyval.builtin_fn_.line_number = yy_mylinenumber; 
      end
      33:  //#line 242 "C.y"
      begin
          yyval.builtin_fn_ = IsDefd::new (valstk[1]._string); yyval.builtin_fn_.line_number = yy_mylinenumber; 
      end
      34:  //#line 244 "C.y"
      begin
          yyval.print_arg_ = PrExpr::new (valstk[0].expr_); yyval.print_arg_.line_number = yy_mylinenumber; 
      end
      35:  //#line 245 "C.y"
      begin
          yyval.print_arg_ = PrString::new (valstk[0].string_literal_); yyval.print_arg_.line_number = yy_mylinenumber; 
      end
      36:  //#line 246 "C.y"
      begin
          yyval.print_arg_ = PrHex::new (valstk[1].expr_); yyval.print_arg_.line_number = yy_mylinenumber; 
      end
      37:  //#line 247 "C.y"
      begin
          yyval.print_arg_ = PrBin::new (valstk[1].expr_); yyval.print_arg_.line_number = yy_mylinenumber; 
      end
      38:  //#line 249 "C.y"
      begin
          yyval.listprint_arg_ = ListPrint_Arg::new(); yyval.listprint_arg_.v.push_back(valstk[0].print_arg_); 
      end
      39:  //#line 250 "C.y"
      begin
          valstk[0].listprint_arg_.v.push_back(valstk[2].print_arg_); yyval.listprint_arg_ = valstk[0].listprint_arg_; 
      end
      40:  //#line 252 "C.y"
      begin
          yyval.proc_definition_ = ProcDef::new (valstk[0].definition_); yyval.proc_definition_.line_number = yy_mylinenumber; 
      end
      41:  //#line 254 "C.y"
      begin
          yyval.func_definition_ = FuncDef::new (valstk[0].definition_); yyval.func_definition_.line_number = yy_mylinenumber; 
      end
      42:  //#line 256 "C.y"
      begin
          valstk[2].listformal_arg_.v.reverse ;yyval.definition_ = Defn::new (valstk[4]._string, valstk[2].listformal_arg_, valstk[0].stmt_item_); yyval.definition_.line_number = yy_mylinenumber; 
      end
      43:  //#line 258 "C.y"
      begin
          yyval.formal_arg_ = Formal::new (valstk[0]._string); yyval.formal_arg_.line_number = yy_mylinenumber; 
      end
      44:  //#line 260 "C.y"
      begin
          yyval.listformal_arg_ = ListFormal_Arg::new(); 
      end
      45:  //#line 261 "C.y"
      begin
          yyval.listformal_arg_ = ListFormal_Arg::new(); yyval.listformal_arg_.v.push_back(valstk[0].formal_arg_); 
      end
      46:  //#line 262 "C.y"
      begin
          valstk[0].listformal_arg_.v.push_back(valstk[2].formal_arg_); yyval.listformal_arg_ = valstk[0].listformal_arg_; 
      end
      47:  //#line 264 "C.y"
      begin
          yyval.else_if_ = ElsIf::new (valstk[2].expr_, valstk[0].stmt_item_); yyval.else_if_.line_number = yy_mylinenumber; 
      end
      48:  //#line 266 "C.y"
      begin
          yyval.listelse_if_ = ListElse_If::new(); 
      end
      49:  //#line 267 "C.y"
      begin
          valstk[1].listelse_if_.v.push_back(valstk[0].else_if_); yyval.listelse_if_ = valstk[1].listelse_if_; 
      end
      50:  //#line 269 "C.y"
      begin
          yyval.else_opt_ = ElseIsEmpty::new (); yyval.else_opt_.line_number = yy_mylinenumber; 
      end
      51:  //#line 270 "C.y"
      begin
          yyval.else_opt_ = ElseIsElse::new (valstk[0].stmt_item_); yyval.else_opt_.line_number = yy_mylinenumber; 
      end
      52:  //#line 272 "C.y"
      begin
          yyval.conditional_stmt_ = If::new (valstk[4].expr_, valstk[2].stmt_item_, valstk[1].listelse_if_, valstk[0].else_opt_); yyval.conditional_stmt_.line_number = yy_mylinenumber; 
      end
      53:  //#line 274 "C.y"
      begin
          yyval.loop_stmt_ = While::new (valstk[2].expr_, valstk[0].stmt_item_); yyval.loop_stmt_.line_number = yy_mylinenumber; 
      end
      54:  //#line 275 "C.y"
      begin
          yyval.loop_stmt_ = For::new (valstk[6].for_init_opt_, valstk[4].expr_opt_, valstk[2].for_step_opt_, valstk[0].stmt_item_); yyval.loop_stmt_.line_number = yy_mylinenumber; 
      end
      55:  //#line 276 "C.y"
      begin
          yyval.loop_stmt_ = forever__(valstk[0].stmt_item_); 
      end
      56:  //#line 278 "C.y"
      begin
          yyval.for_init_opt_ = ForInitIsEmpty::new (); yyval.for_init_opt_.line_number = yy_mylinenumber; 
      end
      57:  //#line 279 "C.y"
      begin
          yyval.for_init_opt_ = ForInitIsInit::new (valstk[0].var_assignment_); yyval.for_init_opt_.line_number = yy_mylinenumber; 
      end
      58:  //#line 280 "C.y"
      begin
          yyval.for_init_opt_ = ForInitIsVarInit::new (valstk[0].var_assignment_); yyval.for_init_opt_.line_number = yy_mylinenumber; 
      end
      59:  //#line 282 "C.y"
      begin
          yyval.expr_opt_ = ExprIsEmpty::new (); yyval.expr_opt_.line_number = yy_mylinenumber; 
      end
      60:  //#line 283 "C.y"
      begin
          yyval.expr_opt_ = ExprIsExpr::new (valstk[0].expr_); yyval.expr_opt_.line_number = yy_mylinenumber; 
      end
      61:  //#line 285 "C.y"
      begin
          yyval.for_step_opt_ = ForStepIsEmpty::new (); yyval.for_step_opt_.line_number = yy_mylinenumber; 
      end
      62:  //#line 286 "C.y"
      begin
          yyval.for_step_opt_ = ForStepIsAssignment::new (valstk[0].var_assignment_); yyval.for_step_opt_.line_number = yy_mylinenumber; 
      end
      63:  //#line 287 "C.y"
      begin
          yyval.for_step_opt_ = ForStepIsIncOrDec::new (valstk[1]._string, valstk[0].inc_or_dec_operator_); yyval.for_step_opt_.line_number = yy_mylinenumber; 
      end
      64:  //#line 289 "C.y"
      begin
          yyval.op_ = valstk[0].op_; yyval.op_.line_number = yy_mylinenumber; 
      end
      65:  //#line 290 "C.y"
      begin
          yyval.op_ = valstk[0].op_; yyval.op_.line_number = yy_mylinenumber; 
      end
      66:  //#line 291 "C.y"
      begin
          yyval.op_ = valstk[0].op_; yyval.op_.line_number = yy_mylinenumber; 
      end
      67:  //#line 292 "C.y"
      begin
          yyval.op_ = valstk[0].op_; yyval.op_.line_number = yy_mylinenumber; 
      end
      68:  //#line 293 "C.y"
      begin
          yyval.op_ = valstk[0].op_; yyval.op_.line_number = yy_mylinenumber; 
      end
      69:  //#line 294 "C.y"
      begin
          yyval.op_ = valstk[0].op_; yyval.op_.line_number = yy_mylinenumber; 
      end
      70:  //#line 295 "C.y"
      begin
          yyval.op_ = valstk[0].op_; yyval.op_.line_number = yy_mylinenumber; 
      end
      71:  //#line 297 "C.y"
      begin
          yyval.op_ = Pow::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      72:  //#line 299 "C.y"
      begin
          yyval.op_ = Mul::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      73:  //#line 300 "C.y"
      begin
          yyval.op_ = Div::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      74:  //#line 301 "C.y"
      begin
          yyval.op_ = Mod::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      75:  //#line 303 "C.y"
      begin
          yyval.op_ = Add::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      76:  //#line 304 "C.y"
      begin
          yyval.op_ = Sub::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      77:  //#line 306 "C.y"
      begin
          yyval.op_ = LAnd::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      78:  //#line 307 "C.y"
      begin
          yyval.op_ = Xor::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      79:  //#line 308 "C.y"
      begin
          yyval.op_ = LOr::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      80:  //#line 310 "C.y"
      begin
          yyval.op_ = Rsh::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      81:  //#line 311 "C.y"
      begin
          yyval.op_ = Lsh::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      82:  //#line 313 "C.y"
      begin
          yyval.op_ = Lt::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      83:  //#line 314 "C.y"
      begin
          yyval.op_ = Leq::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      84:  //#line 315 "C.y"
      begin
          yyval.op_ = Gt::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      85:  //#line 316 "C.y"
      begin
          yyval.op_ = Geq::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      86:  //#line 317 "C.y"
      begin
          yyval.op_ = Eq::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      87:  //#line 318 "C.y"
      begin
          yyval.op_ = Neq::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      88:  //#line 320 "C.y"
      begin
          yyval.op_ = And::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      89:  //#line 321 "C.y"
      begin
          yyval.op_ = Or::new (); yyval.op_.line_number = yy_mylinenumber; 
      end
      90:  //#line 323 "C.y"
      begin
          yyval.expr_ = ExprPrim::new (valstk[0].primary_); yyval.expr_.line_number = yy_mylinenumber; 
      end
      91:  //#line 324 "C.y"
      begin
          yyval.expr_ = valstk[1].expr_; yyval.expr_.line_number = yy_mylinenumber; 
      end
      92:  //#line 326 "C.y"
      begin
          yyval.expr_ = ExprUnary::new (valstk[1].unary_operator_, valstk[0].expr_); yyval.expr_.line_number = yy_mylinenumber; 
      end
      93:  //#line 327 "C.y"
      begin
          yyval.expr_ = ExprBltin::new (valstk[0].builtin_fn_); yyval.expr_.line_number = yy_mylinenumber; 
      end
      94:  //#line 328 "C.y"
      begin
          yyval.expr_ = ExprFuncCall::new (valstk[0].funcorproccall_); yyval.expr_.line_number = yy_mylinenumber; 
      end
      95:  //#line 329 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; yyval.expr_.line_number = yy_mylinenumber; 
      end
      96:  //#line 331 "C.y"
      begin
          yyval.expr_ = op_(valstk[2].expr_, valstk[1].op_, valstk[0].expr_); 
      end
      97:  //#line 332 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; yyval.expr_.line_number = yy_mylinenumber; 
      end
      98:  //#line 334 "C.y"
      begin
          yyval.expr_ = op_(valstk[2].expr_, valstk[1].op_, valstk[0].expr_); 
      end
      99:  //#line 335 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; yyval.expr_.line_number = yy_mylinenumber; 
      end
      100:  //#line 337 "C.y"
      begin
          yyval.expr_ = op_(valstk[2].expr_, valstk[1].op_, valstk[0].expr_); 
      end
      101:  //#line 338 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; yyval.expr_.line_number = yy_mylinenumber; 
      end
      102:  //#line 340 "C.y"
      begin
          yyval.expr_ = op_(valstk[2].expr_, valstk[1].op_, valstk[0].expr_); 
      end
      103:  //#line 341 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; yyval.expr_.line_number = yy_mylinenumber; 
      end
      104:  //#line 343 "C.y"
      begin
          yyval.expr_ = op_(valstk[2].expr_, valstk[1].op_, valstk[0].expr_); 
      end
      105:  //#line 344 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; yyval.expr_.line_number = yy_mylinenumber; 
      end
      106:  //#line 346 "C.y"
      begin
          yyval.expr_ = op_(valstk[2].expr_, valstk[1].op_, valstk[0].expr_); 
      end
      107:  //#line 347 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; yyval.expr_.line_number = yy_mylinenumber; 
      end
      108:  //#line 349 "C.y"
      begin
          yyval.expr_ = op_(valstk[2].expr_, valstk[1].op_, valstk[0].expr_); 
      end
      109:  //#line 350 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; yyval.expr_.line_number = yy_mylinenumber; 
      end
      110:  //#line 352 "C.y"
      begin
          yyval.expr_ = ExprTernary::new (valstk[4].expr_, valstk[2].expr_, valstk[0].expr_); yyval.expr_.line_number = yy_mylinenumber; 
      end
      111:  //#line 353 "C.y"
      begin
          yyval.expr_ = valstk[0].expr_; yyval.expr_.line_number = yy_mylinenumber; 
      end
      112:  //#line 355 "C.y"
      begin
          yyval.primary_ = PrimIdent::new (valstk[1]._string, valstk[0].range_expr_opt_); yyval.primary_.line_number = yy_mylinenumber; 
      end
      113:  //#line 356 "C.y"
      begin
          yyval.primary_ = PrimNumber::new (valstk[0].number_); yyval.primary_.line_number = yy_mylinenumber; 
      end
      114:  //#line 358 "C.y"
      begin
          yyval.range_expr_opt_ = RangeExprIsEmpty::new (); yyval.range_expr_opt_.line_number = yy_mylinenumber; 
      end
      115:  //#line 359 "C.y"
      begin
          yyval.range_expr_opt_ = RangeExprIsRange::new (valstk[1].range_expr_); yyval.range_expr_opt_.line_number = yy_mylinenumber; 
      end
      116:  //#line 361 "C.y"
      begin
          yyval.range_expr_ = RangeExprBit::new (valstk[0].expr_); yyval.range_expr_.line_number = yy_mylinenumber; 
      end
      117:  //#line 362 "C.y"
      begin
          yyval.range_expr_ = RangeExprRange::new (valstk[2].expr_, valstk[0].expr_); yyval.range_expr_.line_number = yy_mylinenumber; 
      end
      118:  //#line 364 "C.y"
      begin
          yyval.unary_operator_ = UnaryPlus::new (); yyval.unary_operator_.line_number = yy_mylinenumber; 
      end
      119:  //#line 365 "C.y"
      begin
          yyval.unary_operator_ = UnaryMinus::new (); yyval.unary_operator_.line_number = yy_mylinenumber; 
      end
      120:  //#line 366 "C.y"
      begin
          yyval.unary_operator_ = UnaryNot::new (); yyval.unary_operator_.line_number = yy_mylinenumber; 
      end
      121:  //#line 367 "C.y"
      begin
          yyval.unary_operator_ = UnaryComp::new (); yyval.unary_operator_.line_number = yy_mylinenumber; 
      end
      122:  //#line 369 "C.y"
      begin
          yyval.inc_or_dec_operator_ = Incr::new (); yyval.inc_or_dec_operator_.line_number = yy_mylinenumber; 
      end
      123:  //#line 370 "C.y"
      begin
          yyval.inc_or_dec_operator_ = Decr::new (); yyval.inc_or_dec_operator_.line_number = yy_mylinenumber; 
      end
      124:  //#line 372 "C.y"
      begin
          yyval.number_ = Decimal::new (valstk[0]._string); yyval.number_.line_number = yy_mylinenumber; 
      end
      125:  //#line 373 "C.y"
      begin
          yyval.number_ = Binary::new (valstk[0]._string); yyval.number_.line_number = yy_mylinenumber; 
      end
      126:  //#line 374 "C.y"
      begin
          yyval.number_ = Hex::new (valstk[0]._string); yyval.number_.line_number = yy_mylinenumber; 
      end
      127:  //#line 375 "C.y"
      begin
          yyval.number_ = Real::new (valstk[0]._string); yyval.number_.line_number = yy_mylinenumber; 
      end
      128:  //#line 377 "C.y"
      begin
          yyval.string_literal_ = StringLit::new (valstk[0]._string); yyval.string_literal_.line_number = yy_mylinenumber; 
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
  

  //#line 381 "C.y"


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
function Program psProgram(string str);
  b = Bopens(str);
  yy_mylinenumber = 1;
  initialize_lexer(0);
  if (yyparse())
    return null; /* Failure */
  else
    return YY_RESULT_Program_;/* Success */
endfunction



