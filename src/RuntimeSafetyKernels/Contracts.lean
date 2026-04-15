import RuntimeSafetyKernels.Policy.Spec
import RuntimeSafetyKernels.Concurrency.Spec
import RuntimeSafetyKernels.Shape.Spec

namespace RuntimeSafetyKernels.Contracts

abbrev ContractToken := RuntimeSafetyKernels.Policy.Spec.Token
abbrev ContractPolicyState := RuntimeSafetyKernels.Policy.Spec.PolicyState
abbrev ContractDecoderState := RuntimeSafetyKernels.Policy.Spec.DecoderState
abbrev ContractPolicyResult := RuntimeSafetyKernels.Policy.Spec.PolicyResult

abbrev ContractRequestId := RuntimeSafetyKernels.Concurrency.Spec.RequestId
abbrev ContractWorkerId := RuntimeSafetyKernels.Concurrency.Spec.WorkerId
abbrev ContractConcurrencyState := RuntimeSafetyKernels.Concurrency.Spec.ConcurrencyState
abbrev ContractEvent := RuntimeSafetyKernels.Concurrency.Spec.Event

abbrev ContractShape := RuntimeSafetyKernels.Shape.Spec.Shape

end RuntimeSafetyKernels.Contracts
