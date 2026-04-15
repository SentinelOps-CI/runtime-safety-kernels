import Lake
open Lake DSL

package runtime_safety_kernels where
  srcDir := "src"

  -- Dependency pinning for reproducible builds.
  require mathlib from git "https://github.com/leanprover-community/mathlib4" @ "v4.8.0"

@[default_target]
lean_lib RuntimeSafetyKernels {
  roots := #[`RuntimeSafetyKernels]
}

-- C extraction target
lean_exe sampler_c {
  root := `RuntimeSafetyKernels.Sampler.Extract
  supportInterpreter := true
}

-- Rust extraction target
lean_exe concurrency_rust {
  root := `RuntimeSafetyKernels.Concurrency.Extract
  supportInterpreter := true
}

-- Policy extraction target
lean_exe policy_c {
  root := `RuntimeSafetyKernels.Policy.Extract
  supportInterpreter := true
}

-- Tensor extraction target
lean_exe tensor_c {
  root := `RuntimeSafetyKernels.Shape.Extract
  supportInterpreter := true
}

-- Test targets
lean_exe tests {
  root := `RuntimeSafetyKernels.Tests
  supportInterpreter := true
}

lean_exe fuzz {
  root := `RuntimeSafetyKernels.Fuzz
  supportInterpreter := true
}

lean_exe benchmarks {
  root := `RuntimeSafetyKernels.Benchmarks
  supportInterpreter := true
}
