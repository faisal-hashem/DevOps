locals {
  default_routetable =  [
    {
    name = "default-0.0.0.0-0",
    address_prefix = "0.0.0.0/0",
    next_hop_type = "VirtualAppliance",
    next_hop_ip = "${var.nexthop_ip}",
    },
    {
    name = "MYCOMP10.0.0.0-8",
    address_prefix = "10.0.0.0/8",
    next_hop_type = "VirtualAppliance",
    next_hop_ip = "${var.nexthop_ip}",
    },
    {
    name = "MYCOMP172.16.0.0-12",
    address_prefix = "172.16.0.0/12",
    next_hop_type = "VirtualAppliance",
    next_hop_ip = "${var.nexthop_ip}",
    },
    {
    name = "MYCOMP192.168.0.0-16",
    address_prefix = "192.168.0.0/16",
    next_hop_type = "VirtualAppliance",
    next_hop_ip = "${var.nexthop_ip}",
    },
    {
    name = "Blackhole-Public",
    address_prefix = "10.${var.octet2}.14.0/24",
    next_hop_type = "none",
    next_hop_ip = null
    },
    {
    name = "hub${var.region}-10.${var.octet2}.0.0-20",
    address_prefix = "10.${var.octet2}.0.0/20",
    next_hop_type = "VirtualAppliance",
    next_hop_ip = "${var.nexthop_ip}"
    },
  ]
ase_routetable =  [
    {
    name = "default-0.0.0.0-0",
    address_prefix = "0.0.0.0/0",
    next_hop_type = "VirtualAppliance",
    next_hop_ip = "${var.nexthop_ip}",
    },
    {
    name = "MYCOMP10.0.0.0-8",
    address_prefix = "10.0.0.0/8",
    next_hop_type = "VirtualAppliance",
    next_hop_ip = "${var.nexthop_ip}",
    },
    {
    name = "MYCOMP172.16.0.0-12",
    address_prefix = "172.16.0.0/12",
    next_hop_type = "VirtualAppliance",
    next_hop_ip = "${var.nexthop_ip}",
    },
    {
    name = "MYCOMP192.168.0.0-16",
    address_prefix = "192.168.0.0/16",
    next_hop_type = "VirtualAppliance",
    next_hop_ip = "${var.nexthop_ip}",
    },
    {
    name = "Blackhole-Public",
    address_prefix = "10.${var.octet2}.14.0/24",
    next_hop_type = "none",
    next_hop_ip = null
    },
    {
    name = "hub${var.region}-10.${var.octet2}.0.0-20",
    address_prefix = "10.${var.octet2}.0.0/20",
    next_hop_type = "VirtualAppliance",
    next_hop_ip = "${var.nexthop_ip}"
    },
    {
    name = "13.66.140.0-32",
    address_prefix = "13.66.140.0/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "13.67.8.128-32",
    address_prefix = "13.67.8.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "13.69.64.128-32",
    address_prefix = "13.69.64.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "13.69.227.128-32",
    address_prefix = "13.69.227.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "13.70.73.128-32",
    address_prefix = "13.70.73.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "13.71.170.64-32",
    address_prefix = "13.71.170.64/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "13.71.194.129-32",
    address_prefix = "13.71.194.129/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "13.75.34.192-32",
    address_prefix = "13.75.34.192/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "13.75.127.117-32",
    address_prefix = "13.75.127.117/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "13.77.50.128-32",
    address_prefix = "13.77.50.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "13.78.109.0-32",
    address_prefix = "13.78.109.0/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "13.89.171.0-32",
    address_prefix = "13.89.171.0/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "13.94.141.115-32",
    address_prefix = "13.94.141.115/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "13.94.143.126-32",
    address_prefix = "13.94.143.126/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "13.94.149.179-32",
    address_prefix = "13.94.149.179/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "20.36.106.128-32",
    address_prefix = "20.36.106.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "20.36.114.64-32",
    address_prefix = "20.36.114.64/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "20.37.74.128-32",
    address_prefix = "20.37.74.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "23.96.195.3-32",
    address_prefix = "23.96.195.3/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "23.102.135.246-32",
    address_prefix = "23.102.135.246/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "23.102.188.65-32",
    address_prefix = "23.102.188.65/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "40.69.106.128-32",
    address_prefix = "40.69.106.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "40.70.146.128-32",
    address_prefix = "40.70.146.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "40.71.13.64-32",
    address_prefix = "40.71.13.64/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "40.74.100.64-32",
    address_prefix = "40.74.100.64/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "40.78.194.128-32",
    address_prefix = "40.78.194.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "40.79.130.64-32",
    address_prefix = "40.79.130.64/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "40.79.178.128-32",
    address_prefix = "40.79.178.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "40.83.120.64-32",
    address_prefix = "40.83.120.64/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "40.83.121.56-32",
    address_prefix = "40.83.121.56/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "40.83.125.161-32",
    address_prefix = "40.83.125.161/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "40.112.242.192-32",
    address_prefix = "40.112.242.192/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "51.107.58.192-32",
    address_prefix = "51.107.58.192/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "51.107.154.192-32",
    address_prefix = "51.107.154.192/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "51.116.58.192-32",
    address_prefix = "51.116.58.192/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "51.116.155.0-32",
    address_prefix = "51.116.155.0/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "51.120.99.0-32",
    address_prefix = "51.120.99.0/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "51.120.219.0-32",
    address_prefix = "51.120.219.0/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "51.140.146.64-32",
    address_prefix = "51.140.146.64/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "51.140.210.128-32",
    address_prefix = "51.140.210.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.151.25.45-32",
    address_prefix = "52.151.25.45/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.162.106.192-32",
    address_prefix = "52.162.106.192/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.165.152.214-32",
    address_prefix = "52.165.152.214/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.165.153.122-32",
    address_prefix = "52.165.153.122/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.165.154.193-32",
    address_prefix = "52.165.154.193/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.165.158.140-32",
    address_prefix = "52.165.158.140/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.174.22.21-32",
    address_prefix = "52.174.22.21/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.178.177.147-32",
    address_prefix = "52.178.177.147/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.178.184.149-32",
    address_prefix = "52.178.184.149/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.178.190.65-32",
    address_prefix = "52.178.190.65/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.178.195.197-32",
    address_prefix = "52.178.195.197/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.187.56.50-32",
    address_prefix = "52.187.56.50/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.187.59.251-32",
    address_prefix = "52.187.59.251/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.187.63.19-32",
    address_prefix = "52.187.63.19/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.187.63.37-32",
    address_prefix = "52.187.63.37/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.224.105.172-32",
    address_prefix = "52.224.105.172/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.225.177.153-32",
    address_prefix = "52.225.177.153/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.231.18.64-32",
    address_prefix = "52.231.18.64/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "52.231.146.128-32",
    address_prefix = "52.231.146.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "65.52.172.237-32",
    address_prefix = "65.52.172.237/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "65.52.250.128-32",
    address_prefix = "65.52.250.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "70.37.57.58-32",
    address_prefix = "70.37.57.58/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "104.44.129.141-32",
    address_prefix = "104.44.129.141/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "104.44.129.243-32",
    address_prefix = "104.44.129.243/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "104.44.129.255-32",
    address_prefix = "104.44.129.255/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "104.44.134.255-32",
    address_prefix = "104.44.134.255/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "104.208.54.11-32",
    address_prefix = "104.208.54.11/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "104.211.81.64-32",
    address_prefix = "104.211.81.64/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "104.211.146.128-32",
    address_prefix = "104.211.146.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "157.55.208.185-32",
    address_prefix = "157.55.208.185/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "191.233.50.128-32",
    address_prefix = "191.233.50.128/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "191.233.203.64-32",
    address_prefix = "191.233.203.64/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    },
    {
    name = "191.236.154.88-32",
    address_prefix = "191.236.154.88/32",
    next_hop_type = "Internet",
    next_hop_ip = null
    } 
  ]
}
