/* -*- sv -*- File generated by the BNF Converter (bnfc 2.9.6). */

`ifndef C_INTERP_HEADER
`define C_INTERP_HEADER
`include "C/CAbsyn.svh"

typedef enum {VAR, UNDEF, PROC, FUNC, CMD} Type_;
typedef longint unsigned ulongint;
typedef int unsigned uint;

class Interp implements Visitor;
  typedef enum {PLUS, MINUS, NOT, COMP} UnaryOp;
  typedef enum {POW, MUL, DIV, MOD, ADD, SUB, LAND, XOR, LOR, RSH, LSH, LT, LEQ, GT, GEQ, EQ, NEQ, AND, OR} BinaryOp;
  typedef enum {GLOBAL, CURRENT, ALL} Scope;

  int in_loop = 0;
  int in_call = 0;

  Type_ defn_type = PROC;
  Type_ call_type = PROC;

  int break_jump = 0;
  int continue_jump = 0;
  int return_jump = 0;
  int exit_fatal = 0;

  int var_install = 0;

  int scope = -1;

  const int top_scope = 0;

  UnaryOp unary_op = PLUS;
  BinaryOp binary_op = ADD;

  string prstr;

  typedef class NumVal;
  typedef class StrVal;
  typedef class ProcDefn;

  class SymVal;
    static function SymVal create(string type_);
      SymVal p;
      if (type_ == "num") begin $write("getting NumVal\n"); p = NumVal::new(); end
      else if (type_ == "str") p = StrVal::new();
      else if (type_ == "proc") p = ProcDefn::new();
      return p;
    endfunction

    virtual function string get_type ();
      return "undef";
    endfunction

    virtual function string do_print (string prefix = "", string prefix_ = "");
      return {prefix_, prefix, prefix_, "bad"};
    endfunction
  endclass

  class Symbol;
      string name = "";
      Type_ type_ = UNDEF;       /* VAR, UNDEF, PROC, FUNC */
      SymVal u = null;

    function string do_print (string prefix = "", string prefix_ = "");
        if (u)
          return {prefix_, prefix, prefix_, " name: ", u.do_print(name)};
        else
          return {prefix_, prefix, prefix_, " name: ", name};
    endfunction
  endclass

  class NumVal extends SymVal;
    real val = 0; /* if number */

    function string get_type();
        return "num";
    endfunction

    function string do_print (string prefix = "", string prefix_ = "");
        return {prefix_, prefix, prefix_, " numval: ", $sformatf("%f", val), "\n"};
    endfunction
  endclass

  class StrVal extends SymVal;
    string val = ""; /* if string */

    function string get_type ();
        return "str";
    endfunction

    function string do_print (string prefix = "", string prefix_ = "");
        return {prefix_, prefix, prefix_, " string val ", val, "\n"};
    endfunction
  endclass

  class ProcDefn extends SymVal;
    Stmt_Item code; /* if proc */
    string formals[$];

    function string get_type ();
        return "proc";
    endfunction

    function string do_print (string prefix = "", string prefix_ = "");
      return {prefix_, prefix, prefix_, " function ", "\n"};
    endfunction
  endclass

  typedef struct {
    real ival = 0.0;
    string sval = "";
    Symbol sym = null;
  } Datum;

  class Env;
      Datum stack_[$];     /* the stack */
      Symbol symlist[$];   /* symbol table: linked list */

    function string do_symlist_print (string prefix = "", string prefix_ = "");
      string str =  {prefix_, prefix, prefix_, "symbol table:\n"};

      for (int i = 0; i < symlist.size(); i++) begin
          str = {str, symlist[i].do_print()};
      end
      return str;
    endfunction
  endclass

  Env envlist[$];

  task push(Datum d);
`ifdef DEBUG
    string dbg_str = "";

    $write("push: scope: %0d, stack size: %0d ::  ", scope, envlist[scope].stack_.size());

    if(d.sym) begin
      $write(" sym");
      dbg_str = d.sym.do_print();
    end else begin
      if (d.sval.len())
        dbg_str = d.sval;
      else
        dbg_str = $sformatf("%s", d.ival);
    end

    $write("%s\n", dbg_str);
`endif
    envlist[scope].stack_.push_back(d);
  endtask


  function Datum pop();
    Datum d;

    string dbg_str = "";

    if (envlist[scope].stack_.size())
      d = envlist[scope].stack_[$];
    else
      $fatal("\nERROR: Stack corruption!! Bailing out...\n");

`ifdef DEBUG
    $write(" pop: scope: %0d, stack size: %0d ::  ", scope, envlist[scope].stack_.size());
    if(d.sym) begin
      $write(" sym");
      dbg_str = d.sym.do_print();
    end else begin
      if (d.sval.len())
        dbg_str = d.sval;
      else
        dbg_str = $sformatf("%0d", d.ival);
    end

    $write("%s\n", dbg_str);
