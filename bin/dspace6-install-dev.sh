#!/bin/bash

print <<EOF;

************* SECTION 1: UofA Library Dspace Development ***************

Please select how you would like to develop with dspace. Note: all options integrate with docker at some point. The following options were derived from:

https://wiki.duraspace.org/display/DSDOC6x/Installing+DSpace

1. Host development - the developer is responsible for setting up their host machine with the development environment needed to build dspace as described in the link above. Docker will be used to run tomcat for runtime debugging. Docker image is 1.1GB.

2. Host editing - the developer will edit the dspace src code on the host machine. Within docker the code will be built through the command line and run within tomcat. Debugging can happen outside docker in an ide. Docker image is 1.1GB.

3. Docker cmdline development. All src code editing, building, and debugging is done through the cmdline within docker. Provided editors include emacs-nox, vim, nano. Building and debugging is also done within docker, it is assumed the developer knows how to runtime debug java code through the commandline. Docker image is 1.1GB.

4. Docker ide development. All src code editing, building, and debugging is done through an ide within docker, opened via ssh X11 forwarding. In addition to command line editors, included ide are Intellij, Netbeans, Eclipse, emacs (windowed), Atom, MS Code. The host machine must be running X11. Docker image is 4.8GB

EOF

my $DOCKER_IMAGE="dspace6-dev";
my $SRC_DIR="$HOME/dspace/src";
my $DEVSTYLE = undef;
my $HOST_TYPE = undef;
my $HOST_DIR = undef;

