using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Numerics;
using JetBrains.Annotations;
using Microsoft.Dafny;
using Microsoft.Dafny.Compilers;
using Type = Microsoft.Dafny.Type;

namespace DafnyCore.Backends.Lean;

// TODO: mcamaioni@: every time TrExprList is used in this file, surround each argument with parentheses
// instead of iterate extract each element and put parenthesis around it
// and every time you output what looks like a function call

public class LeanCodeGenerator(DafnyOptions options, ErrorReporter reporter) : SinglePassCodeGenerator(options, reporter) {
  private struct StructureWriter(LeanCodeGenerator parent, DatatypeDecl dt, ConcreteSyntaxTree functions) : IClassWriter {
    public ConcreteSyntaxTree CreateMethod(MethodOrConstructor m, List<TypeArgumentInstantiation> typeArgs, bool createBody, bool forBodyInheritance, bool lookasideBody) {
      throw new NotImplementedException();
    }

    public ConcreteSyntaxTree SynthesizeMethod(Method m, List<TypeArgumentInstantiation> typeArgs, bool createBody, bool forBodyInheritance, bool lookasideBody) {
      throw new NotImplementedException();
    }

    public ConcreteSyntaxTree CreateFunction(string name, List<TypeArgumentInstantiation> typeArgs, List<Formal> formals, Type resultType, IOrigin tok, bool isStatic,
      bool createBody, MemberDecl member, bool forBodyInheritance, bool lookasideBody) {
      functions.WriteLine();
      functions = functions.Write($"noncomputable def {dt.Name}.{name}");
      Contract.Assert(typeArgs.Count == 0);
      var dtType = UserDefinedType.FromTopLevelDecl(tok, dt, new List<Type>());
      parent.DeclareFormal(" ", "this", dtType, tok, true, functions);
      parent.WriteFormals(" ", formals, functions);
      var bodyWr = functions.NewBlock(header: $": {parent.TypeName(resultType, functions, tok)} :=", open: BlockStyle.Newline, close: BlockStyle.Newline);
      if (!((Function)member).Req.Any()) {
        return bodyWr;
      }
      //var defaultExpr = resultType.Equals(dtType) ? "this" : "default";
      string defaultExpr;
      if (resultType.Equals(dtType)) {
        defaultExpr = "this";
      }
      else if (resultType is UserDefinedType { Name: "Handler" }) {
        defaultExpr = $"Handler.Return (Machine.{dtType} this)";
      } else {
        defaultExpr = "default";
      }
      bodyWr = bodyWr.NewBlock(header: "", $" else {defaultExpr}", open: BlockStyle.Space, close: BlockStyle.Newline);
      var realBodyWr = bodyWr.NewBlock(header: "if", footer: " then", open: BlockStyle.Space, close: BlockStyle.Space);
      foreach (var (clause, i) in ((Function)member).Req.Indexed()) {
        parent.EmitExpr(clause.E, false, realBodyWr, null);
        if (i + 1 < ((Function)member).Req.Count) {
          realBodyWr = realBodyWr.WriteLine(" ∧ ");
        }
      }
      return bodyWr;
    }

    public ConcreteSyntaxTree CreateGetter(string name, TopLevelDecl enclosingDecl, Type resultType, IOrigin tok, bool isStatic, bool isConst, bool createBody, MemberDecl member, bool forBodyInheritance) {
      throw new NotImplementedException();
    }

    public ConcreteSyntaxTree CreateGetterSetter(string name, Type resultType, IOrigin tok, bool createBody, MemberDecl member, out ConcreteSyntaxTree setterWriter, bool forBodyInheritance) {
      throw new NotImplementedException();
    }

    public void DeclareField(string name, TopLevelDecl enclosingDecl, bool isStatic, bool isConst, Type type, IOrigin tok, string rhs, Field field) {
      throw new NotImplementedException();
    }

    public void InitializeField(Field field, Type instantiatedFieldType, TopLevelDeclWithMembers enclosingClass) {
      throw new NotImplementedException();
    }

    public ConcreteSyntaxTree ErrorWriter() {
      return null;
    }

    public void Finish() { }
  }

  private struct TopLevelFunctionWriter(LeanCodeGenerator parent, TopLevelDecl cls, ConcreteSyntaxTree wr) : IClassWriter {
    public ConcreteSyntaxTree CreateMethod(MethodOrConstructor m, List<TypeArgumentInstantiation> typeArgs, bool createBody, bool forBodyInheritance,
      bool lookasideBody) {
      throw new NotImplementedException();
    }

    public ConcreteSyntaxTree SynthesizeMethod(Method m, List<TypeArgumentInstantiation> typeArgs, bool createBody, bool forBodyInheritance,
      bool lookasideBody) {
      throw new NotImplementedException();
    }

    public ConcreteSyntaxTree CreateFunction(string name, List<TypeArgumentInstantiation> typeArgs, List<Formal> formals, Type resultType, IOrigin tok, bool isStatic,
      bool createBody, MemberDecl member, bool forBodyInheritance, bool lookasideBody) {
      wr = wr.WriteLine($"noncomputable def {cls.Name}.{name} ");
      parent.WriteFormals(" ", formals, wr.NewBlock(header: "", footer: " :=", open: BlockStyle.Space, close: BlockStyle.Space));
      return wr;
    }

    public ConcreteSyntaxTree CreateGetter(string name, TopLevelDecl enclosingDecl, Type resultType, IOrigin tok, bool isStatic,
      bool isConst, bool createBody, MemberDecl member, bool forBodyInheritance) {
      throw new NotImplementedException();
    }

    public ConcreteSyntaxTree CreateGetterSetter(string name, Type resultType, IOrigin tok, bool createBody, MemberDecl member,
      out ConcreteSyntaxTree setterWriter, bool forBodyInheritance) {
      throw new NotImplementedException();
    }

    public void DeclareField(string name, TopLevelDecl enclosingDecl, bool isStatic, bool isConst, Type type, IOrigin tok,
      string rhs, Field field) {
      throw new NotImplementedException();
    }

