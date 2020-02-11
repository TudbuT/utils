# How to install ubuntu as sub-system!

folder=ubuntu-fs
if [ -d "$folder" ]; then
    first=1
    echo "skipping downloading"
fi
tarball="ubuntu.tar.gz"
if [ "$first" != 1 ];then
    if [ ! -f $tarball ]; then
	echo "downloading ubuntu-image"
	case `dpkg --print-architecture` in
	aarch64)
	    archurl="arm64" ;;
	arm)
	    archurl="armhf" ;;
	armhf)
	    archurl="armhf" ;;
	amd64)
	    archurl="amd64" ;;
	i*86)
	    archurl="i386" ;;
	x86_64)
	    archurl="amd64" ;;
	*)
	    echo "unknown architecture"; exit 1 ;;
	esac
	wget "https://partner-images.canonical.com/core/disco/current/ubuntu-disco-core-cloudimg-${archurl}-root.tar.gz" -O $tarball
    fi
    cur=`pwd`
    mkdir -p "$folder"
    cd "$folder"
    echo "decompressing ubuntu image"
    tar -xf ${cur}/${tarball} --exclude='dev'||:
    echo "fixing nameserver, otherwise it can't connect to the internet"
    echo "nameserver 1.1.1.1" > etc/resolv.conf
    cd "$cur"
fi
mkdir -p binds
echo "setting up"
bin=start-ubuntu.sh
sudo chmod 777 ubuntu-fs
sudo chmod 777 ubuntu-fs/*
mkdir ./ubuntu-fs/firstrun
fl="HOME=/root"
fl+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
fl+=" TERM=\$TERM"
fl+=" LANG=C.UTF-8"
fl+=" /bin/bash /firstrun/firstrun2.sh>/firstrun/firstrun2log.txt.log"
echo "$fl" > ./ubuntu-fs/firstrun/firstrun1.sh
firstrun="
/bin/apt-get clean
echo \"Cleaned!\"
cd /var/lib/apt
/bin/apt-get clean
/bin/rm -rf lists
/bin/mkdir -p lists/partial
/bin/apt-get clean
echo \"Cleaned!\"
/bin/apt-get update
"
echo "$firstrun" > ./ubuntu-fs/firstrun/firstrun2.sh
sudo chroot ./ubuntu-fs /bin/bash /firstrun/firstrun1.sh

echo "writing launch script"
cat > $bin <<- EOM
#!/bin/bash
cd \$(dirname \$0)
command="sudo chroot ./ubuntu-fs /bin/bash /boot.sh"
fl="mount -t proc proc /proc\nHOME=/root"
fl+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games:/firstrun"
fl+=" TERM=\$TERM"
fl+=" LANG=C.UTF-8"
fl+=" /bin/bash --login" # change this to "login (username)" if you want to have to type a password (you need to create an user for that!)
echo "\$fl" > ubuntu-fs/boot.sh
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM

echo "making $bin executable"
chmod +x $bin
echo "You can now launch Ubuntu with the ./${bin} script"
