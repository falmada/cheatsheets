# Ceph controller
A Kubernetes controller that obtains the parameters from Container Cloud through a custom resource (CR), creates CRs for Rook, and updates its CR status based on the Ceph cluster deployment progress. It creates users, pools, and keys for OpenStack and Kubernetes and provides Ceph configurations and keys to access them. Also, Ceph controller eventually obtains the data from the OpenStack Controller for the Keystone integration and updates the RADOS Gateway services configurations to use Kubernetes for user authentication.

# Ceph operator
- Transforms user parameters from the Container Cloud web UI into Rook credentials and deploys a Ceph cluster using Rook.
- Provides integration of the Ceph cluster with Kubernetes

# Custom resource (CR)
Represents the customization of a Kubernetes installation and allows you to define the required Ceph configuration through the Container Cloud web UI before deployment. For example, you can define the failure domain, pools, Ceph node roles, number of Ceph components such as Ceph OSDs, and so on.

# Rook
A storage orchestrator that deploys Ceph on top of a Kubernetes cluster.

# Others

A typical Ceph cluster consists of the following components:

## Ceph Monitors
Three or, in rare cases, five Ceph Monitors.

## Ceph Managers
Mirantis recommends having three Ceph Managers in every cluster

## RADOS Gateway services
Mirantis recommends having three or more RADOS Gateway services for HA.

## Ceph OSDs
The number of Ceph OSDs may vary according to the deployment needs.