`endif
    envlist[scope].stack_.pop_back();
    return d;
  endfunction

  function Datum top();
    return envlist[scope].stack_[$];
  endfunction

  function Symbol lookup(string s, Scope scope_ = ALL);
    Symbol sym;
    case(scope_)
      ALL: begin
             for (int sc = envlist.size() - 1; sc >= 0; sc--) begin
                    sym = lookup_(s, sc);
                    if (sym) break;
             end
           end
      CURRENT: sym = lookup_(s, envlist.size() - 1);
      GLOBAL:  sym = lookup_(s, 0);
    endcase

    if (sym)
      return sym;

    return null;
  endfunction

  function Symbol lookup_(string s, int scope_ = 0);
    for (int i = 0; i < envlist[scope_].symlist.size(); i++) begin
      Symbol sym = envlist[scope_].symlist[i];
      if(sym.name == s)
        return sym;
    end
    return null;
  endfunction

  task print_sym_table ();
    string dbg_str = {"scope: ", $sformatf("%0d", scope), "\n"};
    for (int unsigned i = 0; i < envlist.size(); i++) begin
      dbg_str = {dbg_str, $sformatf(" %0d", i), ":  ", envlist[i].do_symlist_print(), "\n"};
    end
    $write("%s\n", dbg_str);
  endtask

  function Symbol install(string s, Type_ t);
    Symbol sp = new();

    sp.name = s;
    sp.type_ = t;

    envlist[scope].symlist.push_back(sp);

`ifdef DEBUG
    $display("install %s, sp: %p envlist[%0d].symlist: %p", s, sp, scope, envlist[scope].symlist);
    print_sym_table();
`endif

    return sp;
  endfunction

  task inc_scope();
    Env e = new();

`ifdef DEBUG
    $write("scope++\n");
`endif
    scope++;
    envlist.push_back(e);
  endtask

  task free_env(Env e);
    for (int i = 0; i < e.symlist.size(); i++)
      if (e.symlist[i].u)
          e.symlist[i].u = null;

    for (int unsigned i = 0; i < e.stack_.size(); i++) begin
      e.stack_.pop_back();
    end
  endtask

  task dec_scope();
    free_env(envlist[$]);
    envlist.pop_back();
`ifdef DEBUG
    $write("scope--\n");
    print_sym_table();
