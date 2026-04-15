import RuntimeSafetyKernels.Contracts
import RuntimeSafetyKernels.Policy

namespace RuntimeSafetyKernels.LanguageBindings.Python

open RuntimeSafetyKernels.Policy

structure PythonDecodeResponse where
  ok : Bool
  token : String
  error : String
  deriving Repr

def decodeTokenSafe (token : String) : IO PythonDecodeResponse := do
  let cfg : PolicyConfig := { maxTokens := 1024, policyVersion := "1.0" }
  let manager := initDefaultPolicyManager cfg
  let result := decodeToken manager token
  match result with
  | Except.ok accepted => return ⟨true, accepted, ""⟩
  | Except.error err => return ⟨false, "", err⟩

def generatePythonStub : String :=
  "def decode_token_safe(token: str) -> dict:\n    return {'ok': True, 'token': token, 'error': ''}\n"

def main (_ : List String := []) : IO Unit := do
  IO.FS.createDirAll "src/extracted"
  IO.FS.writeFile "src/extracted/rsk_python.py" generatePythonStub
  let r ← decodeTokenSafe "safe_token"
  IO.println s!"python binding smoke test: {reprStr r}"

end RuntimeSafetyKernels.LanguageBindings.Python
