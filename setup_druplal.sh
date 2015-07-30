#!/bin/bash

function install_puppet_agent(){
puppet --version
if [ $? -eq 0 ]; then
    mkdir -p /etc/puppet/environments/redcrackle/modules;mkdir -p /etc/puppet/environments/redcrackle/manifest
    echo "puppet is already installed"
else
    wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb; dpkg -i puppetlabs-release-trusty.deb; sudo apt-get update;sudo apt-get -y install puppet; mkdir -p /etc/puppet/environments/redcrackle/modules;mkdir -p /etc/puppet/environments/redcrackle/manifest
fi
}


function download_module(){
  repository_url="https://github.com/nu113r/alok.git"
  git clone $repository_url
  url=$repository_url
  basename=$(basename $url)
  name=${basename%.*}
  echo "copy all modules or manifest"
  cd ${name}/modules/ ; cp -a * /etc/puppet/environments/redcrackle/modules/. ; cd ../manifest/;  cp -a * /etc/puppet/environments/redcrackle/manifest/.   
}

 
function apply_catalog(){
   puppet apply --modulepath=/etc/puppet/environments/redcrackle/modules /etc/puppet/environments/redcrackle/manifest/drupal_stack.pp --debug
   puppet apply --modulepath=/etc/puppet/environments/redcrackle/modules /etc/puppet/environments/redcrackle/manifest/deploy_drupal_app.pp --debug
}

apt-get update
apt-get install -y git wget
install_puppet_agent 
download_module 
apply_catalog 
