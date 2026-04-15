import RuntimeSafetyKernels.Contracts
import RuntimeSafetyKernels.Concurrency

namespace RuntimeSafetyKernels.Concurrency.Extract

open RuntimeSafetyKernels.Concurrency

structure CSubmitResult where
  requestId : UInt32
  queueLength : UInt32
  deriving Repr

structure CConcurrencyManager where
  manager : ConcurrencyManager

def newCConcurrencyManager : CConcurrencyManager :=
  let cfg : ConcurrencyConfig := ⟨64, 4096, 1000, 5000⟩
  ⟨initConcurrencyManager cfg⟩

def cSubmitRequest (m : CConcurrencyManager) (priority : UInt32) : CSubmitResult × CConcurrencyManager :=
  let (nextManager, reqId) := submitRequest m.manager priority.toNat
  let result : CSubmitResult := ⟨reqId.val.toUInt32, nextManager.state.queue.length.toUInt32⟩
  (result, ⟨nextManager⟩)

def generateRustModule : String :=
  "pub struct RuntimeSafetyKernelsContract;\n"

def main : IO Unit := do
  IO.FS.createDirAll "src/extracted"
  IO.FS.writeFile "src/extracted/rsk_concurrency.rs" generateRustModule
  let manager := newCConcurrencyManager
  let (result, _) := cSubmitRequest manager 1
  IO.println s!"concurrency extraction smoke test: {reprStr result}"

end RuntimeSafetyKernels.Concurrency.Extract
