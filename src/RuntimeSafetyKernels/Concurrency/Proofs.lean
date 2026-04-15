import RuntimeSafetyKernels.Concurrency.Spec

namespace RuntimeSafetyKernels.Concurrency.Proofs

open RuntimeSafetyKernels.Concurrency.Spec

theorem initial_state_safe : invariant initialState = true :=
  initial_state_invariant

theorem transition_safe (state : ConcurrencyState) (event : Event) :
  invariant state = true → invariant (transition state event) = true :=
  transition_preserves_invariant state event

theorem state_reachability (state : ConcurrencyState) :
  state = initialState →
  ∃ events : List Event, List.foldl transition initialState events = state := by
  intro hEq
  refine ⟨[], ?_⟩
  simpa [hEq]

end RuntimeSafetyKernels.Concurrency.Proofs