    public void InitializeField(Field field, Type instantiatedFieldType, TopLevelDeclWithMembers enclosingClass) {
      throw new NotImplementedException();
    }

    public ConcreteSyntaxTree ErrorWriter() {
      return null;
    }

    public void Finish() {
    }
  }
  
  public override void EmitCallToMain(Method mainMethod, string baseName, ConcreteSyntaxTree callToMainTree) {
    throw new NotImplementedException();
  }

  public override string PublicIdProtect(string name) {
    throw new NotImplementedException();
  }
  
  // Easier to specify what we support, rather than what not
  public override IReadOnlySet<Feature> UnsupportedFeatures { 
    get
    {
      var ret = Enum.GetValues<Feature>().ToHashSet();
      // TODO incrementally remove things
      return ret;
    }
  }
  
  protected override ConcreteSyntaxTree CreateStaticMain(IClassWriter wr, string argsParameterName) {
    throw new NotImplementedException();
  }

  protected override ConcreteSyntaxTree CreateModule(ModuleDefinition module, string moduleName, bool isDefault, ModuleDefinition externModule, string libraryName, Attributes moduleAttributes, ConcreteSyntaxTree wr) {
    // TODO write import header to wr
    return wr.NewBlock($"namespace {moduleName}" , $"end {moduleName}", BlockStyle.Newline, BlockStyle.Nothing);
  }

  protected override string GetHelperModuleName() {
    throw new NotImplementedException();
  }

  protected override IClassWriter CreateClass(string moduleName, bool isExtern, string fullPrintName, List<TypeParameter> typeParameters, TopLevelDecl cls, List<Type> superClasses, IOrigin tok, ConcreteSyntaxTree wr) {
    return new TopLevelFunctionWriter(this, cls, wr.NewBlock($"namespace {cls.Name}" , $"end {cls.Name}", BlockStyle.Newline, BlockStyle.Nothing));
  }

  protected override IClassWriter CreateTrait(string name, bool isExtern, List<TypeParameter> typeParameters, TraitDecl trait, List<Type> superClasses, IOrigin tok, ConcreteSyntaxTree wr) {
    throw new UnsupportedFeatureException(tok, Feature.Traits);
  }

  protected override ConcreteSyntaxTree CreateIterator(IteratorDecl iter, ConcreteSyntaxTree wr) {
    throw new UnsupportedFeatureException(iter.StartToken, Feature.Iterators);
  }

  protected override IClassWriter DeclareDatatype(DatatypeDecl dt, ConcreteSyntaxTree wr) {
    if (dt.Ctors.Count > 1)
    {
      // Inductive
      Contract.Assert(dt.Members.Count == 0); // This is to make sure that the inductive datatype has no function members
      wr.WriteLine($"inductive {dt.Name} where");
      foreach (var ctor in dt.Ctors) {
        wr.Write($"| {ctor.Name.ToLower()}");
        WriteFormals(" ", ctor.Formals, wr);
        wr.WriteLine();
      }
      
      wr.WriteLine("deriving Inhabited, DecidableEq");

      foreach (var ctor in dt.Ctors) {
        if (ctor.Formals.Count == 1) {
          wr.WriteLine($"def {dt.Name}.get{ctor.Name.ToLower()} (m : {dt.Name}) : {TypeName(ctor.Formals[0].Type, wr, ctor.Origin)} :=");
          wr.WriteLine("match m with");
          wr.WriteLine($"| .{ctor.Name.ToLower()} this => this");
          wr.WriteLine($"| _ => default");
        }
      }
      
      foreach (var ctor in dt.Ctors) {
        if (ctor.Formals.Count == 1) {
          wr.WriteLine($"def {dt.Name}.is{ctor.Name.ToLower()} (m : {dt.Name}) : Bool :=");
          wr.WriteLine("match m with");
          wr.WriteLine($"| .{ctor.Name.ToLower()} _ => true");
          wr.WriteLine($"| _ => false");
        }
      }
      
      return new NullClassWriter(this);
    }
    else
    {
      // Structure
      var structName = dt.Name;
      Contract.Assert(dt.Ctors.Count == 1);
      var ctor = dt.Ctors[0];
      var wrFunctions = wr;
      wr = wr.NewBlock(header: $"structure {structName} where", open: BlockStyle.Newline, close: BlockStyle.Newline);
      var wrindent = wr.WriteLine($"{ctor.Name} ::");
      foreach (var field in ctor.Formals) {
        wrindent = wrindent.WriteLine($"{field.Name} : {TypeName(field.Type, wrindent, field.Origin)}");
      }
      wr.WriteLine("deriving Inhabited, DecidableEq");
      return new StructureWriter(this, dt, wrFunctions);
    }
  }

  protected override void CompileReturnBody(Expression body, Type resultType, ConcreteSyntaxTree wr,
    [CanBeNull] IVariable accumulatorVar) {
    EmitExpr(body, false, wr, wr.Fork());
  }

