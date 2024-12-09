/* -*- sv -*- File generated by the BNF Converter (bnfc 2.9.6). */

`ifndef ABSYN_HEADER
`define ABSYN_HEADER

typedef class Visitor;

//************************************************************.

/********************   TypeDef Section    ********************/

typedef int Integer;
typedef string Char;
typedef real Double;
typedef string String;
typedef string Ident;

typedef string Decimal_Number;
typedef string Real_Number;
typedef string BinaryNumber;
typedef string HexNumber;
typedef string AnyChars;

/********************   Forward Declarations    ********************/

typedef class Program;
typedef class Stmt_Item;
typedef class Var_Assignment;
typedef class Jump_Stmt;
typedef class FuncOrProcCall;
typedef class Builtin_Task;
typedef class Builtin_Fn;
typedef class Bar;
typedef class Print_Arg;
typedef class Proc_Definition;
typedef class Func_Definition;
typedef class Definition;
typedef class Formal_Arg;
typedef class Else_If;
typedef class Else_Opt;
typedef class Conditional_Stmt;
typedef class Loop_Stmt;
typedef class For_Init_Opt;
typedef class Expr_Opt;
typedef class For_Step_Opt;
typedef class Op;
typedef class Expr;
typedef class Primary;
typedef class Range_Expr_Opt;
typedef class Range_Expr;
typedef class Unary_Operator;
typedef class Inc_Or_Dec_Operator;
typedef class Number;
typedef class String_Literal;
typedef class Program1;
typedef class VarDeclStmt;
typedef class VarAssDeclStmt;
typedef class AssignmentStmt;
typedef class ConditionalStmt;
typedef class IncDecOpStmt;
typedef class LoopStmt;
typedef class JumpStmt;
typedef class BlockStmt;
typedef class BuiltInStmt;
typedef class ProcDefStmt;
typedef class FuncDefStmt;
typedef class ProcCallStmt;
typedef class Assignment;
typedef class Break;
typedef class Continue;
typedef class Return;
typedef class Call;
typedef class Print;
typedef class RegWr;
typedef class Wait;
typedef class Fatal;
typedef class RegRd;
typedef class WaitInterrupt;
typedef class Ceil;
typedef class Floor;
typedef class Log2;
typedef class Sys;
typedef class IsDefd;
typedef class Bar_;
typedef class PrExpr;
typedef class PrString;
typedef class PrHex;
typedef class PrBin;
typedef class ProcDef;
typedef class FuncDef;
typedef class Defn;
typedef class Formal;
typedef class ElsIf;
typedef class ElseIsEmpty;
typedef class ElseIsElse;
typedef class If;
typedef class While;
typedef class For;
typedef class ForInitIsEmpty;
typedef class ForInitIsInit;
typedef class ForInitIsVarInit;
typedef class ExprIsEmpty;
typedef class ExprIsExpr;
typedef class ForStepIsEmpty;
typedef class ForStepIsAssignment;
typedef class ForStepIsIncOrDec;
typedef class Pow;
typedef class Mul;
typedef class Div;
typedef class Mod;
typedef class Add;
typedef class Sub;
typedef class LAnd;
typedef class Xor;
typedef class LOr;
typedef class Rsh;
typedef class Lsh;
typedef class Lt;
typedef class Leq;
typedef class Gt;
typedef class Geq;
typedef class Eq;
typedef class Neq;
typedef class And;
typedef class Or;
typedef class ExprPrim;
typedef class ExprUnary;
typedef class ExprBltin;
typedef class ExprFuncCall;
typedef class ExprTernary;
typedef class EOp;
typedef class PrimIdent;
typedef class PrimNumber;
typedef class RangeExprIsEmpty;
typedef class RangeExprIsRange;
typedef class RangeExprBit;
typedef class RangeExprRange;
typedef class UnaryPlus;
typedef class UnaryMinus;
typedef class UnaryNot;
typedef class UnaryComp;
typedef class Incr;
typedef class Decr;
typedef class Decimal;
typedef class Binary;
typedef class Hex;
typedef class Real;
typedef class StringLit;
typedef class ListStmt_Item;
typedef class ListExpr;
typedef class ListPrint_Arg;
typedef class ListFormal_Arg;
typedef class ListElse_If;

