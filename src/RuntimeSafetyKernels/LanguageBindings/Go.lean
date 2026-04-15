import RuntimeSafetyKernels.Contracts
import RuntimeSafetyKernels.Shape

namespace RuntimeSafetyKernels.LanguageBindings.Go

open RuntimeSafetyKernels.Shape

structure GoShapeValidationResponse where
  valid : Bool
  error : String
  deriving Repr

def validateShapeSafe (dims : List Nat) : GoShapeValidationResponse :=
  if validateShapeAtCompileTime dims then
    ⟨true, ""⟩
  else
    ⟨false, "invalid shape"⟩

def generateGoStub : String :=
  "package rsk\n\nfunc ValidateShapeSafe(dims []uint32) bool { return len(dims) > 0 }\n"

def main (_ : List String := []) : IO Unit := do
  IO.FS.createDirAll "src/extracted"
  IO.FS.writeFile "src/extracted/rsk_go.go" generateGoStub
  IO.println s!"go binding smoke test: {reprStr (validateShapeSafe [2, 3, 4])}"

end RuntimeSafetyKernels.LanguageBindings.Go
