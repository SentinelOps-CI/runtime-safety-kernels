namespace RuntimeSafetyKernels.ReliabilityTelemetry

structure ReliabilityEvent where
  component : String
  operation : String
  success : Bool
  detail : String
  deriving Repr

def encode (ev : ReliabilityEvent) : String :=
  s!"component={ev.component};operation={ev.operation};success={ev.success};detail={ev.detail}"

def emit (ev : ReliabilityEvent) : IO Unit := do
  IO.println (encode ev)

end RuntimeSafetyKernels.ReliabilityTelemetry
