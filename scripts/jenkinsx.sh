#!/usr/bin/env bash

sudo apt update
sudo apt install snapd -y

###############################################################
# Install Git, gcloud and kubectl
###############################################################
# kubectl
# brew install kubernetes-cli
sudo snap install kubectl --classic
#sudo snap remove kubectl
export PATH=$PATH:/usr/bin
echo 'export PATH=$PATH:/usr/bin' >> ~/.bashrc

# helm
# brew install kubernetes-helm
sudo snap install helm --classic
sudo snap install kops

# google-cloud-sdk
sudo snap install google-cloud-sdk --classic
export PATH=$PATH:/snap/bin
echo 'export PATH=$PATH:/snap/bin' >> ~/.bashrc
# gcloud auth login
# gcloud config set project sodadevops
# gcloud init
# gcloud components update

###############################################################
# install java and maven
###############################################################
sudo apt install default-jdk -y
sudo apt install maven -y

###############################################################
# install jenkinsx
###############################################################
sudo mkdir -p ~/.jx/bin
curl -L https://github.com/jenkins-x/jx/releases/download/v1.3.688/jx-linux-amd64.tar.gz | tar xzv -C ~/.jx/bin

export PATH=$PATH:~/.jx/bin
echo 'export PATH=$PATH:~/.jx/bin' >> ~/.bashrc

# jx install --username doohee323

###############################################################
# make a jenkinsx in gcp
###############################################################
#jx create cluster gke --skip-login=true -n jxapp --username admin --default-admin-password admin123! --verbose=true --log-level debug

#jx create cluster gke --skip-login=true -n jxapp --username admin --default-admin-password admin123! --verbose=true --log-level debug \
# -p sodadevops -z northamerica-northeast1-a --machine-type n1-standard-2 --max-num-nodes 2 --min-num-nodes 2

cat > /vagrant/cluster.txt <<- "EOF"
	? Domain 35.203.71.249.nip.io
	? GitHub user name: doohee323@gmail.com
	To be able to create a repository on GitHub we need an API Token
	Please click this URL https://github.com/settings/tokens/new?scopes=repo,read:user,read:org,user:email,write:repo_hook,delete_repo
	Then COPY the token and enter in into the form below:
	? API Token: ****************************************
	? Do you wish to use GitHub as the pipelines Git server: Yes
	? Do you wish to use doohee323@gmail.com as the pipelines Git user for GitHub server: Yes
EOF
cat /vagrant/cluster.txt

echo "###[ Take over 5 minutes to be ready for build env.]############################################################"

cat > /vagrant/check_env.txt <<- "EOF"
    Check jenkinsX environments
    $ jx open
    Name                      URL
    jenkins                   http://jenkins.jx.35.247.21.77.nip.io
    jenkins-x-chartmuseum     http://chartmuseum.jx.35.247.21.77.nip.io
    jenkins-x-docker-registry http://docker-registry.jx.35.247.21.77.nip.io
    jenkins-x-monocular-api   http://monocular.jx.35.247.21.77.nip.io
    jenkins-x-monocular-ui    http://monocular.jx.35.247.21.77.nip.io
    nexus                     http://nexus.jx.35.247.21.77.nip.io

	$ jx init
	$ jx install --username doohee323
	? Do you wish to use doohee323@gmail.com as the local Git user for GitHub server: Yes
	? Do you wish to use GitHub as the pipelines Git server: Yes
	? Do you wish to use doohee323@gmail.com as the pipelines Git user for GitHub server: Yes
	? A local Jenkins X cloud environments repository already exists, recreate with latest? Yes
	? Select Jenkins installation type: Static Master Jenkins
	? Pick workload build pack:  Kubernetes Workloads: Automated CI+CD with GitOps Promotion
	? Select the organization where you want to create the environment repository: Sodacrew	

    $ jx env
    ? Pick environment:  [Use arrows to move, type to filter]
    dev
    production
    staging
    
	$ jx get env
	NAME       LABEL       KIND        PROMOTE NAMESPACE     ORDER CLUSTER SOURCE                                                                REF PR
	dev        Development Development Never   jx            0
	staging    Staging     Permanent   Auto    jx-staging    100           https://github.com/doohee323/environment-jxapp-staging.git
	production Production  Permanent   Manual  jx-production 200           https://github.com/doohee323/environment-jxapp-production.git
	
	$ jx get apps
	APPLICATION  STAGING PODS URL                                                PRODUCTION PODS URL
	demo1001     0.0.3   1/1  http://demo1001.jx-staging.35.247.21.77.nip.io
	jhapp        0.0.11       http://jhapp.jx-staging.35.247.21.77.nip.io
	soda-gift    0.0.2   1/1  http://soda-gift.jx-staging.35.247.21.77.nip.io
	jxapp 0.0.3        http://jxapp.jx-staging.35.247.21.77.nip.io
EOF
cat /vagrant/check_env.txt


cat > /vagrant/check_env.txt <<- "EOF"
    Check jenkinsX environments
    $ jx open
    Name                      URL
    jenkins                   http://jenkins.jx.35.247.21.77.nip.io
    jenkins-x-chartmuseum     http://chartmuseum.jx.35.247.21.77.nip.io
    jenkins-x-docker-registry http://docker-registry.jx.35.247.21.77.nip.io
    jenkins-x-monocular-api   http://monocular.jx.35.247.21.77.nip.io
    jenkins-x-monocular-ui    http://monocular.jx.35.247.21.77.nip.io
    nexus                     http://nexus.jx.35.247.21.77.nip.io

    $ jx env
    ? Pick environment:  [Use arrows to move, type to filter]
    
    $ dev
    production
    staging
    
	$ jx get env
	NAME       LABEL       KIND        PROMOTE NAMESPACE     ORDER CLUSTER SOURCE                                                                REF PR
	dev        Development Development Never   jx            0
	staging    Staging     Permanent   Auto    jx-staging    100           https://github.com/doohee323/environment-jxapp-staging.git
	production Production  Permanent   Manual  jx-production 200           https://github.com/doohee323/environment-jxapp-production.git
	
	$ jx get apps
	APPLICATION  STAGING PODS URL                                                PRODUCTION PODS URL
	demo1001     0.0.3   1/1  http://demo1001.jx-staging.35.247.21.77.nip.io
	jhapp        0.0.11       http://jhapp.jx-staging.35.247.21.77.nip.io
	soda-gift    0.0.2   1/1  http://soda-gift.jx-staging.35.247.21.77.nip.io
	jxapp 0.0.3        http://jxapp.jx-staging.35.247.21.77.nip.io
EOF
cat /vagrant/check_env.txt

cat > /vagrant/make_app.txt <<- "EOF"
	cd /vagrant
	#jx create spring -d web -d actuator
	jx create spring -d web -d actuator -l java -g com.example -a Demo
	? Do you wish to use doohee323@gmail.com as the Git user name: Yes
	? Would you like to initialise git now? Yes
	? Commit message:  .
	? Which organisation do you want to use? Sodacrew
	? Enter the new repository name:  Demo
	? Do you wish to use doohee323@gmail.com as the user name for the Jenkins Pipeline Yes
	
	$ jx get build log
	
	jx env
	jx get apps
	
	## Deploy default index.html
	jx create issue -t 'add a homepage'
	git checkout -b wip
	mkdir -p src/main/resources/static
	echo "aaaa1" > src/main/resources/static/index.html
	git add src
	git commit -a -m 'add a homepage fixes #1'
	git push origin wip
	jx create pullrequest -t "add a homepage fixes #1"
	jx get preview

EOF
cat /vagrant/make_app.txt

exit 0
