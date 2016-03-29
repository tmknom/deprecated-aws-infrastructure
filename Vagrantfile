VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "bento/centos-6.7"

  # sync time with local
  # http://polidog.jp/2014/01/08/vagrant/
  config.vm.provider :virtualbox do |v|
    v.customize ["setextradata", :id, "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled", 0]
  end

  # ssh key
  config.vm.provision :file, source: "~/.ssh/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"

  # aws access token
  config.vm.provision :file, source: "~/.aws/credentials", destination: "/home/vagrant/.aws/credentials"
  config.vm.provision :file, source: "~/.aws/config", destination: "/home/vagrant/.aws/config"

  config.vm.provision :shell, inline: <<-EOT
    # ssh key
    chmod 400 /home/vagrant/.ssh/id_rsa
    chown vagrant:vagrant /home/vagrant/.ssh/id_rsa

    # aws access token
    chmod 400 /home/vagrant/.aws/credentials
    chmod 400 /home/vagrant/.aws/config
    chown vagrant:vagrant /home/vagrant/.aws/credentials
    chown vagrant:vagrant /home/vagrant/.aws/config

    # yum
    yum -y install epel-release
    yum -y update --exclude=kernel*
    yum -y groupinstall 'Development tools'
    yum -y install jq tree
    echo 'export PATH="/usr/local/bin:$PATH"' >> /home/vagrant/.bash_profile

    # git
    yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker
    wget https://www.kernel.org/pub/software/scm/git/git-2.8.0.tar.gz
    tar -zxf git-2.8.0.tar.gz
    cd git-2.8.0
    make prefix=/usr/local all
    make prefix=/usr/local install

    # git-prompt
    chmod a+x /home/vagrant/git-2.8.0/contrib/completion/git-prompt.sh
    chmod a+x /home/vagrant/git-2.8.0/contrib/completion/git-completion.bash
    echo 'source /home/vagrant/git-2.8.0/contrib/completion/git-prompt.sh' >> /home/vagrant/.bash_profile
    echo 'source /home/vagrant/git-2.8.0/contrib/completion/git-completion.bash' >> /home/vagrant/.bash_profile
    echo 'GIT_PS1_SHOWDIRTYSTATE=true' >> /home/vagrant/.bash_profile
    echo "export PS1='\\[\\033[36m\\]\\w\\[\\033[35m\\]\\\$(__git_ps1)\\[\\033[00m\\]\\\$ '" >> /home/vagrant/.bash_profile

    # python
    yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel
    curl -O https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz
    tar zxf Python-2.7.11.tgz
    cd Python-2.7.11
    ./configure --prefix=/opt/local
    make && make altinstall
    echo 'export PATH="/opt/local/bin:$PATH"' >> /etc/profile.d/python.sh
    echo 'source /etc/profile.d/python.sh' >> /home/vagrant/.bash_profile

    # pip
    curl -kL https://bootstrap.pypa.io/get-pip.py | /opt/local/bin/python2.7
    /opt/local/bin/pip install awscli boto3 fabric
  EOT
end

