# Known issues

## Removing an item from an index, creates a cascading set of deletes

https://github.com/hashicorp/terraform/issues/14275

Hi @rkul, as a workaround, you can use `terraform state mv <resource-name>.<resource-id>[<i>] <resource-name>.<resource-id>[<j>]` to move elements one by one in the list, upwards or downwards depending on the values you set for i & j.

First get which resources are expected to get eliminated/sacked, then list resources using `terraform state list` and finally move the position of each.
