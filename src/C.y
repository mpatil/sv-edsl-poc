/* -*- sv -*- File generated by the BNF Converter (bnfc 2.9.6). */

/*************************************************/
%{
`include "Absyn.svh"
`include "bio.svh"
`include "Lexer.svh"

Biobuf b;

typedef struct { int i; } YY_BUFFER_STATE;

function int yywrap();
  return 1;
endfunction


static Program  YY_RESULT_Program_ = null;


%}

%union
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
}

%{
task yyerror(string str);
  $display("error: line %0d: %s at %s\n", yy_mylinenumber, str, string'(yytext)); //'
  $fatal;
endtask

task execerror(string s, string t);   /* recover from run-time error */
  if (s != "") $write(" %s ", s);
    if (t != "") $write(" %s ", t);
    $fatal (1, $psprintf("\nFATAL ERROR: line %0d near \"%s\": exiting!!!\n\n", yy_mylinenumber, string'(yytext))); //'
endtask



%}

%token          _ERROR_
%token          _BANG             /* ! */
%token          _BANGEQ           /* != */
%token          _PERCENT          /* % */
%token          _AMP              /* & */
%token          _DAMP             /* && */
%token          _LPAREN           /* ( */
%token          _RPAREN           /* ) */
%token          _STAR             /* * */
%token          _DSTAR            /* ** */
%token          _PLUS             /* + */
%token          _DPLUS            /* ++ */
%token          _COMMA            /* , */
%token          _MINUS            /* - */
%token          _DMINUS           /* -- */
%token          _SLASH            /* / */
%token          _COLON            /* : */
%token          _SEMI             /* ; */
%token          _LT               /* < */
%token          _DLT              /* << */
%token          _LDARROW          /* <= */
%token          _EQ               /* = */
%token          _DEQ              /* == */
%token          _GT               /* > */
%token          _GTEQ             /* >= */
%token          _DGT              /* >> */
%token          _QUESTION         /* ? */
%token          _LBRACK           /* [ */
%token          _RBRACK           /* ] */
%token          _CARET            /* ^ */
%token          _KW_bin           /* bin */
%token          _KW_break         /* break */
%token          _KW_ceil          /* ceil */
%token          _KW_continue      /* continue */
%token          _KW_defined       /* defined */
%token          _KW_else          /* else */
%token          _KW_elsif         /* elsif */
%token          _KW_fatal         /* fatal */
%token          _KW_floor         /* floor */
%token          _KW_for           /* for */
%token          _KW_forever       /* forever */
%token          _KW_function      /* function */
%token          _KW_hex           /* hex */
%token          _KW_if            /* if */
%token          _KW_log2          /* log2 */
%token          _KW_print         /* print */
%token          _KW_procedure     /* procedure */
%token          _KW_regrd         /* regrd */
%token          _KW_regwr         /* regwr */
%token          _KW_return        /* return */
%token          _KW_sys           /* sys */
%token          _KW_var           /* var */
%token          _KW_wait          /* wait */
%token          _KW_while         /* while */
%token          _LBRACE           /* { */
%token          _BAR              /* | */
%token          _DBAR             /* || */
%token          _RBRACE           /* } */
%token          _TILDE            /* ~ */
%token<_string> T_AnyChars        /* AnyChars */
%token<_string> T_BinaryNumber    /* BinaryNumber */
%token<_string> T_Decimal_Number  /* Decimal_Number */
%token<_string> T_HexNumber       /* HexNumber */
%token<_string> T_Real_Number     /* Real_Number */
%token<_string> _IDENT_

%type <program_> Program
%type <liststmt_item_> ListStmt_Item
%type <stmt_item_> Stmt_Item
%type <listexpr_> ListExpr
%type <var_assignment_> Var_Assignment
%type <jump_stmt_> Jump_Stmt
%type <funcorproccall_> FuncOrProcCall
%type <builtin_task_> Builtin_Task
%type <builtin_fn_> Builtin_Fn
%type <print_arg_> Print_Arg
%type <listprint_arg_> ListPrint_Arg
%type <proc_definition_> Proc_Definition
%type <func_definition_> Func_Definition
%type <definition_> Definition
%type <formal_arg_> Formal_Arg
%type <listformal_arg_> ListFormal_Arg
%type <else_if_> Else_If
%type <listelse_if_> ListElse_If
%type <else_opt_> Else_Opt
%type <conditional_stmt_> Conditional_Stmt
%type <loop_stmt_> Loop_Stmt
%type <for_init_opt_> For_Init_Opt
%type <expr_opt_> Expr_Opt
%type <for_step_opt_> For_Step_Opt
%type <op_> Op
%type <op_> Op7
%type <op_> Op6
%type <op_> Op5
%type <op_> Op4
%type <op_> Op3
%type <op_> Op2
%type <op_> Op1
%type <expr_> Expr9
%type <expr_> Expr8
%type <expr_> Expr7
%type <expr_> Expr6
%type <expr_> Expr5
%type <expr_> Expr4
%type <expr_> Expr3
%type <expr_> Expr2
%type <expr_> Expr1
%type <expr_> Expr
%type <primary_> Primary
%type <range_expr_opt_> Range_Expr_Opt
%type <range_expr_> Range_Expr
%type <unary_operator_> Unary_Operator
%type <inc_or_dec_operator_> Inc_Or_Dec_Operator
%type <number_> Number
%type <string_literal_> String_Literal

%start Program
%{
//`include "Lexer.svh"
%}

