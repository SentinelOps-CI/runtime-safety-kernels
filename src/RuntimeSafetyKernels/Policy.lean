import RuntimeSafetyKernels.Policy.Spec
import RuntimeSafetyKernels.Policy.Proofs

namespace RuntimeSafetyKernels.Policy

open RuntimeSafetyKernels.Policy.Spec

structure PolicyConfig where
  maxTokens : Nat := 1000
  policyVersion : String := "1.0"
  enableRateLimiting : Bool := false
  maxTokensPerSecond : Nat := 100
  enableContextChecking : Bool := false
  maxContextLength : Nat := 1000
  deriving Repr

structure PolicyManager where
  state : DecoderState
  guard : PolicyGuard

def initPolicyManager (config : PolicyConfig) (guard : PolicyGuard) : PolicyManager :=
  ⟨initialDecoderState config.maxTokens config.policyVersion, guard⟩

def initDefaultPolicyManager (config : PolicyConfig) : PolicyManager :=
  initPolicyManager config allowAllPolicy

def initBlockingPolicyManager (config : PolicyConfig) (blockedTokens : List Token) : PolicyManager :=
  initPolicyManager config (blockSpecificTokens blockedTokens)

def initRateLimitPolicyManager (config : PolicyConfig) : PolicyManager :=
  initPolicyManager config (rateLimitPolicy config.maxTokensPerSecond)

def initContextCheckPolicyManager (config : PolicyConfig) : PolicyManager :=
  initPolicyManager config (contextLengthPolicy config.maxContextLength)

def decodeToken (manager : PolicyManager) (token : Token) : Except String Token :=
  match policyGatedDecode manager.guard manager.state token with
  | .ok (accepted, _) => .ok accepted
  | .error err => .error err

def isHealthy (_manager : PolicyManager) : Bool := true

end RuntimeSafetyKernels.Policy