/********************   Visitor Interfaces    ********************/
interface class Visitor;
  pure virtual task visitProgram(Program p);
  pure virtual task visitStmt_Item(Stmt_Item p);
  pure virtual task visitVar_Assignment(Var_Assignment p);
  pure virtual task visitJump_Stmt(Jump_Stmt p);
  pure virtual task visitFuncOrProcCall(FuncOrProcCall p);
  pure virtual task visitBuiltin_Task(Builtin_Task p);
  pure virtual task visitBuiltin_Fn(Builtin_Fn p);
  pure virtual task visitBar(Bar p);
  pure virtual task visitPrint_Arg(Print_Arg p);
  pure virtual task visitProc_Definition(Proc_Definition p);
  pure virtual task visitFunc_Definition(Func_Definition p);
  pure virtual task visitDefinition(Definition p);
  pure virtual task visitFormal_Arg(Formal_Arg p);
  pure virtual task visitElse_If(Else_If p);
  pure virtual task visitElse_Opt(Else_Opt p);
  pure virtual task visitConditional_Stmt(Conditional_Stmt p);
  pure virtual task visitLoop_Stmt(Loop_Stmt p);
  pure virtual task visitFor_Init_Opt(For_Init_Opt p);
  pure virtual task visitExpr_Opt(Expr_Opt p);
  pure virtual task visitFor_Step_Opt(For_Step_Opt p);
  pure virtual task visitOp(Op p);
  pure virtual task visitExpr(Expr p);
  pure virtual task visitPrimary(Primary p);
  pure virtual task visitRange_Expr_Opt(Range_Expr_Opt p);
  pure virtual task visitRange_Expr(Range_Expr p);
  pure virtual task visitUnary_Operator(Unary_Operator p);
  pure virtual task visitInc_Or_Dec_Operator(Inc_Or_Dec_Operator p);
  pure virtual task visitNumber(Number p);
  pure virtual task visitString_Literal(String_Literal p);
  pure virtual task visitProgram1(Program1 p);
  pure virtual task visitVarDeclStmt(VarDeclStmt p);
  pure virtual task visitVarAssDeclStmt(VarAssDeclStmt p);
  pure virtual task visitAssignmentStmt(AssignmentStmt p);
  pure virtual task visitConditionalStmt(ConditionalStmt p);
  pure virtual task visitIncDecOpStmt(IncDecOpStmt p);
  pure virtual task visitLoopStmt(LoopStmt p);
  pure virtual task visitJumpStmt(JumpStmt p);
  pure virtual task visitBlockStmt(BlockStmt p);
  pure virtual task visitBuiltInStmt(BuiltInStmt p);
  pure virtual task visitProcDefStmt(ProcDefStmt p);
  pure virtual task visitFuncDefStmt(FuncDefStmt p);
  pure virtual task visitProcCallStmt(ProcCallStmt p);
  pure virtual task visitAssignment(Assignment p);
  pure virtual task visitBreak(Break p);
  pure virtual task visitContinue(Continue p);
  pure virtual task visitReturn(Return p);
  pure virtual task visitCall(Call p);
  pure virtual task visitPrint(Print p);
  pure virtual task visitRegWr(RegWr p);
  pure virtual task visitWait(Wait p);
  pure virtual task visitFatal(Fatal p);
  pure virtual task visitRegRd(RegRd p);
  pure virtual task visitWaitInterrupt(WaitInterrupt p);
  pure virtual task visitCeil(Ceil p);
  pure virtual task visitFloor(Floor p);
  pure virtual task visitLog2(Log2 p);
  pure virtual task visitSys(Sys p);
  pure virtual task visitIsDefd(IsDefd p);
  pure virtual task visitBar_(Bar_ p);
  pure virtual task visitPrExpr(PrExpr p);
  pure virtual task visitPrString(PrString p);
  pure virtual task visitPrHex(PrHex p);
  pure virtual task visitPrBin(PrBin p);
  pure virtual task visitProcDef(ProcDef p);
  pure virtual task visitFuncDef(FuncDef p);
  pure virtual task visitDefn(Defn p);
  pure virtual task visitFormal(Formal p);
  pure virtual task visitElsIf(ElsIf p);
  pure virtual task visitElseIsEmpty(ElseIsEmpty p);
  pure virtual task visitElseIsElse(ElseIsElse p);
  pure virtual task visitIf(If p);
  pure virtual task visitWhile(While p);
  pure virtual task visitFor(For p);
  pure virtual task visitForInitIsEmpty(ForInitIsEmpty p);
  pure virtual task visitForInitIsInit(ForInitIsInit p);
  pure virtual task visitForInitIsVarInit(ForInitIsVarInit p);
  pure virtual task visitExprIsEmpty(ExprIsEmpty p);
  pure virtual task visitExprIsExpr(ExprIsExpr p);
  pure virtual task visitForStepIsEmpty(ForStepIsEmpty p);
  pure virtual task visitForStepIsAssignment(ForStepIsAssignment p);
  pure virtual task visitForStepIsIncOrDec(ForStepIsIncOrDec p);
  pure virtual task visitPow(Pow p);
  pure virtual task visitMul(Mul p);
  pure virtual task visitDiv(Div p);
  pure virtual task visitMod(Mod p);
  pure virtual task visitAdd(Add p);
  pure virtual task visitSub(Sub p);
  pure virtual task visitLAnd(LAnd p);
  pure virtual task visitXor(Xor p);
  pure virtual task visitLOr(LOr p);
  pure virtual task visitRsh(Rsh p);
  pure virtual task visitLsh(Lsh p);
  pure virtual task visitLt(Lt p);
  pure virtual task visitLeq(Leq p);
  pure virtual task visitGt(Gt p);
  pure virtual task visitGeq(Geq p);
  pure virtual task visitEq(Eq p);
  pure virtual task visitNeq(Neq p);
  pure virtual task visitAnd(And p);
  pure virtual task visitOr(Or p);
  pure virtual task visitExprPrim(ExprPrim p);
  pure virtual task visitExprUnary(ExprUnary p);
  pure virtual task visitExprBltin(ExprBltin p);
  pure virtual task visitExprFuncCall(ExprFuncCall p);
  pure virtual task visitExprTernary(ExprTernary p);
  pure virtual task visitEOp(EOp p);
  pure virtual task visitPrimIdent(PrimIdent p);
  pure virtual task visitPrimNumber(PrimNumber p);
  pure virtual task visitRangeExprIsEmpty(RangeExprIsEmpty p);
  pure virtual task visitRangeExprIsRange(RangeExprIsRange p);
  pure virtual task visitRangeExprBit(RangeExprBit p);
  pure virtual task visitRangeExprRange(RangeExprRange p);
  pure virtual task visitUnaryPlus(UnaryPlus p);
  pure virtual task visitUnaryMinus(UnaryMinus p);
  pure virtual task visitUnaryNot(UnaryNot p);
  pure virtual task visitUnaryComp(UnaryComp p);
  pure virtual task visitIncr(Incr p);
  pure virtual task visitDecr(Decr p);
  pure virtual task visitDecimal(Decimal p);
  pure virtual task visitBinary(Binary p);
  pure virtual task visitHex(Hex p);
  pure virtual task visitReal(Real p);
  pure virtual task visitStringLit(StringLit p);


  pure virtual task visitListStmt_Item(ListStmt_Item liststmt_item);
  pure virtual task visitListExpr(ListExpr listexpr);
  pure virtual task visitListPrint_Arg(ListPrint_Arg listprint_arg);
  pure virtual task visitListFormal_Arg(ListFormal_Arg listformal_arg);
  pure virtual task visitListElse_If(ListElse_If listelse_if);

  pure virtual task visitInteger(Integer x);
  pure virtual task visitChar(Char x);
  pure virtual task visitDouble(Double x);
  pure virtual task visitString(String x);
  pure virtual task visitIdent(Ident x);
  pure virtual task visitDecimal_Number(Decimal_Number x);
  pure virtual task visitReal_Number(Real_Number x);
  pure virtual task visitBinaryNumber(BinaryNumber x);
  pure virtual task visitHexNumber(HexNumber x);
  pure virtual task visitAnyChars(AnyChars x);

