namespace RuntimeSafetyKernels.Shape.Spec

abbrev Shape := List Nat

structure Tensor where
  shape : Shape
  data : List Float
  deriving Repr

def isValidShape (shape : Shape) : Bool :=
  !shape.isEmpty && shape.all (fun d => d > 0)

def tensorSize (shape : Shape) : Nat :=
  shape.foldl (· * ·) 1

def mkTensor (shape : Shape) (values : List Float) : Option Tensor :=
  if isValidShape shape && values.length = tensorSize shape then
    some ⟨shape, values⟩
  else
    none

def zeroTensor (shape : Shape) : Option Tensor :=
  if isValidShape shape then
    some ⟨shape, List.replicate (tensorSize shape) 0.0⟩
  else
    none

def validateShapeAtCompileTime (shape : Shape) : Bool :=
  isValidShape shape && shape.length ≤ 8 && tensorSize shape ≤ 1000000

def tensorInvariant (t : Tensor) : Prop :=
  t.data.length = tensorSize t.shape

theorem zero_tensor_invariant (shape : Shape) :
  isValidShape shape →
  match zeroTensor shape with
  | some t => tensorInvariant t
  | none => True := by
  intro h
  simp [zeroTensor, tensorInvariant, tensorSize, h]

end RuntimeSafetyKernels.Shape.Spec
