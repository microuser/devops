#!/bin/bash
#Author Microuser
#Created 2016-05-27
#ChangeLog

#Version    2016-06-04     0.9.2 Added apt-get upgrade
#Version    2016-06-04     0.9.2 Added openssh-server
#Version    2016-06-04     0.9.1 Added x20go
#Version    2016-06-04     0.9.0 Changed to Ubuntu Mate
#Version    2016-06-01     0.8.0 Added Vagrant Plugins
#Version 0.7.0 Added laravel and composer
#Version 0.6.0 Added Dialog
#Version 0.5.0 Initial



vagrantUrl="https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb"
vagrantFile="vagrant_1.8.1_x86_64.deb"
netBeansUrl="http://download.netbeans.org/netbeans/8.1/final/bundles/netbeans-8.1-php-linux-x64.sh"
netBeansFile="netbeans-8.1-php-linux-x64.sh"
netBeansInstallDir="/usr/local/netbeans-8.1/bin/netbeans"



function noOpMode(){
  false
  return $!
}
#noOpMode || echo no op mode off
#noOpMode &&  echo no op mode on


function isInstalled(){
  unlessAptGetStatus=0
  for canidate in "$@" 
  do
    sudo apt-cache policy $canidate | grep 'Installed: ' | grep -v ': (none)' >/dev/null
    unlessAptGetLastStatus=$?
    #echo "To Install: $unlessAptGetLastStatus	$canidate"
    unlessAptGetStatus="$(($unlessAptGetStatus || $unlessAptGetLastStatus ))"
  done
  return $unlessAptGetStatus
  }

function aptInstall(){ 

    correctSeparator=""
    for i in "${@}"
    do
        correctSeparator="$correctSeparator\n   $i"
    done
    if ! isInstalled $@
    then
        dialog --title "apt-get install" --infobox "apt-get install: $correctSeparator" 10 70
        noOpMode || sudo apt-get install -y $@
        return $?
    fi
    return 1
}

if ! which dialog >/dev/null; 
then
  aptInstall dialog
fi

#Change to double click on open
#kwriteconfig --file kdeglobals --group KDE --key SingleClick false

sudo apt-get update
sudo apt-get upgrade

aptInstall openssh-server


#Video
#detect if vm
#sudo lshw | grep nvidia

##if its not virtualbox and we don't have nvidia settings
if ! which nvidia-settings >/dev/null && ! [ "`sudo lshw | grep VirtualBox | wc -l`" -gt "0" ]
then
  #aptInstall nvidia-current
  aptInstall nvidia-361-updates
fi


#VMs
aptInstall virtualbox nfs-kernel-server p7zip-full git

#Vagrant
if ! which vagrant >/dev/null
then
  dialog --infobox "Installing Vagrant" 30 70
  
  noOpMode || cd /tmp && wget "$vagrantUrl"
  noOpMode || sudo dpkg -i "$vagrantFile"
fi

if ! vagrant plugin list | grep 'vagrant-bindfs' >/dev/null
then
    dialog --infobox "Enabling vagrant-bindfs for nfs shares" 30 70
    vagrant plugin install vagrant-bindfs
fi  

if ! vagrant plugin list | grep 'vagrant-hostsupdater' >/dev/null
then
    dialog --infobox "Enabling vagrant-hostsupdater"  30 70
    vagrant plugin install vagrant-hostsupdater
fi  

if ! vagrant plugin list | grep 'vagrant-triggers' >/dev/null
then
    dialog --infobox "Enabling vagrant-triggers"  30 70
    vagrant plugin install vagrant-triggers
fi  

#Oracle Java

if ! isInstalled oracle-java8-installer
then	
  dialog --infobox "installing oracle java 8" 20 70
  noOpMode || sudo add-apt-repository -y ppa:webupd8team/java
  noOpMode || sudo apt-get update
  noOpMode || sudo apt-get install -y oracle-java8-installer
fi

if isInstalled netbeans
then
  dialog --infobox "netbeans is already installed, removing" 30 70
  sudo apt-get remove netbeans >/dev/null
  sudo apt-get autoremove
  sudo apt-get purge netbeans >/dev/null
fi

if ! which netbeans >/dev/null
then
  if [ ! -f /"tmp/$netBeansFile" ]
  then
    dialog --infobox "downloading netbeans" 20 70
    noOpMode || cd /tmp && wget "$netBeansUrl"
  fi
  #make exe
  noOpMode || sudo chmod 755 "/tmp/$netBeansFile"
  
  #run installer
  dialog --infobox "running netbeans installer" 20 70
  noOpMode || sudo "/tmp/$netBeansFile"
  
  #make your own installer wrapper
  dialog --infobox "making exe in /usr/local/bin" 20 70
  noOpMode || sudo bash -c "echo \#\!/bin/sh > /usr/local/bin/netbeans "
  noOpMode || sudo bash -c "echo /bin/sh '$netBeansInstallDir' >> /usr/local/bin/netbeans "
  noOpMode || sudo chmod +x /usr/local/bin/netbeans
fi


aptInstall chromium-browser
aptInstall yakuake
aptInstall htop iftop

aptInstall php php-cli php-curl php-gd php-json php-mbstring php-mcrypt php-mysql php-pgsql php-pspell php-readline php-soap php-tidy php-xml php-zip
aptInstall composer


if ! [ -f ~/.config/composer/vendor/bin/laravel ]
  then
  dialog --infobox "installing laravel" 20 70
  composer global require "laravel/installer"
fi

if ! [ -f ~/.config/composer/vendor/bin/codecept ]
  then
  dialog --infobox "installing codeception" 20 70
  composer --dev global require "codeception/codeception"
fi


##Add to system path
if ! grep '~/.config/composer/vendor/bin' ~/.bashrc >/dev/null
then
  echo 'export PATH="$PATH:~/.config/composer/vendor/bin"' >> ~/.bashrc
  source ~/.bashrc
fi



if ! isInstalled x2goserver
then
    sudo add-apt-repository -y ppa:x2go/stable
    sudo apt-get update
    aptInstall x2goserver x2goserver-xsession
    #sudo apt-add-repository -y ppa:ubuntu-mate-dev/ppa
    #sudo apt-add-repository -y ppa:ubuntu-mate-dev/trusty-mate
    #sudo apt-get install --no-install-recommends ubuntu-mate-core ubuntu-mate-desktop
    #sudo apt-get update
fi

aptInstall x2goclient




