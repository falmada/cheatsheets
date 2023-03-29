# EC2 instance types reference

## Which ones to look for?

- [I]ntel ones, which either have a I or nothing on their name
- [A]MD ones

## Which ones to skip (unless conditions are met)?

- [G]raviton ones should be skipped, unless you have code that can be executed on those ones.
- [A]RM based ones

## Other considerations

- T is for **Burstable** VMs
  - Cheaper, allow to burst CPU usage for a short period of time till new credits are provided
- C is for **Compute Optimized**
  - Example: C5
  - Priority is raw compute, not memory
  - Ideal for high-performance tasks
- R is for **Regular Memory Optimized**
  - Example: R5
  - Ideal for real-time big data analytics, large in memory cache, high performance DBs
  - Benefit from AWS Nitro System, which gives access to almost all compute and memory (OS footprint is reduced)
- X is for **High ratio of memory** to compute
  - Example: X1, X1e
  - Ideal for memory intensive and real-time applications
