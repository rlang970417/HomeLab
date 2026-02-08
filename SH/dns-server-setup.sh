#!/bin/bash

echo "### Starting DNS Setup for Oracle Linux 9 ###"

# 1. Host Setup
sudo hostnamectl set-hostname ns1.homelab.tst
sudo dnf update -y
sudo dnf install -y bind bind-utils

# 2. Path Definitions
# OL9 uses /etc/named.conf and /var/named/ for zones
CONF_FILE="/etc/named.conf"
ZONE_DIR="/var/named"

# 3. Create Root Hints
sudo dig . NS @168.119.153.26 > ${ZONE_DIR}/named.ca

# 4. Configure named.conf
# Note: We configure it to listen on all interfaces and allow our ACL
cat <<EOF | sudo tee ${CONF_FILE}
acl "goodclients" {
    192.168.1.0/24;
    localhost;
};

options {
    listen-on port 53 { any; };
    directory   "/var/named";
    dump-file   "/var/named/data/cache_dump.db";
    statistics-file "/var/named/data/named_stats.txt";
    memstatistics-file "/var/named/data/named_mem_stats.txt";
    secroots-file   "/var/named/data/named.secroots";
    recursing-file  "/var/named/data/named.recursing";

    allow-query     { goodclients; };
    recursion yes;

    forwarders {
        77.88.8.8;
        77.88.8.1;
    };
    forward only;

    dnssec-validation auto;
    managed-keys-directory "/var/named/dynamic";
    pid-file "/run/named/named.pid";
    session-keyfile "/run/named/session.key";
};

logging {
    channel default_debug {
        file "data/named.run";
        severity dynamic;
    };
};

zone "homelab.tst" IN {
    type master;
    file "zone.tst.homelab";
};

zone "1.168.192.in-addr.arpa" {
    type master;
    file "revp.192.168.1";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
EOF

# 5. Create Forward Lookup Zone File
cat <<EOF | sudo tee ${ZONE_DIR}/zone.tst.homelab
\$ORIGIN homelab.tst.
\$TTL 1D
@     IN SOA   ns1 hostmaster (
                        202301122 ; serial
                        8H        ; refresh
                        4H        ; retry
                        4W        ; expire
                        1D )      ; minimum
@       IN      NS      ns1.homelab.tst.
@       IN      MX      10      lxhpe001.homelab.tst.

www             CNAME   lxhpe001
localhost       A       127.0.0.1
ns1             A       192.168.1.10
lxhpe001        A       192.168.1.97
lxlpd001        A       192.168.1.98
lxdev001        A       192.168.1.99
lxdb2           A       192.168.1.101
EOF

# 6. Create Reverse Lookup Zone File
cat <<EOF | sudo tee ${ZONE_DIR}/revp.192.168.1
\$ORIGIN 1.168.192.in-addr.arpa.
\$TTL 1D
@     IN SOA  ns1.homelab.tst. hostmaster.homelab.tst. (
              202301121  ; serial
              28800      ; refresh
              14400      ; retry
              2419200    ; expire
              86400      ; minimum
              )
              NS      ns1.homelab.tst.

10              PTR     ns1.homelab.tst.
97              PTR     lxhpe001.homelab.tst.
98              PTR     lxlpd001.homelab.tst.
99              PTR     lxdev001.homelab.tst.
101             PTR     lxdb2.homelab.tst.
EOF

# 7. Set Permissions and SELinux contexts
sudo chown root:named /etc/named.conf
sudo chown named:named ${ZONE_DIR}/zone.tst.homelab ${ZONE_DIR}/revp.192.168.1
sudo chmod 640 /etc/named.conf
sudo restorecon -Rv /etc/named.conf /var/named/

# 8. Firewall Configuration
sudo firewall-cmd --permanent --add-service=dns
sudo firewall-cmd --reload

# 9. Check Config and Start
sudo named-checkconf
sudo systemctl enable --now named

echo "### BIND Setup Complete on OL9 ###"

# 10. Networking (Using nmcli)
# Assuming 'eth1' is your interface name; update if necessary (e.g., ens160 or enp0s3)
INTERFACE="eth1"
sudo nmcli con mod "$INTERFACE" ipv4.addresses 192.168.1.10/24 ipv4.gateway 192.168.1.1 ipv4.dns "127.0.0.1" ipv4.method manual
sudo nmcli con up "$INTERFACE"
