import RuntimeSafetyKernels.Concurrency.Spec
import RuntimeSafetyKernels.Concurrency.Proofs

namespace RuntimeSafetyKernels.Concurrency

open RuntimeSafetyKernels.Concurrency.Spec

structure ConcurrencyConfig where
  maxWorkers : Nat := 64
  maxRequests : Nat := 4096
  queueTimeout : Nat := 1000
  workerTimeout : Nat := 5000
  deriving Repr

structure ConcurrencyManager where
  state : ConcurrencyState

def initConcurrencyManager (_ : ConcurrencyConfig) : ConcurrencyManager :=
  ⟨initialState⟩

def submitRequest (manager : ConcurrencyManager) (priority : Nat := 0) : ConcurrencyManager × RequestId :=
  let _ := priority
  let reqId := manager.state.nextRequestId
  let event := Event.submitRequest reqId
  ({ manager with state := transition manager.state event }, reqId)

def startProcessing (manager : ConcurrencyManager) (reqId : RequestId) (workerId : WorkerId) : Option ConcurrencyManager :=
  if manager.state.workers workerId = WorkerState.idle then
    let ev := Event.startProcessing reqId workerId manager.state.nextTokenIndex
    some { manager with state := transition manager.state ev }
  else
    none

def completeToken (manager : ConcurrencyManager) (reqId : RequestId) (workerId : WorkerId) (tokenIdx : TokenIndex) : ConcurrencyManager :=
  let ev := Event.completeToken reqId workerId tokenIdx
  { manager with state := transition manager.state ev }

def getIdleWorker (manager : ConcurrencyManager) : Option WorkerId :=
  (getIdleWorkers manager.state).head?

def getNextPendingRequest (manager : ConcurrencyManager) : Option RequestId :=
  (getPendingRequests manager.state).head?

def isHealthy (manager : ConcurrencyManager) : Bool := invariant manager.state

end RuntimeSafetyKernels.Concurrency
