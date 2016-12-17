set -e

RUBY_VERSION="2.3.0"
PACKAGES="binutils make git scrot lsb-base emacs chromium-browser supercollider jackd supercollider-emacs postgresql libpq-dev gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav eclipse firefox linux-image-extra-$(uname -r) linux-image-extra-virtual phantomjs gimp mypaint ffmpeg openshot"

function red {
    echo -e "\e[31m$1\e[0m"
}

function green {
    echo -e "\e[32m$1\e[0m"
}

function yellow {
    echo -e "\e[33m$1\e[0m"
}

function blue {
    echo -e "\e[34m$1\e[0m"
}

function run {
    NAME=$1
    TEST=$2

    blue "# $NAME"
    
    $TEST || step_$NAME

    if $TEST; then
        green "$NAME [OK]"
    else
        red "$NAME [FAIL]"
        exit 1
    fi
}

function system_update {
    sudo apt-get update && sudo apt-get dist-upgrade
    sudo apt-get install -y $PACKAGES
}

function step_ruby_install {
    wget -O ruby-install-master.tar.gz https://github.com/postmodern/ruby-install/archive/master.tar.gz
    tar -xzvf ruby-install-master.tar.gz
    cd ruby-install-master/
    sudo make install
    cd
    rm ruby-install-master.tar.gz
    rm -rf src/ruby-install-master
}

function step_chruby {
  wget -O chruby-master.tar.gz https://github.com/postmodern/chruby/archive/master.tar.gz
  tar -xzvf chruby-master.tar.gz
  cd chruby-master/
  sudo make install
  cd
  rm chruby-master.tar.gz
  rm -rf src/chruby-master
}

function step_ruby {
   ruby-install ruby $RUBY_VERSION
}

function step_bundler {
    source /usr/local/share/chruby/chruby.sh
    source /usr/local/share/chruby/auto.sh
    chruby $RUBY_VERSION

    gem install bundler
}

function step_node {
    mkdir -p $HOME/apps
    cd $HOME/apps
    wget https://nodejs.org/dist/v6.6.0/node-v6.6.0-linux-x64.tar.xz
    tar -xvf node-v6.6.0-linux-x64.tar.xz
    mv node-v6.6.0-linux-x64 node
    rm node-v6.6.0-linux-x64.tar.xz
    cd
}

function step_docker {
    sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
    sudo apt-get update

    sudo apt-get install -y  docker-engine
    sudo service docker start
    sudo groupadd docker || echo ""
    sudo usermod -aG docker $USER || echo ""
}

system_update
run "ruby_install"  "test -x /usr/local/bin/ruby-install"
run       "chruby"  "test -f /usr/local/share/chruby/chruby.sh"
run         "ruby"  "test -f $HOME/.rubies/ruby-$RUBY_VERSION/bin/ruby"
run      "bundler"  "which bundle"
run         "node"  "test -f $HOME/apps/node/bin/node"
run       "docker"  "docker run hello-world"
blue "# Done!"
