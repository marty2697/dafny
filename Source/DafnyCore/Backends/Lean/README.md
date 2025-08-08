## How does the type translation from Dafny to Lean work?
Only the most commonly used types are listed: the type on the left side of the arrow is the Dafny type, and the one on the right is the corresponding Lean type

- datatype single constructor -> structure
- datatype multiple constructors -> inductive
- Map -> PFun
- Seq -> List
- Set -> Set

## How does the function translation from Dafny to Lean work?

In the translation of a function, the function signature doesn't change, but the translation of the requires clause is as follows

- requires -> if ... then ... else