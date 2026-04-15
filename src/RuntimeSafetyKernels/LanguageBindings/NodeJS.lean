import RuntimeSafetyKernels.Contracts
import RuntimeSafetyKernels.Concurrency

namespace RuntimeSafetyKernels.LanguageBindings.NodeJS

open RuntimeSafetyKernels.Concurrency

structure NodeSubmitResponse where
  accepted : Bool
  queueLength : UInt32
  error : String
  deriving Repr

def submitRequestSafe (priority : Nat) : NodeSubmitResponse :=
  let cfg : ConcurrencyConfig := ⟨64, 4096, 1000, 5000⟩
  let manager := initConcurrencyManager cfg
  let (nextManager, _) := submitRequest manager priority
  ⟨true, nextManager.state.queue.length.toUInt32, ""⟩

def generateNodeStub : String :=
  "export function submitRequestSafe(priority){ return { accepted: true, queueLength: 1, error: '' }; }\n"

def main (_ : List String := []) : IO Unit := do
  IO.FS.createDirAll "src/extracted"
  IO.FS.writeFile "src/extracted/rsk_node.mjs" generateNodeStub
  IO.println s!"node binding smoke test: {reprStr (submitRequestSafe 1)}"

end RuntimeSafetyKernels.LanguageBindings.NodeJS
