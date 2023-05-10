**What is terraform state locking?**
If supported by your backend, Terraform will lock your state for all operations that could write state. This prevents others from acquiring the lock and potentially corrupting your state. State locking happens automatically on all operations that could write state.

The **-target** option can be used to focus Terraform's attention on only a subset of resources.

Terraform output:
- It is possible to prevent sensitive data on output from being displayed on CLI
- Output values may be used to expose data ourside of a terraform module

What is a state in terraform
A state is a JSON file which keeps track of metadata and mappings between resources and remote objects

What is the tain operation used for in Terraform?
It is used to mark resources to be destroyed and recreated on the next execution of apply

An import may also result in a "complex import" where multiple resources are imported.