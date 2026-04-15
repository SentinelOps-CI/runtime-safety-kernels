import RuntimeSafetyKernels.Shape.Spec

namespace RuntimeSafetyKernels.Shape

open RuntimeSafetyKernels.Shape.Spec

abbrev Shape := RuntimeSafetyKernels.Shape.Spec.Shape
abbrev Tensor := RuntimeSafetyKernels.Shape.Spec.Tensor

def validateShapeAtCompileTime (shape : Shape) : Bool :=
  RuntimeSafetyKernels.Shape.Spec.validateShapeAtCompileTime shape

def validateTensor (tensor : Tensor) : Bool :=
  tensor.data.length = tensorSize tensor.shape

end RuntimeSafetyKernels.Shape