while (  ) {
  print "Which development style would you prefer ?\n";
  chomp( $DEVSTYLE = $_ );
  for ( $DEVSTYLE ) {
      /1/ && do { $HOST_TYPE="runtime"; $HOST_DIR="/opt/tomcat/dspace/run"; };
      /2/ && do { $HOST_TYPE="source"; $HOST_DIR="$SRC_DIR"; };
      /3/ && last;
      /4/ && do { DOCKER_IMAGE=dspace6-ide; };
      /*/ && do { $DEVSTYLE = undef; print "Please enter 1-4, or hold Ctrl-C to cancel\n"; };
    }
}

echo
echo "************* SECTION 2: Environment check ***************"
echo

echo "CHECK: Is docker installed ?"
CMD="docker -v"; OUT="`$CMD`"

if [ "$OUT" == "" ]; then
    echo >&2 "ERROR: '$CMD' failed"
    echo >&2
    echo >&2 "
    echo >&2
    exit 1;
else
    echo "CHECK: '$CMD' returned '$OUT'"
fi

echo
echo "CHECK: Does your system user belong to the 'docker' group ?"
CMD="id | grep docker"; OUT="`id | grep docker`"

if [ "$OUT" == "" ]; then
    echo >&2 "ERROR: '$CMD' failed"
    echo >&2
    echo >&2
    exit 1;
else
    echo "CHECK: '$CMD' returned '$OUT'"
fi

echo
echo "CHECK: Does the dspace group, id=800 exist ?"
CMD="perl -e '$gid = getgrnam(\"dspace\"); print $gid'"; OUT=`perl -e '$gid = getgrnam("dspace"); print $gid'`

if [ "$OUT" != "800" ]; then
    echo >&2 "ERROR: '$CMD' failed"
    echo >&2
    echo >&2 "Your system needs the group dspace to exist with id=800"
    echo >&2 "On linux try running the command:"
    echo >&2 "sudo groupadd dspace --gid 800"
    echo >&2
    exit 1;
else
    echo "CHECK: '$CMD' returned '$OUT'"
fi

echo
echo
echo "CHECK: Does the dspace user, id=800 exist ?"
CMD="perl -e '$uid = getpwnam(\"dspace\"); print $uid'"; OUT=`perl -e '$uid = getpwnam("dspace"); print $uid'`

if [ "$OUT" != "800" ]; then
    echo >&2 "ERROR: '$CMD' failed"
    echo >&2
    echo >&2 "Your system needs the user dspace to exist with id=800"
    echo >&2 "On linux try running the command:"
    echo >&2 "sudo useradd dspace --uid 800 --gid 800"
    echo >&2
    exit 1;
else
    echo "CHECK: '$CMD' returned '$OUT'"
fi

echo
echo "CHECK: Does your system user belong to the 'dspace' group ?"
CMD="id | grep dspace"; OUT="`id | grep dspace`"

if [ "$OUT" == "" ]; then
    echo >&2 "ERROR: '$CMD' failed"
    echo >&2
    echo >&2 "Your system user needs to belong to the 'dspace' group"
    echo >&2 "Try running the command:"
    echo >&2 "sudo usermod -a -G dspace <your_unix_userid>"
    echo >&2
    exit 1;
else
    echo "CHECK: '$CMD' returned '$OUT'"
fi

echo
echo "CHECK: Does the host dspace development directory exist ?"
CMD="test -f $SRC_DIR/dspace/config/local.cfg-dev && echo -n 'Good'"; OUT="`$CMD`"
CMD="id | grep dspace"; OUT="`id | grep dspace`"

if [ "$OUT" == "" ]; then
    echo >&2 "ERROR: '$CMD' failed"
    echo >&2
    echo >&2 "Your system user needs to belong to the 'dspace' group"
    echo >&2 "Try running the command:"
    echo >&2 "sudo usermod -a -G dspace <your_unix_userid>"
    echo >&2
    exit 1;
else
    echo "CHECK: '$CMD' returned '$OUT'"
fi

echo
echo "CHECK: Has the dspace src code been checked out on the host system ?"
CMD="test -f $SRC_DIR/dspace/config/local.cfg-dev && echo -n 'Good'"; OUT="`$CMD`"

if [ "$OUT" != "Good" ]; then

   while [ ! -d "$SRC_DIR" ]; do
    
      read -p "EXEC: Need to checkout the dspace src code locally. Please enter the directory to put the src if different from $SRC_DIR (otherwise just hit the [enter] key): " CUSTOM_DIR

      if [ "$CUSTOM_DIR" != ""; ] then
         SRC_DIR="$CUSTOM_DIR"
      fi
       
   mkdir -p "$SRC_DIR" 2>/dev/null;
   done

   CURRENT_DIR="`pwd`"
   cd "$SRC_DIR"
   echo "EXEC: Checking out the dspace src code repository"
   echo "EXEC: ssh vitae \"cat /data1/vitae/repos/$DSPACE_TAR\" | tar -xzv"
   ssh vitae "cat /data1/vitae/repos/$DSPACE_TAR.tar.gz" | tar -xzv
   mv $DSPACE_TAR/* .
   rmdir $DSPACE_TAR
   echo "EXEC: git clone ssh://vitae:/data1/vitae/repos/campusrepo.git"
   git clone ssh://vitae:/data1/vitae/repos/campusrepo.git
   cp -a campusrepo/* .
   mv campusrepo/.git .
   rmdir campusrepo
   

fi

#echo
#echo "CHECK: Have you mounted //dspace-nfsdev/dspace-assetstore-dev ?"
#CMD="mount | grep dspace-assetstore"; OUT="`mount | grep dspace-assetstore`"
#
#if [ "$OUT" == "" ]; then
#    echo >&2 "ERROR: '$CMD' failed"
#    echo >&2
#    echo >&2 "The nfs dspace assetstore needs to be mounted. Try running the commands (on linux):"
#    echo >&2 "sudo cp /etc/fstab /etc/fstab.bak"
#    echo >&2 "sudo mkdir -p /mnt/dspace-assetstore"
#    echo >&2 "sudo echo 'dspace-nfsdev:/dspace-assetstore-dev /mnt/dspace-assetstore nfs nfsvers=4,proto=tcp,hard 0 0' >> /etc/fstab"
#    echo >&2 "sudo mount /mnt/dspace-assetstore"
#    echo >&2
#    exit 1;
#else
#    echo "CHECK: '$CMD' returned '$OUT'"
#fi

echo
echo "CHECK: Is the pipe progress utility 'pv' installed ?"
CMD="pv --version | head -1"; OUT="`pv --version | head -1`"

if [ "$OUT" == "" ]; then
    echo >&2 "ERROR: '$CMD' failed"
    echo >&2
    echo >&2 "The pv command line utility needs to be installed"
    echo >&2
    exit 1;
else
    echo "CHECK: '$CMD' returned '$OUT'"
fi

echo
echo "CHECK: Is netstat installed ?"
CMD='netstat -i'; OUT="`netstat -i 2>/dev/null`"

if [ "$OUT" == "" ]; then
    echo >&2 "ERROR: '$CMD' failed"
    echo >&2
    echo >&2 "The netstat command line utility needs to be installed"
    echo >&2
    exit 1;
else
    echo "CHECK: '$CMD' returned '$OUT'"
fi

echo
echo "CHECK: Is a service listening at 8080 ?"
CMD='netstat -l --numeric | grep 8080'; OUT="`netstat -l --numeric | grep 8080`"
if [ "$OUT" != "" ]; then
    echo >&2 "ERROR: '$CMD' failed"
    echo >&2
    echo >&2 ""
    echo >&2
    exit 1;
else
    echo "CHECK: '$CMD' returned '$OUT'"
fi

if [ "$DEVSTYLE" == "4" ]; then
echo
echo "CHECK: Is X running ?"
CMD='$DISPLAY'; OUT="$DISPLAY"

if [ "$OUT" == "" ]; then
    echo >&2 "ERROR: '$CMD' env variable is not set, X is not present"
    echo >&2
    echo >&2 "The IDE docker requires X to be running"
    echo >&2 "debian/ubuntu: 'sudo apt-get install x-windows-system'"
    echo >&2 "redhat: yum groupinstall 'X Window System'"
    echo >&2 "macos: install XQuartz"
    echo >&2 "mswin: install Xming"
    echo >&2
    exit 1;
else
    echo "CHECK: '$CMD' returned '$OUT'"
fi
fi



    
    echo >&2 "ERROR: '$CMD' returned '$OUT'"
    echo >&2
    echo >&2 "Please create the directory $HOST_DIR with read/write permissions"
    echo >&2
    exit 1;
else
    echo "CHECK: '$CMD' returned '$OUT'"
fi
fi

if [ "$HOST_DIR" != "" ]; then
fi

echo
echo "************* SECTION 3: Create docker container ***************"
echo

YESNO=""
CMD="docker ps -a | grep $DOCKER_IMAGE | awk '{ printf $1 }'";
OUT="`docker ps -a | grep $DOCKER_IMAGE | awk '{ printf $1 }'`"

if [ "$OUT" != "" ]; then
while [ "$YESNO" == "" ]; do

   read -p "EXISTS: A docker container exists using $DOCKER_IMAGE. Do you want to delete it along with any changes you've made, and recreate a new one ? " YESNO
   case $YESNO in
       [Yy]* ) break;;
       [Nn]* ) echo; echo "Exiting installer..."; exit;;
       * ) YESNO=""; echo "Please answer yes or no.";;
   esac
done

   CMD="docker stop $OUT"; echo "EXEC: $CMD"; OUT="`$CMD`";
   CMD="docker rm $OUT"; echo "EXEC: $CMD"; OUT="`$CMD`";
fi

YESNO=""
DOWNLOAD_IMAGE="true"

CMD="";
OUT="`docker image list | grep $DOCKER_IMAGE`"

if [ "$OUT" != "" ]; then
while [ "$YESNO" == "" ]; do

   read -p "EXISTS: The docker image $DOCKER_IMAGE is present. Do you want to delete it and download the latest one ? " YESNO
   case $YESNO in
       [Yy]* )
           CMD="docker image rm $DOCKER_IMAGE";
           echo "EXEC: $CMD";
           OUT="`$CMD`";
           break;;
       [Nn]* ) DOWNLOAD_IMAGE=false; break;;
       * ) YESNO=""; echo "Please answer yes or no."; echo;;
   esac
done
fi

if [ "$DOWNLOAD_IMAGE" == "true" ]; then

echo "EXEC: ssh vitae \"cat /data1/vitae/repos/$DOCKER_IMAGE.gz\" | gunzip | pv | docker load"
ssh vitae "cat /data1/vitae/repos/$DOCKER_IMAGE.gz" | gunzip | pv | docker load

fi

if [ "$DOCKER_IMAGE" == "dspace6-ide" ]; then

CMD="docker run -d \
--net=host \
-p 2200:2200 \
-p 8080:8080 \
-p 8443:8443 \
-v /mnt/dspace-assetstore:/opt/tomcat/assetstore \
--name my-$DOCKER_IMAGE \
$DOCKER_IMAGE:latest"

echo "EXEC: $CMD"; OUT=`$CMD`;
echo
echo "FINISHED: To access the container, type the command below. The ssh password is 'asdf'"
echo "ssh -p 2200 -X dspace@localhost"
echo

else

CMD="docker run -d \
--net=host \
-p 8080:8080 \
-p 8443:8443 \
-v /mnt/dspace-assetstore:/opt/tomcat/assetstore \
--name my-$DOCKER_IMAGE \
$DOCKER_IMAGE:latest"

echo "EXEC: $CMD"; OUT=`$CMD`;
echo
echo "FINISHED: To access the container, type the command:"
echo "docker start my-$DOCKER_IMAGE; docker exec -it my-$DOCKER_IMAGE bash"
echo

fi