`endif
    scope--;
  endtask

  extern virtual task visitProgram(Program p);
  extern virtual task visitStmt_Item(Stmt_Item p);
  extern virtual task visitVar_Assignment(Var_Assignment p);
  extern virtual task visitJump_Stmt(Jump_Stmt p);
  extern virtual task visitFuncOrProcCall(FuncOrProcCall p);
  extern virtual task visitBuiltin_Task(Builtin_Task p);
  extern virtual task visitBuiltin_Fn(Builtin_Fn p);
  extern virtual task visitPrint_Arg(Print_Arg p);
  extern virtual task visitProc_Definition(Proc_Definition p);
  extern virtual task visitFunc_Definition(Func_Definition p);
  extern virtual task visitDefinition(Definition p);
  extern virtual task visitFormal_Arg(Formal_Arg p);
  extern virtual task visitElse_If(Else_If p);
  extern virtual task visitElse_Opt(Else_Opt p);
  extern virtual task visitConditional_Stmt(Conditional_Stmt p);
  extern virtual task visitLoop_Stmt(Loop_Stmt p);
  extern virtual task visitFor_Init_Opt(For_Init_Opt p);
  extern virtual task visitExpr_Opt(Expr_Opt p);
  extern virtual task visitFor_Step_Opt(For_Step_Opt p);
  extern virtual task visitOp(Op p);
  extern virtual task visitExpr(Expr p);
  extern virtual task visitPrimary(Primary p);
  extern virtual task visitRange_Expr_Opt(Range_Expr_Opt p);
  extern virtual task visitRange_Expr(Range_Expr p);
  extern virtual task visitUnary_Operator(Unary_Operator p);
  extern virtual task visitInc_Or_Dec_Operator(Inc_Or_Dec_Operator p);
  extern virtual task visitNumber(Number p);
  extern virtual task visitString_Literal(String_Literal p);
  extern virtual task visitProgram1(Program1 p);
  extern virtual task visitVarDeclStmt(VarDeclStmt p);
  extern virtual task visitVarAssDeclStmt(VarAssDeclStmt p);
  extern virtual task visitAssignmentStmt(AssignmentStmt p);
  extern virtual task visitConditionalStmt(ConditionalStmt p);
  extern virtual task visitIncDecOpStmt(IncDecOpStmt p);
  extern virtual task visitLoopStmt(LoopStmt p);
  extern virtual task visitJumpStmt(JumpStmt p);
  extern virtual task visitBlockStmt(BlockStmt p);
  extern virtual task visitBuiltInStmt(BuiltInStmt p);
  extern virtual task visitProcDefStmt(ProcDefStmt p);
  extern virtual task visitFuncDefStmt(FuncDefStmt p);
  extern virtual task visitProcCallStmt(ProcCallStmt p);
  extern virtual task visitAssignment(Assignment p);
  extern virtual task visitBreak(Break p);
  extern virtual task visitContinue(Continue p);
  extern virtual task visitReturn(Return p);
  extern virtual task visitCall(Call p);
  extern virtual task visitPrint(Print p);
  extern virtual task visitRegWr(RegWr p);
  extern virtual task visitWait(Wait p);
  extern virtual task visitFatal(Fatal p);
  extern virtual task visitRegRd(RegRd p);
  extern virtual task visitCeil(Ceil p);
  extern virtual task visitFloor(Floor p);
  extern virtual task visitLog2(Log2 p);
  extern virtual task visitSys(Sys p);
  extern virtual task visitIsDefd(IsDefd p);
  extern virtual task visitPrExpr(PrExpr p);
  extern virtual task visitPrString(PrString p);
  extern virtual task visitPrHex(PrHex p);
  extern virtual task visitPrBin(PrBin p);
  extern virtual task visitProcDef(ProcDef p);
  extern virtual task visitFuncDef(FuncDef p);
  extern virtual task visitDefn(Defn p);
  extern virtual task visitFormal(Formal p);
  extern virtual task visitElsIf(ElsIf p);
  extern virtual task visitElseIsEmpty(ElseIsEmpty p);
  extern virtual task visitElseIsElse(ElseIsElse p);
  extern virtual task visitIf(If p);
  extern virtual task visitWhile(While p);
  extern virtual task visitFor(For p);
  extern virtual task visitForInitIsEmpty(ForInitIsEmpty p);
  extern virtual task visitForInitIsInit(ForInitIsInit p);
  extern virtual task visitForInitIsVarInit(ForInitIsVarInit p);
  extern virtual task visitExprIsEmpty(ExprIsEmpty p);
  extern virtual task visitExprIsExpr(ExprIsExpr p);
  extern virtual task visitForStepIsEmpty(ForStepIsEmpty p);
  extern virtual task visitForStepIsAssignment(ForStepIsAssignment p);
  extern virtual task visitForStepIsIncOrDec(ForStepIsIncOrDec p);
  extern virtual task visitPow(Pow p);
  extern virtual task visitMul(Mul p);
  extern virtual task visitDiv(Div p);
  extern virtual task visitMod(Mod p);
  extern virtual task visitAdd(Add p);
  extern virtual task visitSub(Sub p);
  extern virtual task visitLAnd(LAnd p);
  extern virtual task visitXor(Xor p);
  extern virtual task visitLOr(LOr p);
  extern virtual task visitRsh(Rsh p);
  extern virtual task visitLsh(Lsh p);
  extern virtual task visitLt(Lt p);
  extern virtual task visitLeq(Leq p);
  extern virtual task visitGt(Gt p);
  extern virtual task visitGeq(Geq p);
  extern virtual task visitEq(Eq p);
  extern virtual task visitNeq(Neq p);
  extern virtual task visitAnd(And p);
  extern virtual task visitOr(Or p);
  extern virtual task visitExprPrim(ExprPrim p);
  extern virtual task visitExprUnary(ExprUnary p);
  extern virtual task visitExprBltin(ExprBltin p);
  extern virtual task visitExprFuncCall(ExprFuncCall p);
  extern virtual task visitExprTernary(ExprTernary p);
  extern virtual task visitEOp(EOp p);
  extern virtual task visitPrimIdent(PrimIdent p);
  extern virtual task visitPrimNumber(PrimNumber p);
  extern virtual task visitRangeExprIsEmpty(RangeExprIsEmpty p);
  extern virtual task visitRangeExprIsRange(RangeExprIsRange p);
  extern virtual task visitRangeExprBit(RangeExprBit p);
  extern virtual task visitRangeExprRange(RangeExprRange p);
  extern virtual task visitUnaryPlus(UnaryPlus p);
  extern virtual task visitUnaryMinus(UnaryMinus p);
  extern virtual task visitUnaryNot(UnaryNot p);
  extern virtual task visitUnaryComp(UnaryComp p);
  extern virtual task visitIncr(Incr p);
  extern virtual task visitDecr(Decr p);
  extern virtual task visitDecimal(Decimal p);
  extern virtual task visitBinary(Binary p);
  extern virtual task visitHex(Hex p);
  extern virtual task visitReal(Real p);
  extern virtual task visitStringLit(StringLit p);

  extern virtual task visitListStmt_Item(ListStmt_Item liststmt_item);
  extern virtual task visitListExpr(ListExpr listexpr);
  extern virtual task visitListPrint_Arg(ListPrint_Arg listprint_arg);
  extern virtual task visitListFormal_Arg(ListFormal_Arg listformal_arg);
  extern virtual task visitListElse_If(ListElse_If listelse_if);

  extern virtual task visitDecimal_Number(Decimal_Number x);
  extern virtual task visitReal_Number(Real_Number x);
  extern virtual task visitBinaryNumber(BinaryNumber x);
  extern virtual task visitHexNumber(HexNumber x);
  extern virtual task visitAnyChars(AnyChars x);
  extern virtual task visitInteger(Integer x);
  extern virtual task visitChar(Char x);
  extern virtual task visitDouble(Double x);
  extern virtual task visitString(String x);
  extern virtual task visitIdent(Ident x);

  task interpret(Visitable v);
    v.accept(this);
  endtask

endclass


`endif