endclass

interface class Visitable;
  pure virtual task accept(Visitor v);
endclass

/********************   Abstract Syntax Classes    ********************/

virtual class Program implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Stmt_Item implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Var_Assignment implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Jump_Stmt implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class FuncOrProcCall implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Builtin_Task implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Builtin_Fn implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Bar implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Print_Arg implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Proc_Definition implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Func_Definition implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Definition implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Formal_Arg implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Else_If implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Else_Opt implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Conditional_Stmt implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Loop_Stmt implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class For_Init_Opt implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Expr_Opt implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class For_Step_Opt implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Op implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Expr implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Primary implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Range_Expr_Opt implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Range_Expr implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Unary_Operator implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Inc_Or_Dec_Operator implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class Number implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass

virtual class String_Literal implements Visitable;
  int line_number;
  virtual task accept(Visitor v); endtask
endclass


class Program1 extends Program;
  ListStmt_Item liststmt_item_;

  extern function new(ListStmt_Item p1);
  extern virtual task accept(Visitor v);
endclass

class VarDeclStmt extends Stmt_Item;
  Ident ident_;

  extern function new(Ident p1);
  extern virtual task accept(Visitor v);
endclass

class VarAssDeclStmt extends Stmt_Item;
  Var_Assignment var_assignment_;

  extern function new(Var_Assignment p1);
  extern virtual task accept(Visitor v);
