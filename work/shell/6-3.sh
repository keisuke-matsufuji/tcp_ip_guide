# DHCPサーバとDHCPクライアントを動かすため、2つ用意
ip netns add server
ip netns add client

# vethインターフェース
ip link add s-veth0 type veth peer name c-veth0

# vethインターフェースをNetwork Namespaceに所属させる
ip link set s-veth0 netns server
ip link set c-veth0 netns client

# vethインターフェースをupに設定
ip netns exec server ip link set s-veth0 up
ip netns exec client ip link set c-veth0 up

# serverのインターフェースのIPアドレスを設定
ip netns exec server ip address add 192.0.2.254/24 dev s-veth0

# serverでdnsmasqコマンドを実行
ip netns exec server dnsmasq \
--dhcp-range=192.0.2.100,192.0.2.200,255.255.255.0 \
--interface=s-veth0 \
--port 0 \
--no-resolv \
--no-daemon