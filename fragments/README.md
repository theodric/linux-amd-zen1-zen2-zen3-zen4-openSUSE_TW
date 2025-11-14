To apply to existing .config and enable all the netfilter shit needed for Docker:

```
scripts/kconfig/merge_config.sh -m .config ./fragment_netfilter.sh
```

Fragment was extracted from a known-good config thusly:

```
grep -E '^(CONFIG_(IP|IP6|NF|NETFILTER|XT|BRIDGE|EBT|VETH|NAMESPACES|CGROUP).*?)=' .config-6.14.11 > nf-good.cfg
grep -E '^(CONFIG_(IP|IP6|NF|NETFILTER|XT|BRIDGE|EBT|VETH|NAMESPACES|CGROUP).*?)=' .config-6.17.7 > nf-new.cfg
cut -d= -f1 nf-new.cfg | sort > nf-new-keys
grep -F -f nf-new-keys nf-good.cfg > nf-good-pruned.cfg
mv nf-good-pruned.cfg fragment-netfilter.cfg
```