endclass

class AssignmentStmt extends Stmt_Item;
  Var_Assignment var_assignment_;

  extern function new(Var_Assignment p1);
  extern virtual task accept(Visitor v);
endclass

class ConditionalStmt extends Stmt_Item;
  Conditional_Stmt conditional_stmt_;

  extern function new(Conditional_Stmt p1);
  extern virtual task accept(Visitor v);
endclass

class IncDecOpStmt extends Stmt_Item;
  Ident ident_;
  Inc_Or_Dec_Operator inc_or_dec_operator_;

  extern function new(Ident p1, Inc_Or_Dec_Operator p2);
  extern virtual task accept(Visitor v);
endclass

class LoopStmt extends Stmt_Item;
  Loop_Stmt loop_stmt_;

  extern function new(Loop_Stmt p1);
  extern virtual task accept(Visitor v);
endclass

class JumpStmt extends Stmt_Item;
  Jump_Stmt jump_stmt_;

  extern function new(Jump_Stmt p1);
  extern virtual task accept(Visitor v);
endclass

class BlockStmt extends Stmt_Item;
  ListStmt_Item liststmt_item_;

  extern function new(ListStmt_Item p1);
  extern virtual task accept(Visitor v);
endclass

class BuiltInStmt extends Stmt_Item;
  Builtin_Task builtin_task_;

  extern function new(Builtin_Task p1);
  extern virtual task accept(Visitor v);
endclass

class ProcDefStmt extends Stmt_Item;
  Proc_Definition proc_definition_;

  extern function new(Proc_Definition p1);
  extern virtual task accept(Visitor v);
endclass

