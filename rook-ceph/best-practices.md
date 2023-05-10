# Ceph - Best practices

- A Ceph cluster with 3 Ceph nodes does **not** provide hardware fault tolerance and is not eligible for recovery operations, such as a disk or an entire Ceph node replacement.
- A Ceph cluster uses the replication factor that equals 3. If the number of Ceph OSDs is less than 3, a Ceph cluster moves to the **degraded** state with the write operations restriction until the number of alive Ceph OSDs equals the replication factor again.
- RBD mirroring should be considered