%%
Program : ListStmt_Item {  $$ = Program1::new ($1); $$.line_number = yy_mylinenumber;YY_RESULT_Program_ = $$; }
;
ListStmt_Item : /* empty */ {  $$ = ListStmt_Item::new(); }
  | ListStmt_Item Stmt_Item {  $1.v.push_back($2); $$ = $1; }
;
Stmt_Item : _KW_var _IDENT_ _SEMI {  $$ = VarDeclStmt::new ($2); $$.line_number = yy_mylinenumber; }
  | _KW_var Var_Assignment _SEMI {  $$ = VarAssDeclStmt::new ($2); $$.line_number = yy_mylinenumber; }
  | Var_Assignment _SEMI {  $$ = AssignmentStmt::new ($1); $$.line_number = yy_mylinenumber; }
  | Conditional_Stmt {  $$ = ConditionalStmt::new ($1); $$.line_number = yy_mylinenumber; }
  | _IDENT_ Inc_Or_Dec_Operator _SEMI {  $$ = IncDecOpStmt::new ($1, $2); $$.line_number = yy_mylinenumber; }
  | Loop_Stmt {  $$ = LoopStmt::new ($1); $$.line_number = yy_mylinenumber; }
  | Jump_Stmt _SEMI {  $$ = JumpStmt::new ($1); $$.line_number = yy_mylinenumber; }
  | _LBRACE ListStmt_Item _RBRACE {  $$ = BlockStmt::new ($2); $$.line_number = yy_mylinenumber; }
  | Builtin_Task _SEMI {  $$ = BuiltInStmt::new ($1); $$.line_number = yy_mylinenumber; }
  | Proc_Definition {  $$ = ProcDefStmt::new ($1); $$.line_number = yy_mylinenumber; }
  | Func_Definition {  $$ = FuncDefStmt::new ($1); $$.line_number = yy_mylinenumber; }
  | FuncOrProcCall _SEMI {  $$ = ProcCallStmt::new ($1); $$.line_number = yy_mylinenumber; }
;
ListExpr : /* empty */ {  $$ = ListExpr::new(); }
  | Expr {  $$ = ListExpr::new(); $$.v.push_back($1); }
  | Expr _COMMA ListExpr {  $3.v.push_back($1); $$ = $3; }
;
Var_Assignment : _IDENT_ Range_Expr_Opt _EQ Expr {  $$ = Assignment::new ($1, $2, $4); $$.line_number = yy_mylinenumber; }
;
Jump_Stmt : _KW_break {  $$ = Break::new (); $$.line_number = yy_mylinenumber; }
  | _KW_continue {  $$ = Continue::new (); $$.line_number = yy_mylinenumber; }
  | _KW_return Expr_Opt {  $$ = Return::new ($2); $$.line_number = yy_mylinenumber; }