class FuncDefStmt extends Stmt_Item;
  Func_Definition func_definition_;

  extern function new(Func_Definition p1);
  extern virtual task accept(Visitor v);
endclass

class ProcCallStmt extends Stmt_Item;
  FuncOrProcCall funcorproccall_;

  extern function new(FuncOrProcCall p1);
  extern virtual task accept(Visitor v);
endclass

class Assignment extends Var_Assignment;
  Ident ident_;
  Range_Expr_Opt range_expr_opt_;
  Expr expr_;

  extern function new(Ident p1, Range_Expr_Opt p2, Expr p3);
  extern virtual task accept(Visitor v);
endclass

class Break extends Jump_Stmt;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Continue extends Jump_Stmt;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Return extends Jump_Stmt;
  Expr_Opt expr_opt_;

  extern function new(Expr_Opt p1);
  extern virtual task accept(Visitor v);
endclass

class Call extends FuncOrProcCall;
  Ident ident_;
  ListExpr listexpr_;

  extern function new(Ident p1, ListExpr p2);
  extern virtual task accept(Visitor v);
endclass

class Print extends Builtin_Task;
  ListPrint_Arg listprint_arg_;

  extern function new(ListPrint_Arg p1);
  extern virtual task accept(Visitor v);
endclass

class RegWr extends Builtin_Task;
  Bar bar_;
  Expr expr_1;
  Expr expr_2;

  extern function new(Bar p1, Expr p2, Expr p3);
  extern virtual task accept(Visitor v);
endclass

class Wait extends Builtin_Task;
  Expr expr_;

  extern function new(Expr p1);
  extern virtual task accept(Visitor v);
endclass

class Fatal extends Builtin_Task;
  Expr expr_;

  extern function new(Expr p1);
  extern virtual task accept(Visitor v);
endclass

class RegRd extends Builtin_Fn;
  Bar bar_;
  Expr expr_;

  extern function new(Bar p1, Expr p2);
  extern virtual task accept(Visitor v);
endclass

class WaitInterrupt extends Builtin_Fn;
  ListExpr listexpr_;
  Expr expr_;

  extern function new(ListExpr p1, Expr p2);
  extern virtual task accept(Visitor v);
endclass

class Ceil extends Builtin_Fn;
  Expr expr_;

  extern function new(Expr p1);
  extern virtual task accept(Visitor v);
endclass

class Floor extends Builtin_Fn;
  Expr expr_;

  extern function new(Expr p1);
  extern virtual task accept(Visitor v);
endclass

class Log2 extends Builtin_Fn;
  Expr expr_;

  extern function new(Expr p1);
  extern virtual task accept(Visitor v);
endclass

class Sys extends Builtin_Fn;
  String_Literal string_literal_;

  extern function new(String_Literal p1);
  extern virtual task accept(Visitor v);
endclass

class IsDefd extends Builtin_Fn;
  Ident ident_;

  extern function new(Ident p1);
  extern virtual task accept(Visitor v);
endclass

class Bar_ extends Bar;
  Expr expr_;

  extern function new(Expr p1);
  extern virtual task accept(Visitor v);
endclass

class PrExpr extends Print_Arg;
  Expr expr_;

  extern function new(Expr p1);
  extern virtual task accept(Visitor v);
endclass

class PrString extends Print_Arg;
  String_Literal string_literal_;

  extern function new(String_Literal p1);
  extern virtual task accept(Visitor v);
endclass

class PrHex extends Print_Arg;
  Expr expr_;

  extern function new(Expr p1);
  extern virtual task accept(Visitor v);
endclass

class PrBin extends Print_Arg;
  Expr expr_;

  extern function new(Expr p1);
  extern virtual task accept(Visitor v);
endclass

class ProcDef extends Proc_Definition;
  Definition definition_;

  extern function new(Definition p1);
  extern virtual task accept(Visitor v);
endclass

class FuncDef extends Func_Definition;
  Definition definition_;

  extern function new(Definition p1);
  extern virtual task accept(Visitor v);
