How to do a Ceph cluster maintenance/shutdown
The following summarize the steps that are necessary to shutdown a Ceph cluster for maintenance.

Stop the clients from using your Cluster
(this step is only necessary if you want to shutdown your whole cluster)

Important – Make sure that your cluster is in a healthy state before proceeding

Now you have to set some OSD flags:
```
# ceph osd set noout
# ceph osd set nobackfill
# ceph osd set norecover
```

Those flags should be totally sufficient to safely powerdown your cluster but you
could also set the following flags on top if you would like to pause your cluster completely::

```
# ceph osd set norebalance
# ceph osd set nodown
# ceph osd set pause
```

 Pausing the cluster means that you can't see when OSDs come
back up again and no map update will happen

- Shutdown your service nodes one by one
- Shutdown your OSD nodes one by one
- Shutdown your monitor nodes one by one
- Shutdown your admin node

After maintenance just do everything mentioned above in reverse order.