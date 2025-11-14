To apply to existing .config and enable all the netfilter shit needed for Docker:

scripts/kconfig/merge_config.sh -m .config ./fragment_netfilter.sh
