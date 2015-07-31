#!/bin/bash
set -e
install_puppet_agent() {
	puppet --version
	if [ $? -eq 0 ]; then
		echo "puppet is already installed"
	else
		wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
		dpkg -i puppetlabs-release-trusty.deb
		sudo apt-get update
		sudo apt-get -y install puppet
                sed -i 's/no/yes/g' /etc/default/puppet
                service puppet restart 
	fi

	mkdir -p /etc/puppet/environments/redcrackle
}


download_module(){
	repository_url="https://github.com/OpsTree/PuppetDrupalSetup.git"
	git clone $repository_url /etc/puppet/environments/redcrackle
}

 
apply_catalog(){
	puppet apply --modulepath=/etc/puppet/environments/redcrackle/modules /etc/puppet/environments/redcrackle/manifest/drupal_stack.pp --debug
	puppet apply --modulepath=/etc/puppet/environments/redcrackle/modules /etc/puppet/environments/redcrackle/manifest/deploy_drupal_app.pp --debug
}

notify_script_execution() {
	wget google.com
}

apt-get update
apt-get install -y git 
install_puppet_agent 
download_module 
apply_catalog 
