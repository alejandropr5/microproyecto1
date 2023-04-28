echo "---Downloading and importing HashiCorp GPG public key---"
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "---Adding the list of HashiCorp software sources to the apt source file on the system---"
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

echo "---Installing Consul---"
sudo apt update && sudo apt install consul -y

echo "---Installing nodejs---"
sudo apt install nodejs -y

echo "---Installing npm---"
sudo apt install npm -y

echo "---Installing git---"
sudo apt install git -y

echo "---Installing vim---"
sudo apt install vim -y

if [ "$(hostname)" == "node1" ]; then
  if [ ! -d "/node1ConsulService" ]; then
    echo "---Clonning repository in node1---"
    git clone https://github.com/alejandropr5/node1ConsulService.git
  fi  
  cd node1ConsulService/app
  echo "---Installing consul dependency in node1---"
  npm install consul -y
  echo "---Installing express dependency in node1---"
  npm install express -y
fi

if [ "$(hostname)" == "node2" ]; then
  if [ ! -d "/node2ConsulService" ]; then
    echo "---Clonning repository in node2---"
    git clone https://github.com/alejandropr5/node2ConsulService.git
  fi  
  cd node2ConsulService/app
  echo "---Installing consul dependency in node2---"
  npm install consul -y
  echo "---Installing express dependency in node2---"
  npm install express -y
fi

if [ "$(hostname)" == "haproxy" ]; then
  echo "---Installing haproxy in haproxy VM---"
  sudo apt install haproxy -y
  if [ ! -d "/haproxy_files" ]; then
    echo "---Clonning repository in node2---"
    git clone https://github.com/alejandropr5/haproxy_files.git
  fi  
  echo "---Changin config files content---"
  sudo cat ./haproxy_files/haproxy.cfg > /etc/haproxy/haproxy.cfg
  sudo cat ./haproxy_files/503.http > /etc/haproxy/errors/503.http
fi  

PROVISION_FLAG="true"