endclass

class Defn extends Definition;
  Ident ident_;
  ListFormal_Arg listformal_arg_;
  Stmt_Item stmt_item_;

  extern function new(Ident p1, ListFormal_Arg p2, Stmt_Item p3);
  extern virtual task accept(Visitor v);
endclass

class Formal extends Formal_Arg;
  Ident ident_;

  extern function new(Ident p1);
  extern virtual task accept(Visitor v);
endclass

class ElsIf extends Else_If;
  Expr expr_;
  Stmt_Item stmt_item_;

  extern function new(Expr p1, Stmt_Item p2);
  extern virtual task accept(Visitor v);
endclass

class ElseIsEmpty extends Else_Opt;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class ElseIsElse extends Else_Opt;
  Stmt_Item stmt_item_;

  extern function new(Stmt_Item p1);
  extern virtual task accept(Visitor v);
endclass

class If extends Conditional_Stmt;
  Expr expr_;
  Stmt_Item stmt_item_;
  ListElse_If listelse_if_;
  Else_Opt else_opt_;

  extern function new(Expr p1, Stmt_Item p2, ListElse_If p3, Else_Opt p4);
  extern virtual task accept(Visitor v);
endclass

class While extends Loop_Stmt;
  Expr expr_;
  Stmt_Item stmt_item_;

  extern function new(Expr p1, Stmt_Item p2);
  extern virtual task accept(Visitor v);
endclass

class For extends Loop_Stmt;
  For_Init_Opt for_init_opt_;
  Expr_Opt expr_opt_;
  For_Step_Opt for_step_opt_;
  Stmt_Item stmt_item_;

  extern function new(For_Init_Opt p1, Expr_Opt p2, For_Step_Opt p3, Stmt_Item p4);
  extern virtual task accept(Visitor v);
endclass

class ForInitIsEmpty extends For_Init_Opt;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class ForInitIsInit extends For_Init_Opt;
  Var_Assignment var_assignment_;

  extern function new(Var_Assignment p1);
  extern virtual task accept(Visitor v);
endclass

class ForInitIsVarInit extends For_Init_Opt;
  Var_Assignment var_assignment_;

  extern function new(Var_Assignment p1);
  extern virtual task accept(Visitor v);
endclass

class ExprIsEmpty extends Expr_Opt;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class ExprIsExpr extends Expr_Opt;
  Expr expr_;

  extern function new(Expr p1);
  extern virtual task accept(Visitor v);
endclass

class ForStepIsEmpty extends For_Step_Opt;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class ForStepIsAssignment extends For_Step_Opt;
  Var_Assignment var_assignment_;

  extern function new(Var_Assignment p1);
  extern virtual task accept(Visitor v);
endclass

class ForStepIsIncOrDec extends For_Step_Opt;
  Ident ident_;
  Inc_Or_Dec_Operator inc_or_dec_operator_;

  extern function new(Ident p1, Inc_Or_Dec_Operator p2);
  extern virtual task accept(Visitor v);
endclass

class Pow extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Mul extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Div extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Mod extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Add extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Sub extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class LAnd extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Xor extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class LOr extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Rsh extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Lsh extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Lt extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Leq extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Gt extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Geq extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Eq extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Neq extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class And extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Or extends Op;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class ExprPrim extends Expr;
  Primary primary_;

  extern function new(Primary p1);
  extern virtual task accept(Visitor v);
endclass

class ExprUnary extends Expr;
  Unary_Operator unary_operator_;
  Expr expr_;

  extern function new(Unary_Operator p1, Expr p2);
  extern virtual task accept(Visitor v);
endclass

class ExprBltin extends Expr;
  Builtin_Fn builtin_fn_;

  extern function new(Builtin_Fn p1);
  extern virtual task accept(Visitor v);
endclass