  public override void EmitExpr(Expression expr, bool inLetExprBody, ConcreteSyntaxTree wr, ConcreteSyntaxTree wStmts) {
    switch (expr) {
      case ForallExpr forallExpr: // Overriding the lambda hell from SinglePassCodeGenerator
        Contract.Assert(forallExpr.BoundVars.Count == 1);
        var bv = forallExpr.BoundVars[0];
        Contract.Assert(forallExpr.Bounds != null);
        CompileCollection(forallExpr.Bounds[0], bv, inLetExprBody, false, null, out var wrCollection, out _, wStmts, forallExpr.Bounds, forallExpr.BoundVars);
        EmitQuantifierExpr(wrCollection, true, forallExpr.BoundVars[0].Type, forallExpr.BoundVars[0], wr);
        EmitExpr(forallExpr.Term, inLetExprBody, wr, wStmts);
        break;
      case LetExpr letExpr: // Destructuring let
        var wrVars = wr.Write("let ");
        Contract.Assert(letExpr.LHSs.Count == 1);
        var Lhs = letExpr.LHSs.First();
        if (Lhs.Vars.Count() > 1) {
          wrVars = wr.NewBlock(header: "(", footer: ")", open: BlockStyle.Nothing, close: BlockStyle.Space);
        }
        TrExprList(Lhs.Vars.Select(Expression (bv) => new IdentifierExpr(letExpr.Origin, bv)).ToList(), wrVars, inLetExprBody, wStmts, parens: false);
        wr = wr.Write(":= ");
        Contract.Assert(letExpr.RHSs.Count == 1);
        EmitExpr(letExpr.RHSs.First(), inLetExprBody, wr, wStmts);
        wr.WriteLine();
        EmitExpr(letExpr.Body, inLetExprBody, wr, wStmts);
        break;
      case DatatypeValue datatypeValue:
        EmitApplyExpr(null, datatypeValue.Origin, new IdentifierExpr(datatypeValue.Origin, new BoundVar(datatypeValue.Origin, $"{datatypeValue.DatatypeName}.{datatypeValue.Ctor.Name.ToLower()}")), datatypeValue.Arguments, inLetExprBody, wr, wStmts);
        break;
      case DatatypeUpdateExpr updateExpr:
        void Flatten() {
          if (updateExpr.Root is DatatypeUpdateExpr inner) {
            updateExpr.Root = inner.Root;
            updateExpr.Updates.AddRange(inner.Updates);
            Flatten();
          }
        }
        
        Flatten();

        var dt = updateExpr.Root.Type.AsIndDatatype;
        if (dt.Ctors.Count > 1) {
          Contract.Assert(updateExpr.Updates.Count == 1);
          var update = updateExpr.Updates.First();
          wr.Write($"{dt.Name}.{update.Item2.CapitaliseFirstLetter()} ");
          wr = wr.ForkInParens();
          EmitExpr(update.Item3, inLetExprBody, wr, wStmts);
        } else {
          wr = wr.NewBlock(header: " ", open: BlockStyle.Brace, close: BlockStyle.SpaceBrace);
          EmitExpr(updateExpr.Root, inLetExprBody, wr, wStmts);
          wr.Write(" with ");
          wr.Comma(updateExpr.Updates, update => {
            EmitIdentifier(update.Item2, wr);
            wr = wr.Write(" := ");
            EmitExpr(update.Item3, inLetExprBody, wr, wStmts);
          });
        }

        break;
      case ITEExpr iteExpr:
        EmitExpr(iteExpr.Test, inLetExprBody, wr.NewBlock(header: "if", footer: " then", open: BlockStyle.Space, close: BlockStyle.Newline), wStmts);
        EmitExpr(iteExpr.Thn, inLetExprBody, wr, wStmts);
        wr = wr.Write(" else ");
        EmitExpr(iteExpr.Els, inLetExprBody, wr, wStmts);
        break;
      case MemberSelectExpr { Obj: { Type: var type } lhs, Member: DatatypeDestructor field }:
        if (type.AsIndDatatype.Ctors.Count > 1) {
          wr.Write($"{type.AsIndDatatype.Name}.get{field.EnclosingCtors[0].Name.ToLower()} ");
          EmitExpr(lhs, inLetExprBody, wr.ForkInParens(), wStmts);
          break;
        } else {
          goto default;
        }
      case MemberSelectExpr { Obj: var lhs, Member: SpecialField { SpecialId: SpecialField.ID.UseIdParam, IdParam: string rhs } }:
        if (rhs.StartsWith("is")) {
          wr.Write($"{TypeName(lhs.Type, wr, lhs.Origin)}.is{rhs[3..].ToLower()} ");
          EmitExpr(lhs, inLetExprBody, wr.ForkInParens(), wStmts);
          break;
        }
        goto default;
      case ParensExpression { E: var inner }:
        EmitExpr(inner, inLetExprBody, wr.ForkInParens(), wStmts);
        break;
      case SetComprehension { BoundVars: [var element], Range: var predicate }:
        wr = wr.NewBlock(open: BlockStyle.SpaceBrace, close: BlockStyle.SpaceBrace);
        EmitIdentifier(element.Name, wr);
        wr.Write(" | ");
        EmitExpr(predicate, inLetExprBody, wr, wStmts);
        break;
      case MapComprehension { BoundVars: [var idx], TermLeft: var key, Range: var predicate, Term: var value }:
        key ??= new IdentifierExpr(idx.Origin, idx);
        wr.Write("λ ");
        EmitExpr(key, inLetExprBody, wr, wStmts);
        wr.Write("=> ");
        var wrPredicate = wr.NewBlock(header: "if", footer: " then part.some", open: BlockStyle.Space, close: BlockStyle.Space);
        EmitExpr(predicate, inLetExprBody, wrPredicate, wStmts);
        EmitExpr(value, inLetExprBody, wr, wStmts);
        wr.Write(" else part.none");
        break;
      default:
        base.EmitExpr(expr, inLetExprBody, wr, wStmts);
        break;
    }
  }
  
  // NB: TrExprOpt is used to compile the body of functions; we just redirect it to EmitExpr
  protected override void TrExprOpt(Expression expr, Type resultType, ConcreteSyntaxTree wr, ConcreteSyntaxTree wStmts,
    bool inLetExprBody, [CanBeNull] IVariable accumulatorVar, OptimizedExpressionContinuation continuation) {
    EmitExpr(expr, inLetExprBody, wr, wStmts);
  }
  
  protected override void EmitNestedMatchExpr(NestedMatchExpr e, bool inLetExprBody, ConcreteSyntaxTree wr, ConcreteSyntaxTree wStmts) {
    EmitExpr(e.Source, inLetExprBody, wr.NewBlock(header: "match", footer: " with", open: BlockStyle.Space, close: BlockStyle.Newline), wStmts);
    foreach (var @case in e.Cases) {
      var wrPattern = wr.NewBlock(header: "|", footer: " :=", open: BlockStyle.Space, close: BlockStyle.Space);
      EmitExtendedPattern(@case.Pat, inLetExprBody, wrPattern, wStmts);
      EmitExpr(@case.Body, inLetExprBody, wr, wStmts);
      wr.WriteLine();
    }
    wr.WriteLine("end");
  }