;
FuncOrProcCall : _IDENT_ _LPAREN ListExpr _RPAREN {  $3.v.reverse ;$$ = Call::new ($1, $3); $$.line_number = yy_mylinenumber; }
;
Builtin_Task : _KW_print _LPAREN ListPrint_Arg _RPAREN {  $3.v.reverse ;$$ = Print::new ($3); $$.line_number = yy_mylinenumber; }
  | _KW_regwr _LPAREN Expr _COMMA Expr _RPAREN {  $$ = RegWr::new ($3, $5); $$.line_number = yy_mylinenumber; }
  | _KW_wait _LPAREN Expr _RPAREN {  $$ = Wait::new ($3); $$.line_number = yy_mylinenumber; }
  | _KW_fatal _LPAREN Expr _RPAREN {  $$ = Fatal::new ($3); $$.line_number = yy_mylinenumber; }
;
Builtin_Fn : _KW_regrd _LPAREN Expr _RPAREN {  $$ = RegRd::new ($3); $$.line_number = yy_mylinenumber; }
  | _KW_ceil _LPAREN Expr _RPAREN {  $$ = Ceil::new ($3); $$.line_number = yy_mylinenumber; }
  | _KW_floor _LPAREN Expr _RPAREN {  $$ = Floor::new ($3); $$.line_number = yy_mylinenumber; }
  | _KW_log2 _LPAREN Expr _RPAREN {  $$ = Log2::new ($3); $$.line_number = yy_mylinenumber; }
  | _KW_sys _LPAREN String_Literal _RPAREN {  $$ = Sys::new ($3); $$.line_number = yy_mylinenumber; }
  | _KW_defined _LPAREN _IDENT_ _RPAREN {  $$ = IsDefd::new ($3); $$.line_number = yy_mylinenumber; }
;
Print_Arg : Expr {  $$ = PrExpr::new ($1); $$.line_number = yy_mylinenumber; }
  | String_Literal {  $$ = PrString::new ($1); $$.line_number = yy_mylinenumber; }
  | _KW_hex _LPAREN Expr _RPAREN {  $$ = PrHex::new ($3); $$.line_number = yy_mylinenumber; }
  | _KW_bin _LPAREN Expr _RPAREN {  $$ = PrBin::new ($3); $$.line_number = yy_mylinenumber; }
;
ListPrint_Arg : Print_Arg {  $$ = ListPrint_Arg::new(); $$.v.push_back($1); }
  | Print_Arg _COMMA ListPrint_Arg {  $3.v.push_back($1); $$ = $3; }
;
Proc_Definition : _KW_procedure Definition {  $$ = ProcDef::new ($2); $$.line_number = yy_mylinenumber; }
;
Func_Definition : _KW_function Definition {  $$ = FuncDef::new ($2); $$.line_number = yy_mylinenumber; }
;
Definition : _IDENT_ _LPAREN ListFormal_Arg _RPAREN Stmt_Item {  $3.v.reverse ;$$ = Defn::new ($1, $3, $5); $$.line_number = yy_mylinenumber; }
;
Formal_Arg : _IDENT_ {  $$ = Formal::new ($1); $$.line_number = yy_mylinenumber; }
;
ListFormal_Arg : /* empty */ {  $$ = ListFormal_Arg::new(); }
  | Formal_Arg {  $$ = ListFormal_Arg::new(); $$.v.push_back($1); }
  | Formal_Arg _COMMA ListFormal_Arg {  $3.v.push_back($1); $$ = $3; }
;
Else_If : _KW_elsif _LPAREN Expr _RPAREN Stmt_Item {  $$ = ElsIf::new ($3, $5); $$.line_number = yy_mylinenumber; }
;
ListElse_If : /* empty */ {  $$ = ListElse_If::new(); }
  | ListElse_If Else_If {  $1.v.push_back($2); $$ = $1; }
;
Else_Opt : /* empty */ {  $$ = ElseIsEmpty::new (); $$.line_number = yy_mylinenumber; }
  | _KW_else Stmt_Item {  $$ = ElseIsElse::new ($2); $$.line_number = yy_mylinenumber; }
