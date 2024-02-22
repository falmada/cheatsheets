# AWS - Networking

## Fetch subnet ids from a VPC

```bash
vpc_id="vpc-abc123"
aws ec2 describe-subnets --region eu-west-1 --filter Name=vpc-id,Values=${vpc_id} --query 'Subnets[?MapPublicIpOnLaunch==`false`].SubnetId'
```