  private void EmitExtendedPattern(ExtendedPattern extendedPattern, bool inLetExprBody, ConcreteSyntaxTree wr, ConcreteSyntaxTree wStmts)
  {
    switch (extendedPattern) {
      case IdPattern idPattern:
        EmitIdentifier(idPattern.Id.ToLower(), wr);
        if (idPattern.Arguments is { } args) {
          wr.Write(" ");
          wr.Comma(" ", args, ep => EmitExtendedPattern(ep, inLetExprBody, wr, wStmts));
        }
        break;
      case LitPattern litPattern:
        EmitExpr(litPattern.OrigLit, inLetExprBody, wr, wStmts);
        break;
      case DisjunctivePattern disjunctivePattern:
      default:
        throw new ArgumentOutOfRangeException(nameof(extendedPattern), "Disjunctive patterns not supported by Lean code generator.");
    }
  }

  protected override void EmitMatchExpr(MatchExpr e, bool inLetExprBody, ConcreteSyntaxTree wr, ConcreteSyntaxTree wStmts) {
    // Reduces a base pattern match to a nested one
    EmitNestedMatchExpr(new NestedMatchExpr(e.Origin, e.Source, e.Cases.Select(
      @case => new NestedMatchCaseExpr(@case.Origin, new LitPattern(@case.Origin,
        new DatatypeValue(@case.Origin, @case.Ctor.EnclosingDatatype.Name, @case.Ctor.Name, @case.Arguments.Select(
          Expression (bv) => new IdentifierExpr(bv.Origin, bv)).ToList())), @case.Body, @case.Attributes)).ToList(),
      false), inLetExprBody, wr, wStmts);
  }
  
  protected override string IdName(IVariable v) {
    Contract.Requires(v != null);
    return v.Name;
  }

  protected override IClassWriter DeclareNewtype(NewtypeDecl nt, ConcreteSyntaxTree wr) {
    wr.Write("abbrev ");
    EmitIdentifier(nt.Name, wr);
    wr.Write($" := {TypeName(nt.BaseType, wr, nt.Origin)}");
    return new NullClassWriter(this);
  }

  protected override void DeclareSubsetType(SubsetTypeDecl sst, ConcreteSyntaxTree wr) {
    throw new UnsupportedFeatureException(sst.StartToken, Feature.SubsetTypeTests);
  }

  protected override void GetNativeInfo(NativeType.Selection sel, out string name, out string literalSuffix, out bool needsCastAfterArithmetic) {
    throw new NotImplementedException();
  }

  protected override string TypeDescriptor(Type type, ConcreteSyntaxTree wr, IOrigin tok) {
    throw new UnsupportedFeatureException(Token.NoToken, Feature.RuntimeTypeDescriptors);
  }