;
Conditional_Stmt : _KW_if _LPAREN Expr _RPAREN Stmt_Item ListElse_If Else_Opt {  $$ = If::new ($3, $5, $6, $7); $$.line_number = yy_mylinenumber; }
;
Loop_Stmt : _KW_while _LPAREN Expr _RPAREN Stmt_Item {  $$ = While::new ($3, $5); $$.line_number = yy_mylinenumber; }
  | _KW_for _LPAREN For_Init_Opt _SEMI Expr_Opt _SEMI For_Step_Opt _RPAREN Stmt_Item {  $$ = For::new ($3, $5, $7, $9); $$.line_number = yy_mylinenumber; }
  | _KW_forever Stmt_Item {  $$ = forever__($2); }
;
For_Init_Opt : /* empty */ {  $$ = ForInitIsEmpty::new (); $$.line_number = yy_mylinenumber; }
  | Var_Assignment {  $$ = ForInitIsInit::new ($1); $$.line_number = yy_mylinenumber; }
  | _KW_var Var_Assignment {  $$ = ForInitIsVarInit::new ($2); $$.line_number = yy_mylinenumber; }
;
Expr_Opt : /* empty */ {  $$ = ExprIsEmpty::new (); $$.line_number = yy_mylinenumber; }
  | Expr {  $$ = ExprIsExpr::new ($1); $$.line_number = yy_mylinenumber; }
;
For_Step_Opt : /* empty */ {  $$ = ForStepIsEmpty::new (); $$.line_number = yy_mylinenumber; }
  | Var_Assignment {  $$ = ForStepIsAssignment::new ($1); $$.line_number = yy_mylinenumber; }
  | _IDENT_ Inc_Or_Dec_Operator {  $$ = ForStepIsIncOrDec::new ($1, $2); $$.line_number = yy_mylinenumber; }
;
Op : Op1 {  $$ = $1; $$.line_number = yy_mylinenumber; }
  | Op2 {  $$ = $1; $$.line_number = yy_mylinenumber; }
  | Op3 {  $$ = $1; $$.line_number = yy_mylinenumber; }
  | Op4 {  $$ = $1; $$.line_number = yy_mylinenumber; }
  | Op5 {  $$ = $1; $$.line_number = yy_mylinenumber; }
  | Op6 {  $$ = $1; $$.line_number = yy_mylinenumber; }
  | Op7 {  $$ = $1; $$.line_number = yy_mylinenumber; }
;
Op7 : _DSTAR {  $$ = Pow::new (); $$.line_number = yy_mylinenumber; }
;
Op6 : _STAR {  $$ = Mul::new (); $$.line_number = yy_mylinenumber; }
  | _SLASH {  $$ = Div::new (); $$.line_number = yy_mylinenumber; }
  | _PERCENT {  $$ = Mod::new (); $$.line_number = yy_mylinenumber; }
;
Op5 : _PLUS {  $$ = Add::new (); $$.line_number = yy_mylinenumber; }
  | _MINUS {  $$ = Sub::new (); $$.line_number = yy_mylinenumber; }
;
Op4 : _AMP {  $$ = LAnd::new (); $$.line_number = yy_mylinenumber; }
  | _CARET {  $$ = Xor::new (); $$.line_number = yy_mylinenumber; }
  | _BAR {  $$ = LOr::new (); $$.line_number = yy_mylinenumber; }
;
Op3 : _DGT {  $$ = Rsh::new (); $$.line_number = yy_mylinenumber; }
  | _DLT {  $$ = Lsh::new (); $$.line_number = yy_mylinenumber; }
;
Op2 : _LT {  $$ = Lt::new (); $$.line_number = yy_mylinenumber; }
  | _LDARROW {  $$ = Leq::new (); $$.line_number = yy_mylinenumber; }
  | _GT {  $$ = Gt::new (); $$.line_number = yy_mylinenumber; }
  | _GTEQ {  $$ = Geq::new (); $$.line_number = yy_mylinenumber; }
  | _DEQ {  $$ = Eq::new (); $$.line_number = yy_mylinenumber; }
  | _BANGEQ {  $$ = Neq::new (); $$.line_number = yy_mylinenumber; }
;
Op1 : _DAMP {  $$ = And::new (); $$.line_number = yy_mylinenumber; }
  | _DBAR {  $$ = Or::new (); $$.line_number = yy_mylinenumber; }
;
Expr9 : Primary {  $$ = ExprPrim::new ($1); $$.line_number = yy_mylinenumber; }
  | _LPAREN Expr _RPAREN {  $$ = $2; $$.line_number = yy_mylinenumber; }
