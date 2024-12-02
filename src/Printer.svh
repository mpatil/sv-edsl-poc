/* -*- sv -*- File generated by the BNF Converter (bnfc 2.9.6). */

`ifndef PRINTER_HEADER
`define PRINTER_HEADER

`include "Absyn.svh"

/* Certain applications may improve performance by changing the buffer size */
`define BUFFER_INITIAL 2000
/* You may wish to change _L_PAREN or _R_PAREN */
`define _L_PAREN "("
`define _R_PAREN ")"

class PrintAbsyn implements Visitor;

  int _n_, _i_;
  /* The following are simple heuristics for rendering terminals */
  /* You may wish to change them */
  extern task render(string c);
  extern task render_s(string s);
  extern task indent();
  extern task backup();

  extern function new ();

  extern task print(Visitable v);

  extern virtual task visitProgram(Program p); /* abstract class */
  extern virtual task visitProgram1(Program1 p);
  extern virtual task visitListStmt_Item(ListStmt_Item liststmt_item);

  extern virtual task iterListStmt_Item(ListStmt_Item l,int i, int j);
  extern virtual task visitStmt_Item(Stmt_Item p); /* abstract class */
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
  extern virtual task visitListExpr(ListExpr listexpr);

  extern virtual task iterListExpr(ListExpr l,int i, int j);
  extern virtual task visitVar_Assignment(Var_Assignment p); /* abstract class */
  extern virtual task visitAssignment(Assignment p);
  extern virtual task visitJump_Stmt(Jump_Stmt p); /* abstract class */
  extern virtual task visitBreak(Break p);
  extern virtual task visitContinue(Continue p);
  extern virtual task visitReturn(Return p);
  extern virtual task visitFuncOrProcCall(FuncOrProcCall p); /* abstract class */
  extern virtual task visitCall(Call p);
  extern virtual task visitBuiltin_Task(Builtin_Task p); /* abstract class */
  extern virtual task visitPrint(Print p);
  extern virtual task visitRegWr(RegWr p);
  extern virtual task visitWait(Wait p);
  extern virtual task visitFatal(Fatal p);
  extern virtual task visitBuiltin_Fn(Builtin_Fn p); /* abstract class */
  extern virtual task visitRegRd(RegRd p);
  extern virtual task visitWaitInterrupt(WaitInterrupt p);
  extern virtual task visitCeil(Ceil p);
  extern virtual task visitFloor(Floor p);
  extern virtual task visitLog2(Log2 p);
  extern virtual task visitSys(Sys p);
  extern virtual task visitIsDefd(IsDefd p);
  extern virtual task visitBar(Bar p); /* abstract class */
  extern virtual task visitBar_(Bar_ p);
  extern virtual task visitPrint_Arg(Print_Arg p); /* abstract class */
  extern virtual task visitPrExpr(PrExpr p);
  extern virtual task visitPrString(PrString p);
  extern virtual task visitPrHex(PrHex p);
  extern virtual task visitPrBin(PrBin p);
  extern virtual task visitListPrint_Arg(ListPrint_Arg listprint_arg);

  extern virtual task iterListPrint_Arg(ListPrint_Arg l,int i, int j);
  extern virtual task visitProc_Definition(Proc_Definition p); /* abstract class */
  extern virtual task visitProcDef(ProcDef p);
  extern virtual task visitFunc_Definition(Func_Definition p); /* abstract class */
  extern virtual task visitFuncDef(FuncDef p);
  extern virtual task visitDefinition(Definition p); /* abstract class */
  extern virtual task visitDefn(Defn p);
  extern virtual task visitFormal_Arg(Formal_Arg p); /* abstract class */
  extern virtual task visitFormal(Formal p);
  extern virtual task visitListFormal_Arg(ListFormal_Arg listformal_arg);

  extern virtual task iterListFormal_Arg(ListFormal_Arg l,int i, int j);
  extern virtual task visitElse_If(Else_If p); /* abstract class */
  extern virtual task visitElsIf(ElsIf p);
  extern virtual task visitListElse_If(ListElse_If listelse_if);

  extern virtual task iterListElse_If(ListElse_If l,int i, int j);
  extern virtual task visitElse_Opt(Else_Opt p); /* abstract class */
  extern virtual task visitElseIsEmpty(ElseIsEmpty p);
  extern virtual task visitElseIsElse(ElseIsElse p);
  extern virtual task visitConditional_Stmt(Conditional_Stmt p); /* abstract class */
  extern virtual task visitIf(If p);
  extern virtual task visitLoop_Stmt(Loop_Stmt p); /* abstract class */
  extern virtual task visitWhile(While p);
  extern virtual task visitFor(For p);
  extern virtual task visitFor_Init_Opt(For_Init_Opt p); /* abstract class */
  extern virtual task visitForInitIsEmpty(ForInitIsEmpty p);
  extern virtual task visitForInitIsInit(ForInitIsInit p);
  extern virtual task visitForInitIsVarInit(ForInitIsVarInit p);
  extern virtual task visitExpr_Opt(Expr_Opt p); /* abstract class */
  extern virtual task visitExprIsEmpty(ExprIsEmpty p);
  extern virtual task visitExprIsExpr(ExprIsExpr p);
  extern virtual task visitFor_Step_Opt(For_Step_Opt p); /* abstract class */
  extern virtual task visitForStepIsEmpty(ForStepIsEmpty p);
  extern virtual task visitForStepIsAssignment(ForStepIsAssignment p);
  extern virtual task visitForStepIsIncOrDec(ForStepIsIncOrDec p);
  extern virtual task visitOp(Op p); /* abstract class */
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
  extern virtual task visitExpr(Expr p); /* abstract class */
  extern virtual task visitExprPrim(ExprPrim p);
  extern virtual task visitExprUnary(ExprUnary p);
  extern virtual task visitExprBltin(ExprBltin p);
  extern virtual task visitExprFuncCall(ExprFuncCall p);
  extern virtual task visitExprTernary(ExprTernary p);
  extern virtual task visitEOp(EOp p);
  extern virtual task visitPrimary(Primary p); /* abstract class */
  extern virtual task visitPrimIdent(PrimIdent p);
  extern virtual task visitPrimNumber(PrimNumber p);
  extern virtual task visitRange_Expr_Opt(Range_Expr_Opt p); /* abstract class */
  extern virtual task visitRangeExprIsEmpty(RangeExprIsEmpty p);
  extern virtual task visitRangeExprIsRange(RangeExprIsRange p);
  extern virtual task visitRange_Expr(Range_Expr p); /* abstract class */
  extern virtual task visitRangeExprBit(RangeExprBit p);
  extern virtual task visitRangeExprRange(RangeExprRange p);
  extern virtual task visitUnary_Operator(Unary_Operator p); /* abstract class */
  extern virtual task visitUnaryPlus(UnaryPlus p);
  extern virtual task visitUnaryMinus(UnaryMinus p);
  extern virtual task visitUnaryNot(UnaryNot p);
  extern virtual task visitUnaryComp(UnaryComp p);
  extern virtual task visitInc_Or_Dec_Operator(Inc_Or_Dec_Operator p); /* abstract class */
  extern virtual task visitIncr(Incr p);
  extern virtual task visitDecr(Decr p);
  extern virtual task visitNumber(Number p); /* abstract class */
  extern virtual task visitDecimal(Decimal p);
  extern virtual task visitBinary(Binary p);
  extern virtual task visitHex(Hex p);
  extern virtual task visitReal(Real p);
  extern virtual task visitString_Literal(String_Literal p); /* abstract class */
  extern virtual task visitStringLit(StringLit p);

  extern virtual task visitInteger(Integer x);
  extern virtual task visitDouble(Double x);
  extern virtual task visitChar(Char x);
  extern virtual task visitString(string x);
  extern virtual task visitIdent(string x);
  extern virtual task visitDecimal_Number(Decimal_Number x);
  extern virtual task visitReal_Number(Real_Number x);
  extern virtual task visitBinaryNumber(BinaryNumber x);
  extern virtual task visitHexNumber(HexNumber x);
  extern virtual task visitAnyChars(AnyChars x);

  string buf_;

  task bufAppend(string s);

    buf_ = {buf_, s};
  endtask

  task bufReset();

    buf_ = "";
  endtask