  protected override ConcreteSyntaxTree EmitTailCallStructure(MemberDecl member, ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override void EmitJumpToTailCallStart(ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  internal override string TypeName(Type type, ConcreteSyntaxTree wr, IOrigin tok, MemberDecl member = null) =>
    type switch {
      BoolType => "Bool",
      CharType => "Char",
      IntType => "Int",
      MapType { Domain: var domain, Range: var range } =>
        $"PFun ({TypeName(domain, wr, tok, member)}) ({TypeName(range, wr, tok, member)})",
      MultiSetType multiSetType => throw new NotImplementedException(),
      SeqType { Arg: var argType } => $"List ({TypeName(argType, wr, tok, member)})",
      SetType { Arg: var argType } => $"Set ({TypeName(argType, wr, tok, member)})",
      UserDefinedType { Name: "nat" } => "Nat",
      UserDefinedType { Name: "_tuple#0" } => "Unit",
      UserDefinedType { Name: "_tuple#2", TypeArgs: [var fst, var snd] } => $"{TypeName(fst, wr, tok, member)} × {TypeName(snd, wr, tok, member)}",
      UserDefinedType { Name: var name } => name,
      _ => throw new ArgumentOutOfRangeException(nameof(type))
    };

  protected override string TypeInitializationValue(Type type, ConcreteSyntaxTree wr, IOrigin tok, bool usePlaceboValue,
    bool constructTypeParameterDefaultsFromTypeDescriptors) {
    throw new NotImplementedException();
  }

  protected override string TypeName_UDT(string fullCompileName, List<TypeParameter.TPVariance> variance, List<Type> typeArgs, ConcreteSyntaxTree wr, IOrigin tok,
    bool omitTypeArguments) {
    throw new NotImplementedException();
  }

  internal override string TypeName_Companion(Type type, ConcreteSyntaxTree wr, IOrigin tok, MemberDecl member) {
   return TypeName(type, wr, tok, member);
  }

  protected override bool DeclareFormal(string prefix, string name, Type type, IOrigin tok, bool isInParam, ConcreteSyntaxTree wr) {
    wr.Write($"{prefix}({name} : {TypeName(type, wr, tok)})");
    return false;
  }

  protected override void DeclareLocalVar(string name, Type type, IOrigin tok, bool leaveRoomForRhs, string rhs, ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override ConcreteSyntaxTree DeclareLocalVar(string name, Type type, IOrigin tok, ConcreteSyntaxTree wr) {
    return wr.NewBlock($"let {name} :=", "", BlockStyle.Space, BlockStyle.Newline);
  }

  protected override void DeclareLocalOutVar(string name, Type type, IOrigin tok, string rhs, bool useReturnStyleOuts,
    ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override void EmitActualTypeArgs(List<Type> typeArgs, IOrigin tok, ConcreteSyntaxTree wr) {
    wr.Write(TypeNames(typeArgs, wr, tok));
  }
  
  protected override string/*!*/ TypeNames(List<Type/*!*/>/*!*/ types, ConcreteSyntaxTree wr, IOrigin tok) {
    Contract.Requires(cce.NonNullElements(types));
    Contract.Ensures(Contract.Result<string>() != null);
    return Util.Comma(" ", types, ty => TypeName(ty, wr, tok));
  }

  protected override void EmitPrintStmt(ConcreteSyntaxTree wr, Expression arg) {
    throw new NotImplementedException();
  }

  protected override void EmitReturn(List<Formal> outParams, ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override ConcreteSyntaxTree CreateLabeledCode(string label, bool createContinueLabel, ConcreteSyntaxTree wr) {
    throw new UnsupportedFeatureException(Token.NoToken, 0, "imperative code");
  }

  protected override void EmitBreak(string label, ConcreteSyntaxTree wr) {
    throw new UnsupportedFeatureException(Token.NoToken, 0, "imperative code");
  }

  protected override void EmitContinue(string label, ConcreteSyntaxTree wr) {
    throw new UnsupportedFeatureException(Token.NoToken, 0, "imperative code");
  }

  protected override void EmitYield(ConcreteSyntaxTree wr) {
    throw new UnsupportedFeatureException(Token.NoToken, 0, "imperative code");
  }

  protected override void EmitAbsurd(string message, ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override void EmitHalt(IOrigin tok, Expression messageExpr, ConcreteSyntaxTree wr) {
    throw new UnsupportedFeatureException(Token.NoToken, 0, "imperative code");
  }

  protected override ConcreteSyntaxTree EmitForStmt(IOrigin tok, IVariable loopIndex, bool goingUp, string endVarName, List<Statement> body,
    LList<Label> labels, ConcreteSyntaxTree wr) {
    throw new UnsupportedFeatureException(Token.NoToken, Feature.ForLoops, "imperative code");
  }

  protected override ConcreteSyntaxTree CreateForLoop(string indexVar, Action<ConcreteSyntaxTree> bound, ConcreteSyntaxTree wr, string start = null) {
    throw new UnsupportedFeatureException(Token.NoToken, Feature.ForLoops, "imperative code");
  }

  protected override ConcreteSyntaxTree CreateDoublingForLoop(string indexVar, int start, ConcreteSyntaxTree wr) {
    throw new UnsupportedFeatureException(Token.NoToken, Feature.ForLoops, "imperative code");
  }

  protected override void EmitIncrementVar(string varName, ConcreteSyntaxTree wr) {
    throw new UnsupportedFeatureException(Token.NoToken, 0, "imperative code");
  }

  protected override void EmitDecrementVar(string varName, ConcreteSyntaxTree wr) {
    throw new UnsupportedFeatureException(Token.NoToken, 0, "imperative code");
  }

  protected override string GetQuantifierName(string bvType) {
    return ""; // TODO
  }

  protected override ConcreteSyntaxTree CreateForeachLoop(string tmpVarName, Type collectionElementType, IOrigin tok,
    out ConcreteSyntaxTree collectionWriter, ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override Action<ConcreteSyntaxTree> GetSubtypeCondition(string tmpVarName, Type boundVarType, IOrigin tok, ConcreteSyntaxTree wPreconditions) {
    throw new NotImplementedException();
  }

  protected override void EmitDowncastVariableAssignment(string boundVarName, Type boundVarType, string tmpVarName, Type sourceType,
    bool introduceBoundVar, IOrigin tok, ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override ConcreteSyntaxTree CreateForeachIngredientLoop(string boundVarName, int L, string tupleTypeArgs,
    out ConcreteSyntaxTree collectionWriter, ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override void EmitNew(Type type, IOrigin tok, CallStmt initCall, ConcreteSyntaxTree wr, ConcreteSyntaxTree wStmts) {
    throw new NotImplementedException();
  }

  protected override void EmitNewArray(Type elementType, IOrigin tok, List<string> dimensions, bool mustInitialize, string exampleElement,
    ConcreteSyntaxTree wr, ConcreteSyntaxTree wStmts) {
    throw new NotImplementedException();
  }

  protected override void EmitLiteralExpr(ConcreteSyntaxTree wr, LiteralExpr e) {
    switch(e)
    {
      case CharLiteralExpr { Value: var value }:
        wr.Write($"'{value}'");
        break;
      case StringLiteralExpr { Value: var value }:
        wr.Write($"\"{value}\"");
        break;
      case StaticReceiverExpr:
        break;
      default:
        // NB: Integer/Decimal/Boolean literal
        wr.Write($"{e}");
        break;
    }
  }

  protected override void EmitStringLiteral(string str, bool isVerbatim, ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override ConcreteSyntaxTree EmitBitvectorTruncation(BitvectorType bvType, NativeType nativeType, bool surroundByUnchecked,
    ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override void EmitRotate(Expression e0, Expression e1, bool isRotateLeft, ConcreteSyntaxTree wr, bool inLetExprBody,
    ConcreteSyntaxTree wStmts, FCE_Arg_Translator tr) {
    throw new NotImplementedException();
  }

  protected override void EmitEmptyTupleList(string tupleTypeArgs, ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override ConcreteSyntaxTree EmitAddTupleToList(string ingredients, string tupleTypeArgs, ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override void EmitTupleSelect(string prefix, int i, ConcreteSyntaxTree wr) {
    i = i + 1;
    wr.Write($"{prefix}.{i}");
  }

  protected override string FullTypeName(UserDefinedType udt, MemberDecl member = null) {
    throw new NotImplementedException();
  }

  protected override void EmitThis(ConcreteSyntaxTree wr, bool callToInheritedMember = false) {
    wr.Write("this");
  }

  protected override void EmitDatatypeValue(DatatypeValue dtv, string typeDescriptorArguments, string arguments, ConcreteSyntaxTree wr) {
    wr.Write($"{dtv.DatatypeName}.{dtv.Ctor.Name} {arguments}");
  }

  protected override void GetSpecialFieldInfo(SpecialField.ID id, object idParam, Type receiverType, out string compiledName, out string preString,
    out string postString) {
    // this is where tuple select happens
    preString = "";
    postString = "";
    switch(id) {
      case SpecialField.ID.UseIdParam:
        if (idParam is string field) {
          if (field.StartsWith("dtor__")) {
            compiledName = (int.Parse(field.Substring("dtor__".Length)) + 1).ToString();
          } else {
            compiledName = field;
          }
        } else {
          throw new ArgumentOutOfRangeException(nameof(idParam), "Impossible. idParam will always be a string");
        }
        break;
      case SpecialField.ID.Keys: // TODO
        compiledName = "dom";
        break;
      case SpecialField.ID.Values: // TODO
        compiledName = "range";
        break;
      default:
        throw new ArgumentOutOfRangeException(nameof(id), id, null);
    }
  }

  protected override ILvalue EmitMemberSelect(Action<ConcreteSyntaxTree> obj, Type objType, MemberDecl member, List<TypeArgumentInstantiation> typeArgs, Dictionary<TypeParameter, Type> typeMap,
    Type expectedType, string additionalCustomParameter = null, bool internalAccess = false) {
    string suffix;
    if (member.Name is "Values") {
      return EnclosedLvalue("PFun.ran (", obj, ")");
    } else if (int.TryParse(member.Name, out var tupleDtor)) {
      suffix = $".{tupleDtor + 1}";
    } else {
      suffix = $".{member.Name}";
    }
    return SuffixLvalue(obj, suffix);
  }

  protected override ConcreteSyntaxTree EmitArraySelect(List<Action<ConcreteSyntaxTree>> indices, Type elmtType, ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override ConcreteSyntaxTree EmitArraySelect(List<Expression> indices, Type elmtType, bool inLetExprBody, ConcreteSyntaxTree wr,
    ConcreteSyntaxTree wStmts) {
    throw new NotImplementedException();
  }

  protected override void EmitExprAsNativeInt(Expression expr, bool inLetExprBody, ConcreteSyntaxTree wr, ConcreteSyntaxTree wStmts) {
    throw new NotImplementedException();
  }

  protected override void EmitIndexCollectionSelect(Expression source, Expression index, bool inLetExprBody, ConcreteSyntaxTree wr,
    ConcreteSyntaxTree wStmts) {
    wr.Write("PFun.fn (");
    EmitExpr(source, inLetExprBody, wr, wStmts );
    wr.Write(") (");
    EmitExpr(index, inLetExprBody, wr, wStmts);
    wr.Write(") (by sorry)");
  }

  protected override void EmitIndexCollectionUpdate(Expression source, Expression index, Expression value,
    CollectionType resultCollectionType, bool inLetExprBody, ConcreteSyntaxTree wr, ConcreteSyntaxTree wStmts) {
    wr.Write("Map.update");
    foreach (var arg in ImmutableArray<Expression>.Empty.Concat([source, index, value])) {
      wr.Write(" ");
      EmitExpr(arg, inLetExprBody, wr.ForkInParens(), wStmts);
    }
  }

  protected override void EmitSeqSelectRange(Expression source, Expression lo, Expression hi, bool fromArray, bool inLetExprBody,
    ConcreteSyntaxTree wr, ConcreteSyntaxTree wStmts) {
    wr.Write("List.tail! ");
    EmitExpr(source, inLetExprBody, wr.ForkInParens(), wStmts);
    // TODO eventually implement slicing 😂
  }

  protected override void EmitSeqConstructionExpr(SeqConstructionExpr expr, bool inLetExprBody, ConcreteSyntaxTree wr,
    ConcreteSyntaxTree wStmts) {
    throw new NotImplementedException();
  }

  protected override void EmitMultiSetFormingExpr(MultiSetFormingExpr expr, bool inLetExprBody, ConcreteSyntaxTree wr,
    ConcreteSyntaxTree wStmts) {
    throw new NotImplementedException();
  }

  protected override void EmitApplyExpr(Type functionType, IOrigin tok, Expression function, List<Expression> arguments, bool inLetExprBody,
    ConcreteSyntaxTree wr, ConcreteSyntaxTree wStmts) {
    var sep = " ";
    if (function is IdentifierExpr { Name: var name } && name.StartsWith("_tuple#")) {
      wr = wr.ForkInParens();
      sep = ", ";
    } else {
      EmitExpr(function, inLetExprBody, wr, wStmts);
      wr.Write(" ");
    }
    foreach (var arg in arguments) {
      EmitExpr(arg, inLetExprBody, wr.ForkInParens(), wStmts);
      wr.Write(sep);
    }
  }
  
  protected override void CompileFunctionCallExpr(FunctionCallExpr e, ConcreteSyntaxTree wr, bool inLetExprBody,
    ConcreteSyntaxTree wStmts, FCE_Arg_Translator tr, bool alreadyCoerced = false) {
    EmitIdentifier($"{TypeName(e.Receiver.Type, wr, e.Origin)}.{e.Name}", wr);
    wr.Write(" ");
    tr(e.Receiver, wr, inLetExprBody, wStmts);
    wr.Write(" ");
    foreach (var arg in e.Args) {
      EmitExpr(arg, inLetExprBody, wr.ForkInParens(), wStmts);
      wr.Write(" ");
    }
  }

  protected override ConcreteSyntaxTree EmitBetaRedex(List<string> boundVars, List<Expression> arguments, List<Type> boundTypes, Type resultType, IOrigin resultTok,
    bool inLetExprBody, ConcreteSyntaxTree wr, ref ConcreteSyntaxTree wStmts) {
    throw new NotImplementedException();
  }

  protected override void EmitDestructor(Action<ConcreteSyntaxTree> source, Formal dtor, int formalNonGhostIndex, DatatypeCtor ctor, Func<List<Type>> getTypeArgs,
    Type bvType, ConcreteSyntaxTree wr) {
    source(wr);
    wr.Write($".{dtor.Name}");
  }

  protected override ConcreteSyntaxTree CreateLambda(List<Type> inTypes, IOrigin tok, List<string> inNames, Type resultType, ConcreteSyntaxTree wr,
    ConcreteSyntaxTree wStmts, bool untyped = false) {
    throw new NotImplementedException();
  }

  protected override ConcreteSyntaxTree EmitQuantifierExpr(Action<ConcreteSyntaxTree> collection, bool isForall,
    Type collectionElementType, BoundVar bv, ConcreteSyntaxTree wr) {
    wr = wr.Write($"∀ ");
    var @var = bv.Name;
    EmitIdentifier(@var, wr);
    wr = wr.Write($", ");
    // EmitIdentifier(@var, wr);
    // wr = wr.Write($" ∈ ");
    // collection(wr);
    //return wr.Write($"→");
    return wr;
  }

  protected override void CreateIIFE(string bvName, Type bvType, IOrigin bvTok, Type bodyType, IOrigin bodyTok, ConcreteSyntaxTree wr,
    ref ConcreteSyntaxTree wStmts, out ConcreteSyntaxTree wrRhs, out ConcreteSyntaxTree wrBody) {
    throw new NotImplementedException();
  }

  protected override ConcreteSyntaxTree CreateIIFE0(Type resultType, IOrigin resultTok, ConcreteSyntaxTree wr, ConcreteSyntaxTree wStmts) {
    throw new NotImplementedException();
  }

  protected override ConcreteSyntaxTree CreateIIFE1(int source, Type resultType, IOrigin resultTok, string bvName, ConcreteSyntaxTree wr,
    ConcreteSyntaxTree wStmts) {
    throw new NotImplementedException();
  }

  protected override void EmitUnaryExpr(ResolvedUnaryOp op, Expression expr, bool inLetExprBody, ConcreteSyntaxTree wr,
    ConcreteSyntaxTree wStmts) {
    switch (op) {
      case ResolvedUnaryOp.BoolNot:
        wr.Write("!"); 
        EmitExpr(expr, inLetExprBody, wr, wStmts);
        break;
      case ResolvedUnaryOp.Cardinality:
        wr.Write("Set.ncard ");
        if (expr.Type is MapType) {
          wr = wr.ForkInParens();
          wr.Write("PFun.Dom ");
        }
        EmitExpr(expr, inLetExprBody, wr.ForkInParens(), wStmts);
        break;
      default:
        throw new ArgumentOutOfRangeException(nameof(op), op, null);
    }
  }

  protected override void CompileBinOp(BinaryExpr.ResolvedOpcode op,
    Type e0Type, Type e1Type, IOrigin tok, Type resultType,
    out string opString,
    out string preOpString,
    out string postOpString,
    out string callString,
    out string staticCallString,
    out bool reverseArguments,
    out bool truncateResult,
    out bool convertE1_to_int,
    out bool coerceE1,
    ConcreteSyntaxTree errorWr) {
    opString = "";
    preOpString = "";
    postOpString = "";
    callString = null;
    staticCallString = null;
    reverseArguments = false;
    truncateResult = false;
    convertE1_to_int = false;
    coerceE1 = false;
    switch (op) {
      case BinaryExpr.ResolvedOpcode.Iff:
        opString = "↔"; break;
      case BinaryExpr.ResolvedOpcode.Imp:
        opString = "→"; break;
      case BinaryExpr.ResolvedOpcode.And:
        opString = "∧"; break;
      case BinaryExpr.ResolvedOpcode.Or:
        opString = "∨"; break;
      case BinaryExpr.ResolvedOpcode.EqCommon:
        opString = "="; break;
      case BinaryExpr.ResolvedOpcode.NeqCommon:
        opString = "≠"; break;
      
      case BinaryExpr.ResolvedOpcode.Lt:
        opString = "<"; break;
      case BinaryExpr.ResolvedOpcode.Le:
        opString = "≤"; break;
      case BinaryExpr.ResolvedOpcode.Ge:
        opString = "≥"; break;
      case BinaryExpr.ResolvedOpcode.Gt:
        opString = ">"; break;
      
      
      case BinaryExpr.ResolvedOpcode.BitwiseAnd:
        break;
      case BinaryExpr.ResolvedOpcode.BitwiseOr:
        break;
      case BinaryExpr.ResolvedOpcode.BitwiseXor:
        break;
      case BinaryExpr.ResolvedOpcode.LtChar:
        break;
      case BinaryExpr.ResolvedOpcode.LeChar:
        break;
      case BinaryExpr.ResolvedOpcode.GeChar:
        break;
      case BinaryExpr.ResolvedOpcode.GtChar:
        break;
      case BinaryExpr.ResolvedOpcode.SetEq:
        break;
      case BinaryExpr.ResolvedOpcode.SetNeq:
        break;
      case BinaryExpr.ResolvedOpcode.ProperSubset:
        break;
      case BinaryExpr.ResolvedOpcode.Subset:
        break;
      case BinaryExpr.ResolvedOpcode.Superset:
        break;
      case BinaryExpr.ResolvedOpcode.ProperSuperset:
        break;
      case BinaryExpr.ResolvedOpcode.Disjoint:
        break;
      case BinaryExpr.ResolvedOpcode.InSet:
        opString = "∈";
        break;
      case BinaryExpr.ResolvedOpcode.NotInSet:
        opString = "∉";
        break;
      case BinaryExpr.ResolvedOpcode.Union:
        opString = "∪";
        break;
      case BinaryExpr.ResolvedOpcode.Intersection:
        opString = "∩";
        break;
      case BinaryExpr.ResolvedOpcode.SetDifference:
        opString = "\\";
        break;
      case BinaryExpr.ResolvedOpcode.MultiSetEq:
        break;
      case BinaryExpr.ResolvedOpcode.MultiSetNeq:
        break;
      case BinaryExpr.ResolvedOpcode.MultiSubset:
        break;
      case BinaryExpr.ResolvedOpcode.MultiSuperset:
        break;
      case BinaryExpr.ResolvedOpcode.ProperMultiSubset:
        break;
      case BinaryExpr.ResolvedOpcode.ProperMultiSuperset:
        break;
      case BinaryExpr.ResolvedOpcode.MultiSetDisjoint:
        break;
      case BinaryExpr.ResolvedOpcode.InMultiSet:
        opString = "∈";
        break;
      case BinaryExpr.ResolvedOpcode.NotInMultiSet:
        opString = "∉";
        break;
      case BinaryExpr.ResolvedOpcode.MultiSetUnion:
        break;
      case BinaryExpr.ResolvedOpcode.MultiSetIntersection:
        break;
      case BinaryExpr.ResolvedOpcode.MultiSetDifference:
        break;
      case BinaryExpr.ResolvedOpcode.SeqEq:
        break;
      case BinaryExpr.ResolvedOpcode.SeqNeq:
        break;
      case BinaryExpr.ResolvedOpcode.ProperPrefix:
        break;
      case BinaryExpr.ResolvedOpcode.Prefix:
        break;
      case BinaryExpr.ResolvedOpcode.Concat:
        opString = "++";
        break;
      case BinaryExpr.ResolvedOpcode.InSeq:
        opString = "∈";
        break;
      case BinaryExpr.ResolvedOpcode.NotInSeq:
        break;
      case BinaryExpr.ResolvedOpcode.MapEq:
        break;
      case BinaryExpr.ResolvedOpcode.MapNeq:
        break;
      case BinaryExpr.ResolvedOpcode.InMap:
        opString = "∈ PFun.Dom (";
        postOpString = ")";
        break;
      case BinaryExpr.ResolvedOpcode.NotInMap:
        break;
      case BinaryExpr.ResolvedOpcode.MapMerge:
        break;
      case BinaryExpr.ResolvedOpcode.MapSubtraction:
        break;
      case BinaryExpr.ResolvedOpcode.RankLt:
        break;
      case BinaryExpr.ResolvedOpcode.RankGt:
        break;
      case BinaryExpr.ResolvedOpcode.YetUndetermined:
      case BinaryExpr.ResolvedOpcode.LessThanLimit:
      case BinaryExpr.ResolvedOpcode.Add:
        opString = "+"; break;
      case BinaryExpr.ResolvedOpcode.Sub:
        opString = "-"; break;
      case BinaryExpr.ResolvedOpcode.Mul:
        opString = "*"; break;
      case BinaryExpr.ResolvedOpcode.Div:
        opString = "/"; break;
      case BinaryExpr.ResolvedOpcode.Mod:
        opString = "%"; break;
      case BinaryExpr.ResolvedOpcode.LeftShift:
      case BinaryExpr.ResolvedOpcode.RightShift:
      default:
        throw new ArgumentOutOfRangeException(nameof(op), op, null);
    }
  }

  protected override void EmitIsZero(string varName, ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override void EmitConversionExpr(Expression fromExpr, Type fromType, Type toType, bool inLetExprBody, ConcreteSyntaxTree wr,
    ConcreteSyntaxTree wStmts) {
    throw new NotImplementedException();
  }

  protected override void EmitTypeTest(string localName, Type fromType, Type toType, IOrigin tok, ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override void EmitIsIntegerTest(Expression source, ConcreteSyntaxTree wr, ConcreteSyntaxTree wStmts) {
    throw new NotImplementedException();
  }

  protected override void EmitIsUnicodeScalarValueTest(Expression source, ConcreteSyntaxTree wr, ConcreteSyntaxTree wStmts) {
    throw new NotImplementedException();
  }

  protected override void EmitIsInIntegerRange(Expression source, BigInteger lo, BigInteger hi, ConcreteSyntaxTree wr,
    ConcreteSyntaxTree wStmts) {
    throw new NotImplementedException();
  }
  
  // Collection display: 
  protected override void EmitCollectionDisplay(CollectionType ct, IOrigin tok, List<Expression> elements, bool inLetExprBody, ConcreteSyntaxTree wr,
    ConcreteSyntaxTree wStmts) {
    switch (ct) {
      case MapType mapType: // TODO
        break;
      case SeqType seqType:
      case SetType setType:
        var wrList = wr.NewBlock(close: BlockStyle.SpaceBrace);
        TrExprList(elements, wrList, inLetExprBody, wStmts, typeAt: null, parens: false);
        break;
      default:
        throw new ArgumentOutOfRangeException(nameof(ct));
    }
  }

  protected override void EmitMapDisplay(MapType mt, IOrigin tok, List<MapDisplayEntry> elements, bool inLetExprBody, ConcreteSyntaxTree wr,
    ConcreteSyntaxTree wStmts) {
    Contract.Assert(elements.Count == 0);
    wr.Write("[]");
  }

  protected override void EmitSetBuilder_New(ConcreteSyntaxTree wr, SetComprehension e, string collectionName) {
    throw new NotImplementedException();
  }

  protected override void EmitMapBuilder_New(ConcreteSyntaxTree wr, MapComprehension e, string collectionName) {
    throw new NotImplementedException();
  }

  protected override void EmitSetBuilder_Add(CollectionType ct, string collName, Expression elmt, bool inLetExprBody, ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override ConcreteSyntaxTree EmitMapBuilder_Add(MapType mt, IOrigin tok, string collName, Expression term, bool inLetExprBody,
    ConcreteSyntaxTree wr) {
    throw new NotImplementedException();
  }

  protected override void GetCollectionBuilder_Build(CollectionType ct, IOrigin tok, string collName, ConcreteSyntaxTree wr,
    ConcreteSyntaxTree wStmt) {
    throw new NotImplementedException();
  }

  protected override void EmitSingleValueGenerator(Expression e, bool inLetExprBody, string type, ConcreteSyntaxTree wr,
    ConcreteSyntaxTree wStmts) {
    throw new NotImplementedException();
  }

  protected override void EmitHaltRecoveryStmt(Statement body, string haltMessageVarName, Statement recoveryBody, ConcreteSyntaxTree wr) {
    throw new UnsupportedFeatureException(body.StartToken, 0);
  }
}