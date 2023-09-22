# Selecting the right instance

1. Gather requirements on how much CPU, Memory you need to support
2. Check for other specific requirements such as:
	- Region
	- Required network performance
	- Amount of ENIs
	- Type of workload (does it make sense for burstable?)
3. Search for instances on the specific region within [instances.vantage.sh](https://instances.vantage.sh/?min_memory=10&min_vcpus=12&cost_duration=monthly)
4. If there is a budget limit, get some numbers as to what is the monthly and yearly budget that is fair to be used
	- Budget may be a total for your account, so be careful not to allocate 100% of it to just the VMs as you might need extra $ for storage, ELB, Elastic IPs and such
5. Check that the instance family you are selecting is proper for the workload to be hosted
	- <https://aws.amazon.com/ec2/instance-types/> is a good starting point
6. Always try to fetch newer generations
	- Old generations may eventually get deprecated
	- Newer generations usually run with some discounts and have better overall performance 
7. Now check prices