class ExprFuncCall extends Expr;
  FuncOrProcCall funcorproccall_;

  extern function new(FuncOrProcCall p1);
  extern virtual task accept(Visitor v);
endclass

class ExprTernary extends Expr;
  Expr expr_1;
  Expr expr_2;
  Expr expr_3;

  extern function new(Expr p1, Expr p2, Expr p3);
  extern virtual task accept(Visitor v);
endclass

class EOp extends Expr;
  Expr expr_1;
  Op op_;
  Expr expr_2;

  extern function new(Expr p1, Op p2, Expr p3);
  extern virtual task accept(Visitor v);
endclass

class PrimIdent extends Primary;
  Ident ident_;
  Range_Expr_Opt range_expr_opt_;

  extern function new(Ident p1, Range_Expr_Opt p2);
  extern virtual task accept(Visitor v);
endclass

class PrimNumber extends Primary;
  Number number_;

  extern function new(Number p1);
  extern virtual task accept(Visitor v);
endclass

class RangeExprIsEmpty extends Range_Expr_Opt;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class RangeExprIsRange extends Range_Expr_Opt;
  Range_Expr range_expr_;

  extern function new(Range_Expr p1);
  extern virtual task accept(Visitor v);
endclass

class RangeExprBit extends Range_Expr;
  Expr expr_;

  extern function new(Expr p1);
  extern virtual task accept(Visitor v);
endclass

class RangeExprRange extends Range_Expr;
  Expr expr_1;
  Expr expr_2;

  extern function new(Expr p1, Expr p2);
  extern virtual task accept(Visitor v);
endclass

class UnaryPlus extends Unary_Operator;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class UnaryMinus extends Unary_Operator;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class UnaryNot extends Unary_Operator;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class UnaryComp extends Unary_Operator;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Incr extends Inc_Or_Dec_Operator;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Decr extends Inc_Or_Dec_Operator;

  extern function new();
  extern virtual task accept(Visitor v);
endclass

class Decimal extends Number;
  Decimal_Number decimal_number_;

  extern function new(Decimal_Number p1);
  extern virtual task accept(Visitor v);
endclass

class Binary extends Number;
  BinaryNumber binarynumber_;

  extern function new(BinaryNumber p1);
  extern virtual task accept(Visitor v);
endclass

class Hex extends Number;
  HexNumber hexnumber_;

  extern function new(HexNumber p1);
  extern virtual task accept(Visitor v);
endclass

class Real extends Number;
  Real_Number real_number_;

  extern function new(Real_Number p1);
  extern virtual task accept(Visitor v);
endclass

class StringLit extends String_Literal;
  AnyChars anychars_;

  extern function new(AnyChars p1);
  extern virtual task accept(Visitor v);
endclass


class ListStmt_Item implements Visitable;
  Stmt_Item  v[$];
  extern virtual task accept(Visitor v);
endclass

class ListExpr implements Visitable;
  Expr  v[$];
  extern virtual task accept(Visitor v);
endclass

class ListPrint_Arg implements Visitable;
  Print_Arg  v[$];
  extern virtual task accept(Visitor v);
endclass

class ListFormal_Arg implements Visitable;
  Formal_Arg  v[$];
  extern virtual task accept(Visitor v);
endclass

class ListElse_If implements Visitable;
  Else_If  v[$];
  extern virtual task accept(Visitor v);
endclass


/********************   Defined Constructors    ********************/

function Expr  op_(Expr  e1_, Op  o_, Expr  e2_);




  automatic Expr  p = EOp::new(e1_, o_, e2_);
  return p;
endfunction

function Loop_Stmt  forever__(Stmt_Item  s_);
  automatic For_Init_Opt p0 = ForInitIsEmpty::new();
  automatic Expr_Opt p1 = ExprIsEmpty::new();
  automatic For_Step_Opt p2 = ForStepIsEmpty::new();


  automatic Loop_Stmt  p = For::new(p0, p1, p2, s_);
  return p;
endfunction



`endif
