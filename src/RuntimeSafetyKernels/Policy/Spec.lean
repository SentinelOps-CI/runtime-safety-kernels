import Mathlib.Data.List.Basic

namespace RuntimeSafetyKernels.Policy.Spec

abbrev Token := String

structure PolicyState where
  context : List Token
  maxTokens : Nat
  currentTokenCount : Nat
  policyVersion : String
  deriving Repr, DecidableEq

inductive PolicyResult
  | allow
  | block (reason : String)
  | rateLimit (delayMs : Nat)
  deriving Repr, DecidableEq

abbrev PolicyGuard := PolicyState → Token → PolicyResult

structure DecoderState where
  policyState : PolicyState
  outputTokens : List Token
  blockedTokens : List Token
  totalTokensProcessed : Nat
  deriving Repr, DecidableEq

def initialDecoderState (maxTokens : Nat := 1000) (policyVersion : String := "1.0") : DecoderState :=
  ⟨⟨[], maxTokens, 0, policyVersion⟩, [], [], 0⟩

def allowAllPolicy : PolicyGuard := fun _ _ => .allow

def blockSpecificTokens (blocked : List Token) : PolicyGuard :=
  fun _ token => if blocked.contains token then .block s!"blocked token: {token}" else .allow

def rateLimitPolicy (maxTokensPerSecond : Nat) : PolicyGuard :=
  fun state _ => if maxTokensPerSecond > 0 && state.currentTokenCount % maxTokensPerSecond = 0 then .rateLimit 1000 else .allow

def contextLengthPolicy (maxContextLength : Nat) : PolicyGuard :=
  fun state _ => if state.context.length >= maxContextLength then .block "Context length exceeded" else .allow

def policyGatedDecode (guard : PolicyGuard) (state : DecoderState) (token : Token) : Except String (Token × DecoderState) :=
  if state.policyState.currentTokenCount >= state.policyState.maxTokens then
    .error "maximum token count exceeded"
  else
    match guard state.policyState token with
    | .allow =>
        let updatedPolicy := { state.policyState with
          context := state.policyState.context ++ [token]
          currentTokenCount := state.policyState.currentTokenCount + 1
        }
        let updatedState := { state with
          policyState := updatedPolicy
          outputTokens := state.outputTokens ++ [token]
          totalTokensProcessed := state.totalTokensProcessed + 1
        }
        .ok (token, updatedState)
    | .block reason =>
        .error s!"Token blocked: {reason}"
    | .rateLimit delay =>
        .error s!"Rate limited: {delay}ms delay"

def policyGuardCalled (state : DecoderState) : Prop :=
  state.totalTokensProcessed = state.outputTokens.length + state.blockedTokens.length

def decoderInvariant (state : DecoderState) : Prop :=
  policyGuardCalled state ∧ state.policyState.currentTokenCount ≤ state.policyState.maxTokens

theorem initial_state_invariant : decoderInvariant (initialDecoderState) := by
  simp [decoderInvariant, initialDecoderState, policyGuardCalled]

end RuntimeSafetyKernels.Policy.Spec