;
Expr8 : Unary_Operator Expr9 {  $$ = ExprUnary::new ($1, $2); $$.line_number = yy_mylinenumber; }
  | Builtin_Fn {  $$ = ExprBltin::new ($1); $$.line_number = yy_mylinenumber; }
  | FuncOrProcCall {  $$ = ExprFuncCall::new ($1); $$.line_number = yy_mylinenumber; }
  | Expr9 {  $$ = $1; $$.line_number = yy_mylinenumber; }
;
Expr7 : Expr8 Op7 Expr7 {  $$ = op_($1, $2, $3); }
  | Expr8 {  $$ = $1; $$.line_number = yy_mylinenumber; }
;
Expr6 : Expr6 Op6 Expr7 {  $$ = op_($1, $2, $3); }
  | Expr7 {  $$ = $1; $$.line_number = yy_mylinenumber; }
;
Expr5 : Expr5 Op5 Expr6 {  $$ = op_($1, $2, $3); }
  | Expr6 {  $$ = $1; $$.line_number = yy_mylinenumber; }
;
Expr4 : Expr4 Op4 Expr5 {  $$ = op_($1, $2, $3); }
  | Expr5 {  $$ = $1; $$.line_number = yy_mylinenumber; }
;
Expr3 : Expr3 Op3 Expr4 {  $$ = op_($1, $2, $3); }
  | Expr4 {  $$ = $1; $$.line_number = yy_mylinenumber; }
;
Expr2 : Expr3 Op2 Expr3 {  $$ = op_($1, $2, $3); }
  | Expr3 {  $$ = $1; $$.line_number = yy_mylinenumber; }
;
Expr1 : Expr1 Op1 Expr2 {  $$ = op_($1, $2, $3); }
  | Expr2 {  $$ = $1; $$.line_number = yy_mylinenumber; }
;
Expr : Expr _QUESTION Expr1 _COLON Expr1 {  $$ = ExprTernary::new ($1, $3, $5); $$.line_number = yy_mylinenumber; }
  | Expr1 {  $$ = $1; $$.line_number = yy_mylinenumber; }
;
Primary : _IDENT_ Range_Expr_Opt {  $$ = PrimIdent::new ($1, $2); $$.line_number = yy_mylinenumber; }
  | Number {  $$ = PrimNumber::new ($1); $$.line_number = yy_mylinenumber; }
;
Range_Expr_Opt : /* empty */ {  $$ = RangeExprIsEmpty::new (); $$.line_number = yy_mylinenumber; }
  | _LBRACK Range_Expr _RBRACK {  $$ = RangeExprIsRange::new ($2); $$.line_number = yy_mylinenumber; }
;
Range_Expr : Expr {  $$ = RangeExprBit::new ($1); $$.line_number = yy_mylinenumber; }
  | Expr _COLON Expr {  $$ = RangeExprRange::new ($1, $3); $$.line_number = yy_mylinenumber; }
;
Unary_Operator : _PLUS {  $$ = UnaryPlus::new (); $$.line_number = yy_mylinenumber; }
  | _MINUS {  $$ = UnaryMinus::new (); $$.line_number = yy_mylinenumber; }
  | _BANG {  $$ = UnaryNot::new (); $$.line_number = yy_mylinenumber; }
  | _TILDE {  $$ = UnaryComp::new (); $$.line_number = yy_mylinenumber; }
;
Inc_Or_Dec_Operator : _DPLUS {  $$ = Incr::new (); $$.line_number = yy_mylinenumber; }
  | _DMINUS {  $$ = Decr::new (); $$.line_number = yy_mylinenumber; }
;
Number : T_Decimal_Number {  $$ = Decimal::new ($1); $$.line_number = yy_mylinenumber; }
  | T_BinaryNumber {  $$ = Binary::new ($1); $$.line_number = yy_mylinenumber; }
  | T_HexNumber {  $$ = Hex::new ($1); $$.line_number = yy_mylinenumber; }
  | T_Real_Number {  $$ = Real::new ($1); $$.line_number = yy_mylinenumber; }
;
String_Literal : T_AnyChars {  $$ = StringLit::new ($1); $$.line_number = yy_mylinenumber; }
;

%%


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