endclass


class ShowAbsyn implements Visitor;

  extern function new();
  extern task show(Visitable v);

  extern virtual task visitProgram(Program p); /* abstract class */
  extern virtual task visitProgram1(Program1 p);
  extern virtual task visitListStmt_Item(ListStmt_Item liststmt_item);

  extern virtual task visitStmt_Item(Stmt_Item p); /* abstract class */
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
  extern virtual task visitListExpr(ListExpr listexpr);

  extern virtual task visitVar_Assignment(Var_Assignment p); /* abstract class */
  extern virtual task visitAssignment(Assignment p);
  extern virtual task visitJump_Stmt(Jump_Stmt p); /* abstract class */
  extern virtual task visitBreak(Break p);
  extern virtual task visitContinue(Continue p);
  extern virtual task visitReturn(Return p);
  extern virtual task visitFuncOrProcCall(FuncOrProcCall p); /* abstract class */
  extern virtual task visitCall(Call p);
  extern virtual task visitBuiltin_Task(Builtin_Task p); /* abstract class */
  extern virtual task visitPrint(Print p);
  extern virtual task visitRegWr(RegWr p);
  extern virtual task visitWait(Wait p);
  extern virtual task visitFatal(Fatal p);
  extern virtual task visitBuiltin_Fn(Builtin_Fn p); /* abstract class */
  extern virtual task visitRegRd(RegRd p);
  extern virtual task visitWaitInterrupt(WaitInterrupt p);
  extern virtual task visitCeil(Ceil p);
  extern virtual task visitFloor(Floor p);
  extern virtual task visitLog2(Log2 p);
  extern virtual task visitSys(Sys p);
  extern virtual task visitIsDefd(IsDefd p);
  extern virtual task visitBar(Bar p); /* abstract class */
  extern virtual task visitBar_(Bar_ p);
  extern virtual task visitPrint_Arg(Print_Arg p); /* abstract class */
  extern virtual task visitPrExpr(PrExpr p);
  extern virtual task visitPrString(PrString p);
  extern virtual task visitPrHex(PrHex p);
  extern virtual task visitPrBin(PrBin p);
  extern virtual task visitListPrint_Arg(ListPrint_Arg listprint_arg);

  extern virtual task visitProc_Definition(Proc_Definition p); /* abstract class */
  extern virtual task visitProcDef(ProcDef p);
  extern virtual task visitFunc_Definition(Func_Definition p); /* abstract class */
  extern virtual task visitFuncDef(FuncDef p);
  extern virtual task visitDefinition(Definition p); /* abstract class */
  extern virtual task visitDefn(Defn p);
  extern virtual task visitFormal_Arg(Formal_Arg p); /* abstract class */
  extern virtual task visitFormal(Formal p);
  extern virtual task visitListFormal_Arg(ListFormal_Arg listformal_arg);

  extern virtual task visitElse_If(Else_If p); /* abstract class */
  extern virtual task visitElsIf(ElsIf p);
  extern virtual task visitListElse_If(ListElse_If listelse_if);

  extern virtual task visitElse_Opt(Else_Opt p); /* abstract class */
  extern virtual task visitElseIsEmpty(ElseIsEmpty p);
  extern virtual task visitElseIsElse(ElseIsElse p);
  extern virtual task visitConditional_Stmt(Conditional_Stmt p); /* abstract class */
  extern virtual task visitIf(If p);
  extern virtual task visitLoop_Stmt(Loop_Stmt p); /* abstract class */
  extern virtual task visitWhile(While p);
  extern virtual task visitFor(For p);
  extern virtual task visitFor_Init_Opt(For_Init_Opt p); /* abstract class */
  extern virtual task visitForInitIsEmpty(ForInitIsEmpty p);
  extern virtual task visitForInitIsInit(ForInitIsInit p);
  extern virtual task visitForInitIsVarInit(ForInitIsVarInit p);
  extern virtual task visitExpr_Opt(Expr_Opt p); /* abstract class */
  extern virtual task visitExprIsEmpty(ExprIsEmpty p);
  extern virtual task visitExprIsExpr(ExprIsExpr p);
  extern virtual task visitFor_Step_Opt(For_Step_Opt p); /* abstract class */
  extern virtual task visitForStepIsEmpty(ForStepIsEmpty p);
  extern virtual task visitForStepIsAssignment(ForStepIsAssignment p);
  extern virtual task visitForStepIsIncOrDec(ForStepIsIncOrDec p);
  extern virtual task visitOp(Op p); /* abstract class */
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
  extern virtual task visitExpr(Expr p); /* abstract class */
  extern virtual task visitExprPrim(ExprPrim p);
  extern virtual task visitExprUnary(ExprUnary p);
  extern virtual task visitExprBltin(ExprBltin p);
  extern virtual task visitExprFuncCall(ExprFuncCall p);
  extern virtual task visitExprTernary(ExprTernary p);
  extern virtual task visitEOp(EOp p);
  extern virtual task visitPrimary(Primary p); /* abstract class */
  extern virtual task visitPrimIdent(PrimIdent p);
  extern virtual task visitPrimNumber(PrimNumber p);
  extern virtual task visitRange_Expr_Opt(Range_Expr_Opt p); /* abstract class */
  extern virtual task visitRangeExprIsEmpty(RangeExprIsEmpty p);
  extern virtual task visitRangeExprIsRange(RangeExprIsRange p);
  extern virtual task visitRange_Expr(Range_Expr p); /* abstract class */
  extern virtual task visitRangeExprBit(RangeExprBit p);
  extern virtual task visitRangeExprRange(RangeExprRange p);
  extern virtual task visitUnary_Operator(Unary_Operator p); /* abstract class */
  extern virtual task visitUnaryPlus(UnaryPlus p);
  extern virtual task visitUnaryMinus(UnaryMinus p);
  extern virtual task visitUnaryNot(UnaryNot p);
  extern virtual task visitUnaryComp(UnaryComp p);
  extern virtual task visitInc_Or_Dec_Operator(Inc_Or_Dec_Operator p); /* abstract class */
  extern virtual task visitIncr(Incr p);
  extern virtual task visitDecr(Decr p);
  extern virtual task visitNumber(Number p); /* abstract class */
  extern virtual task visitDecimal(Decimal p);
  extern virtual task visitBinary(Binary p);
  extern virtual task visitHex(Hex p);
  extern virtual task visitReal(Real p);
  extern virtual task visitString_Literal(String_Literal p); /* abstract class */
  extern virtual task visitStringLit(StringLit p);

  extern virtual task visitInteger(Integer x);
  extern virtual task visitDouble(Double x);
  extern virtual task visitChar(Char x);
  extern virtual task visitString(string x);
  extern virtual task visitIdent(string x);
  extern virtual task visitDecimal_Number(Decimal_Number x);
  extern virtual task visitReal_Number(Real_Number x);
  extern virtual task visitBinaryNumber(BinaryNumber x);
  extern virtual task visitHexNumber(HexNumber x);
  extern virtual task visitAnyChars(AnyChars x);

  string buf_;

  task bufAppend(string s);

    buf_ = {buf_, s};
  endtask

  task bufReset();

    buf_ = "";
  endtask

endclass


`endif

