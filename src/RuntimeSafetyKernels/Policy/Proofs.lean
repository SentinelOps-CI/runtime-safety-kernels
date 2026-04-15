import RuntimeSafetyKernels.Policy.Spec

namespace RuntimeSafetyKernels.Policy.Proofs

open RuntimeSafetyKernels.Policy.Spec

theorem allow_policy_progress (state : DecoderState) (token : Token) :
  state.policyState.currentTokenCount < state.policyState.maxTokens →
  ∃ newState, policyGatedDecode allowAllPolicy state token = .ok (token, newState) := by
  intro hCount
  refine ⟨{ state with
    policyState := { state.policyState with
      context := state.policyState.context ++ [token]
      currentTokenCount := state.policyState.currentTokenCount + 1
    }
    outputTokens := state.outputTokens ++ [token]
    totalTokensProcessed := state.totalTokensProcessed + 1
  }, ?_⟩
  simp [policyGatedDecode, allowAllPolicy, Nat.not_le.mpr hCount]

end RuntimeSafetyKernels.Policy.Proofs
