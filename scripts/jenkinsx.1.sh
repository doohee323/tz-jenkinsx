#!/usr/bin/env bash

sudo apt update
###############################################################
# install snap, java and maven
###############################################################
sudo apt install snapd -y
sudo apt install default-jdk -y
sudo apt install maven -y

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

###############################################################
# install jenkinsx
###############################################################
sudo mkdir -p ~/.jx/bin
curl -L https://github.com/jenkins-x/jx/releases/download/v1.3.688/jx-linux-amd64.tar.gz | tar xzv -C ~/.jx/bin

export PATH=$PATH:~/.jx/bin
echo 'export PATH=$PATH:~/.jx/bin' >> ~/.bashrc

###############################################################
# login gcloud
###############################################################
cat > /tmp/login_gcloud.txt <<- "EOF"
	gcloud auth login
	gcloud config set project tz-devops
	#gcloud init
	#gcloud components update
EOF
cat /tmp/login_gcloud.txt

###############################################################
# make a jenkinsx in gcp
###############################################################
cat > /tmp/cluster.txt <<- "EOF"
	#jx create cluster gke -n tzops3 --username admin --default-admin-password admin123! --verbose=true --log-level debug
	jx create cluster gke -n tzops3 --username admin --default-admin-password admin123! --verbose=true --log-level debug \
	 -p tz-devops -z northamerica-northeast1-a --machine-type n1-standard-2 --max-num-nodes 3 --min-num-nodes 2

	? Domain 35.203.71.249.nip.io
	? GitHub user name: doohee323@gmail.com
	To be able to create a repository on GitHub we need an API Token
	Please click this URL https://github.com/settings/tokens/new?scopes=repo,read:user,read:org,user:email,write:repo_hook,delete_repo
	Then COPY the token and enter in into the form below:
	? API Token: ****************************************
	? Do you wish to use GitHub as the pipelines Git server: Yes
	? Do you wish to use doohee323@gmail.com as the pipelines Git user for GitHub server: Yes
EOF
cat /tmp/cluster.txt

echo "###[ Take over 5 minutes to be ready for build env.]############################################################"

###############################################################
# prepare jx
###############################################################
cat > /tmp/prepare_jx.txt <<- "EOF"
	$ jx init
	$ jx install --username doohee323
	? Do you wish to use doohee323@gmail.com as the local Git user for GitHub server: Yes
	? Do you wish to use GitHub as the pipelines Git server: Yes
	? Do you wish to use doohee323@gmail.com as the pipelines Git user for GitHub server: Yes
	? A local Jenkins X cloud environments repository already exists, recreate with latest? Yes
	? Select Jenkins installation type: Static Master Jenkins
	? Pick workload build pack:  Kubernetes Workloads: Automated CI+CD with GitOps Promotion
	? Select the organization where you want to create the environment repository: Sodacrew	
EOF
cat /tmp/prepare_jx.txt

cat > /tmp/check_env.txt <<- "EOF"
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
    dev
    production
    staging
    
	$ jx get env
	NAME       LABEL       KIND        PROMOTE NAMESPACE     ORDER CLUSTER SOURCE                                                                REF PR
	dev        Development Development Never   jx            0
	staging    Staging     Permanent   Auto    jx-staging    100           https://github.com/doohee323/environment-tzops3-staging.git
	production Production  Permanent   Manual  jx-production 200           https://github.com/doohee323/environment-tzops3-production.git
	
	$ jx get apps
	APPLICATION  STAGING PODS URL                                                PRODUCTION PODS URL
	demo1001     0.0.3   1/1  http://demo1001.jx-staging.35.247.21.77.nip.io
	jhapp        0.0.11       http://jhapp.jx-staging.35.247.21.77.nip.io
	soda-gift    0.0.2   1/1  http://soda-gift.jx-staging.35.247.21.77.nip.io
	tzops3 0.0.3        http://tzops3.jx-staging.35.247.21.77.nip.io
EOF
cat /tmp/check_env.txt


cat > /tmp/check_env.txt <<- "EOF"
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
	staging    Staging     Permanent   Auto    jx-staging    100           https://github.com/doohee323/environment-tzops3-staging.git
	production Production  Permanent   Manual  jx-production 200           https://github.com/doohee323/environment-tzops3-production.git
	
	$ jx get apps
	APPLICATION  STAGING PODS URL                                                PRODUCTION PODS URL
	demo1001     0.0.3   1/1  http://demo1001.jx-staging.35.247.21.77.nip.io
	jhapp        0.0.11       http://jhapp.jx-staging.35.247.21.77.nip.io
	soda-gift    0.0.2   1/1  http://soda-gift.jx-staging.35.247.21.77.nip.io
	tzops3 0.0.3        http://tzops3.jx-staging.35.247.21.77.nip.io
EOF
cat /tmp/check_env.txt

cat > /tmp/make_app.txt <<- "EOF"
	cd /tmp
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
	
	## Promote apps
	jx promote --version 0.0.2 --env production
	jx promote --version 0.0.66 --env staging
	
EOF
cat /tmp/make_app.txt

cat > /tmp/delete_app.txt <<- "EOF"
	jx get apps
	jx delete application

EOF
cat /tmp/delete_app.txt



exit 0

