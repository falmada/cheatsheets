# Troubleshooting services

First, find out the LABEL for the iptables routes related to a well known service, for example `kube-dns`, or the affected service that is not working.

```bash
$ sudo iptables -t nat -L KUBE-SERVICES -n  | column -t | grep kube-dns
KUBE-SVC-JD5MR3NA4I4DYABC  tcp            --   0.0.0.0/0    192.168.16.10   /*  kube-system/kube-dns:metrics                                                             cluster  IP          */     tcp   dpt:9153
KUBE-SVC-ERIFXISQEP7F7DEF  tcp            --   0.0.0.0/0    192.168.16.10   /*  kube-system/kube-dns:dns-tcp                                                             cluster  IP          */     tcp   dpt:53
KUBE-SVC-TCOU7JCQXEZGVUGH  udp            --   0.0.0.0/0    192.168.16.10   /*  kube-system/kube-dns:dns                                                                 cluster  IP          */     udp   dpt:53
```

With the label (on the left side, first column), use that to find the pod IPs associated to that iptable chaing

```bash
$ sudo iptables -t nat -L KUBE-SVC-ERIFXISQEP7F7DEF -n | column -t
Chain                      KUBE-SVC-ERIFXISQEP7F7DEF  (1   references)
target                     prot                       opt  source            destination
KUBE-MARK-MASQ             tcp                        --   !192.168.32.0/20  192.168.16.10  /*  kube-system/kube-dns:dns-tcp  cluster  IP                 */  tcp        dpt:53
KUBE-SEP-45MJBCKMKB2BHIFV  all                        --   0.0.0.0/0         0.0.0.0/0      /*  kube-system/kube-dns:dns-tcp  ->       192.168.45.244:53  */  statistic  mode    random  probability  0.50000000000
KUBE-SEP-JO572XCYKEK27AV2  all                        --   0.0.0.0/0         0.0.0.0/0      /*  kube-system/kube-dns:dns-tcp  ->       192.168.47.55:53   */
```

Then within Kubernetes, compare those pod IPs to the endpoints associated to the service that is having issues.

```
╰─ kubectl get ep -n kube-system kube-dns
NAME       ENDPOINTS                                                          AGE
kube-dns   192.168.45.244:53,192.168.47.55:53,192.168.45.244:53 + 3 more...   30d
```