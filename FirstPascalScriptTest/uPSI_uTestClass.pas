unit uPSI_uTestClass;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_uTestClass = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTestClass(CL: TPSPascalCompiler);
procedure SIRegister_uTestClass(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTestClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_uTestClass(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   uTestClass
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTestClass]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTestClass(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TOBJECT'),TTestClass) do
  begin
    RegisterPublishedProperties;
    RegisterMethod('Procedure Test( a, b, c, d : String)');
    RegisterProperty('Wurst', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uTestClass(CL: TPSPascalCompiler);
begin
  SIRegister_TTestClass(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTestClassWurst_W(Self: TTestClass; const T: String);
begin Self.Wurst := T; end;

(*----------------------------------------------------------------------------*)
procedure TTestClassWurst_R(Self: TTestClass; var T: String);
begin T := Self.Wurst; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTestClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTestClass) do
  begin
    RegisterMethod(@TTestClass.Test, 'Test');
    RegisterPropertyHelper(@TTestClassWurst_R,@TTestClassWurst_W,'Wurst');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uTestClass(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTestClass(CL);
end;

 
 
{ TPSImport_uTestClass }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTestClass.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTestClass(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTestClass.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTestClass(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
