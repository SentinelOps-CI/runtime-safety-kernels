import RuntimeSafetyKernels.Contracts
import RuntimeSafetyKernels.Policy
import RuntimeSafetyKernels.Concurrency
import RuntimeSafetyKernels.Shape
import RuntimeSafetyKernels.Tests
import RuntimeSafetyKernels.Fuzz
import RuntimeSafetyKernels.Benchmarks
import RuntimeSafetyKernels.Policy.Extract
import RuntimeSafetyKernels.Concurrency.Extract
import RuntimeSafetyKernels.Shape.Extract
import RuntimeSafetyKernels.LanguageBindings.Python
import RuntimeSafetyKernels.LanguageBindings.Go
import RuntimeSafetyKernels.LanguageBindings.NodeJS

namespace RuntimeSafetyKernels

def main (args : List String) : IO Unit := do
  match args.head? with
  | some "test" => RuntimeSafetyKernels.Tests.main
  | some "fuzz" => RuntimeSafetyKernels.Fuzz.main (args.drop 1)
  | some "benchmark" => RuntimeSafetyKernels.Benchmarks.main (args.drop 1)
  | some "extract" =>
      RuntimeSafetyKernels.Policy.Extract.main
      RuntimeSafetyKernels.Concurrency.Extract.main
      RuntimeSafetyKernels.Shape.Extract.main
  | some "bindings" =>
      RuntimeSafetyKernels.LanguageBindings.Python.main
      RuntimeSafetyKernels.LanguageBindings.Go.main
      RuntimeSafetyKernels.LanguageBindings.NodeJS.main
  | _ =>
      IO.println "runtime-safety-kernels"
      IO.println "commands: test | fuzz | benchmark | extract | bindings"

end RuntimeSafetyKernels
