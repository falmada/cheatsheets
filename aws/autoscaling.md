# AutoScaling Group

- When doing a detach on a node without replacing, the detached node just loses association with the autoscaling group, but does not get terminated
- When doing a detach with node replacement, it is still required to Terminate the dettached instance after the new node has been added.