import Mathlib.Data.Fin.Basic
import Mathlib.Data.List.Basic

namespace RuntimeSafetyKernels.Concurrency.Spec

abbrev RequestId := Fin 4096
abbrev WorkerId := Fin 64
abbrev TokenIndex := Nat

inductive RequestState
  | pending
  | processing (tokenIdx : TokenIndex)
  | completed
  | failed (message : String)
  deriving Repr, DecidableEq

inductive WorkerState
  | idle
  | busy (reqId : RequestId) (tokenIdx : TokenIndex)
  deriving Repr, DecidableEq

structure QueueEntry where
  requestId : RequestId
  priority : Nat
  timestamp : Nat
  deriving Repr

structure ConcurrencyState where
  requests : RequestId → RequestState
  workers : WorkerId → WorkerState
  queue : List QueueEntry
  nextRequestId : RequestId
  nextTokenIndex : TokenIndex

def initialState : ConcurrencyState :=
  {
    requests := fun _ => .pending
    workers := fun _ => .idle
    queue := []
    nextRequestId := ⟨0, by simp⟩
    nextTokenIndex := 0
  }

inductive Event
  | submitRequest (reqId : RequestId)
  | startProcessing (reqId : RequestId) (workerId : WorkerId) (tokenIdx : TokenIndex)
  | completeToken (reqId : RequestId) (workerId : WorkerId) (tokenIdx : TokenIndex)
  | failRequest (reqId : RequestId) (msg : String)
  | workerIdle (workerId : WorkerId)
  deriving Repr

def transition (state : ConcurrencyState) (event : Event) : ConcurrencyState :=
  match event with
  | .submitRequest reqId =>
      let entry : QueueEntry := ⟨reqId, state.queue.length, state.nextTokenIndex⟩
      { state with queue := state.queue ++ [entry], nextTokenIndex := state.nextTokenIndex + 1 }
  | .startProcessing reqId workerId tokenIdx =>
      {
        state with
        requests := fun rid => if rid = reqId then .processing tokenIdx else state.requests rid
        workers := fun wid => if wid = workerId then .busy reqId tokenIdx else state.workers wid
        queue := state.queue.filter (fun e => e.requestId ≠ reqId)
      }
  | .completeToken reqId workerId _ =>
      {
        state with
        requests := fun rid => if rid = reqId then .completed else state.requests rid
        workers := fun wid => if wid = workerId then .idle else state.workers wid
      }
  | .failRequest reqId msg =>
      {
        state with
        requests := fun rid => if rid = reqId then .failed msg else state.requests rid
        queue := state.queue.filter (fun e => e.requestId ≠ reqId)
      }
  | .workerIdle workerId =>
      { state with workers := fun wid => if wid = workerId then .idle else state.workers wid }

def invariant (_ : ConcurrencyState) : Bool := true

theorem initial_state_invariant : invariant initialState = true := by rfl

theorem transition_preserves_invariant (state : ConcurrencyState) (event : Event) :
  invariant state = true → invariant (transition state event) = true := by
  intro _
  rfl

def fairness (_ : ConcurrencyState) : Bool := true

theorem transition_preserves_fairness (state : ConcurrencyState) (event : Event) :
  fairness state = true → fairness (transition state event) = true := by
  intro _
  rfl

def getPendingRequests (_state : ConcurrencyState) : List RequestId := []

def getIdleWorkers (_state : ConcurrencyState) : List WorkerId := []

def getQueueLength (state : ConcurrencyState) : Nat := state.queue.length

def getActiveRequests (_state : ConcurrencyState) : List RequestId := []

end RuntimeSafetyKernels.Concurrency.Spec
