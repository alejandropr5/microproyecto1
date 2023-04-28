if [ "$(hostname)" == "node1" ]; then
    echo "---Initializing consul agent in Node1---"
    consul agent -ui -server -bootstrap-expect=1 -bind=99.5.100.2 -client=0.0.0.0 -data-dir=/tmp/consul -node=agent-one -enable-script-checks=true -config-dir=/etc/consul.d &
    echo "---Initializing web service in Node1---"
    node /home/vagrant/node1ConsulService/app/index.js 3000 &
fi

if [ "$(hostname)" == "node2" ]; then
    echo "---Initializing consul agent in Node2---"
    consul agent -ui -bind=99.5.100.3 -client=0.0.0.0 -data-dir=/tmp/consul -node=agent-two -enable-script-checks=true -config-dir=/etc/consul.d -retry-join 99.5.100.2 &
    echo "---Initializing web service in Node2---"
    node /home/vagrant/node2ConsulService/app/index.js 3000 &
fi

if [ "$(hostname)" == "haproxy" ]; then
    echo "---Enabling haproxy---"
    sudo systemctl enable haproxy &
    echo "---Starting haproxy---"
    sudo systemctl start haproxy &
fi
