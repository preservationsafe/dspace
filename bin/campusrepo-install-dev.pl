#!/usr/bin/perl
use strict;
use warnings;

my $DOCKER_IMAGE  = "dspace6-dev";
my $DSPACE_SRC    = "dspace-6.1-src-release";
my $SRC_DIR       = "$ENV{HOME}/dspace";
my $DEVSTYLE      = undef;
my $HOST_TYPE     = undef;
my $HOST_DIR      = undef;

sub get_dev_style {

print <<EOF;

************* SECTION 1: UofA Library Dspace Development ***************

Please select how you would like to develop with dspace. Note: all options integrate with docker at some point. The following options were derived from:

https://wiki.duraspace.org/display/DSDOC6x/Installing+DSpace

1. Host development - the developer is responsible for setting up their host machine with the development environment needed to build dspace as described in the link above. Docker will be used to run tomcat for runtime debugging. Docker image is 1.1GB.

2. Host editing - the developer will edit the dspace src code on the host machine. Within docker the code will be built through the command line and run within tomcat. Debugging can happen outside docker in an ide. Docker image is 1.1GB.

3. Docker cmdline development. All src code editing, building, and debugging is done through the cmdline within docker. Provided editors include emacs-nox, vim, nano. Building and debugging is also done within docker, it is assumed the developer knows how to runtime debug java code through the commandline. Docker image is 1.1GB.

4. Docker ide development. All src code editing, building, and debugging is done through an ide within docker, opened via ssh X11 forwarding. In addition to command line editors, included ide are Intellij, Netbeans, Eclipse, emacs (windowed), Atom, MS Code. The host machine must be running X11. Docker image is 4.8GB

EOF

  while ( ! defined( $DEVSTYLE ) ) {
    print "Which development style would you prefer ?\n";
    chomp( $DEVSTYLE = <STDIN> );
    for ( $DEVSTYLE ) {
      /1/ && do { $HOST_TYPE="runtime"; $HOST_DIR="/opt/tomcat/dspace/run"; last; };
      /2/ && do { $HOST_TYPE="source"; $HOST_DIR="$SRC_DIR"; last; };
      /3/ && last;
      /4/ && do { $DOCKER_IMAGE="dspace6-ide"; last; };
      $DEVSTYLE = undef;
      print "Please enter 1-4, or hold Ctrl-C to cancel\n";
    }
  }
}

sub check_cmd {
  my ( $env, $val, $cmd, $err_info ) = @_;
  
  print "CHECK: $env ?\n";
  my $out = `$cmd`;
  chomp( $out );
  #print "DEBUG: '$out'\n";
  
  my $success = 1;
  if ( ! length( $val ) ) { if ( ! length( $out ) ) { $success = 0; } }
  elsif ( $val eq 'NE' ) { if ( length( $out ) > 0 ) { $success = 0; } }
  elsif ( $out ne $val ) { $success = 0; }
  if ( ! $success ) { die "ERROR: \"$cmd\" failed\n\n$err_info\n\n" }
  print "CHECK: \"$cmd\" returned '$out'\n"
}

sub check_env {

  print "************* SECTION 2: Environment check ***************\n";

  &check_cmd( 'Is docker installed', '',
              'docker -v',
              'Docker CE is required. Please install for your system via:\n'.
              '   https://docs.docker.com/engine/installation/' );

  &check_cmd( 'Does your system user belong to the "docker" group', '',
              'id | grep docker',
              'Your system user needs to belong to the "docker" group\n'.
              'Try running the command:\n'.
              'sudo usermod -a -G docker <your_unix_userid>' );

  &check_cmd( 'Does the dspace group, id=800 exist', '800',
              'perl -e \'$gid = getgrnam("dspace"); print $gid\'',
              'Your system needs the group dspace to exist with id=800\n'.
              'On linux try running the command:\n'.
              'sudo groupadd dspace --gid 800' );

  &check_cmd( 'Does the dspace user, id=800 exist', '800',
              'perl -e \'$gid = getgrnam("dspace"); print $gid\'',
              'Your system needs the user dspace to exist with id=800\n'.
              'On linux try running the command:\n'.
              'sudo useradd dspace --uid --gid 800' );

  &check_cmd( 'Does your system user belong to the "dspace" group', '',
              'id | grep dspace',
              'Your system user needs to belong to the "dspace" group\n'.
              'Try running the command:\n'.
              'sudo usermod -a -G dspace <your_unix_userid>' );

  &check_cmd( 'Does /opt/tomcat exist with proper permissions', 'success',
              'touch /opt/tomcat/dspace-tst && rm /opt/tomcat/dspace-tst && echo -n "success"',
              "The directory /opt/tomcat needs to exist with rw permissions.\n".
              "Run 'sudo mkdir -p /opt/tomcat; sudo chown $ENV{USER}.$ENV{USER} /opt/tomcat'" );

  &check_cmd( 'Is the pipe progress utility "pv" installed', '',
              'pv --version | head -1',
              'The pv command line utility needs to be installed' );

  &check_cmd( 'Is netstat installed', '',
              'netstat -i 2>/dev/null',
              'The netstat command line utility needs to be installed' );

  &check_cmd( 'Is a service listening at 8080', 'NE',
              'netstat -l --numeric | grep 8080',
              'A service is already listening at port 8080, tomcat will not'.
              'be able to start correctly. Please disable the service running at port 8080.' );

  if ( $DEVSTYLE eq '4' ) {
    &check_cmd( 'Is X running', '',
                '$DISPLAY',
                'The IDE docker requires X to be running\n'.
                'debian/ubuntu: \'sudo apt-get install x-windows-system\'\n'.
                'redhat: yum groupinstall \'X Window System\'\n'.
                'macos: install XQuartz\n'.
                'mswin: install Xming\n' );
  }
}

sub checkout_src {

  my $cmd = "";
  my $out = "";

  print "************* SECTION 3: Checkout src ***************\n";

  while ( ! -d $SRC_DIR ) {

    my $GOOD_DIR = 'b';
    while ( $GOOD_DIR ne '' ) {
      print "EXEC: What directory should contain your dspace code, [enter] defaults to $SRC_DIR ?\n";
      my $NEW_DIR = <STDIN>;
      chomp( $NEW_DIR );
      if ( length( $NEW_DIR ) ) {
        $SRC_DIR = $NEW_DIR;
      }
      print "EXEC: About to create $SRC_DIR, hit [enter] to proceed, anything else to restart.\n";
      chomp( $GOOD_DIR = <STDIN> );
    }

    if ( ! -d $SRC_DIR ) {
      $cmd = "mkdir -p $SRC_DIR && chgrp dspace $SRC_DIR && chmod 2775 $SRC_DIR";
      $out = `$cmd`;
      print "EXEC: '$cmd' returned '$out'\n";
    }
  }

  if ( ! -d "$SRC_DIR/campusrepo" ) {
    print "EXEC: cloning the git campusrepo from vitae.\n";

    $cmd = "cd $SRC_DIR; git clone $ENV{'USER'}\@vitae:/data1/vitae/repos/campusrepo.git; cd -";
    print "EXEC: '$cmd'\n";
    `$cmd`;
  }
  else { print "VERIFIED: $SRC_DIR/campusrepo\n"; }

  if ( ! -d "$SRC_DIR/src" ) {
    print "EXEC: exploding the dspace src tarball\n";

    $cmd = "cd $SRC_DIR; ssh vitae 'cat /data1/vitae/repos/$DSPACE_SRC.tar.gz' | pv | tar -xzf -; mv $DSPACE_SRC src; cd -";
    print "EXEC: '$cmd'\n";
    `$cmd`;
  }
  else { print "VERIFIED: $SRC_DIR/src\n"; }

  if ( ! -d "$SRC_DIR/run" ) {
    print "EXEC: creating the dspace run directory\n";
    $cmd = "mkdir $SRC_DIR/run";
    $out = `$cmd`;
    print "EXEC: '$cmd' returned '$out'\n";
  }
  else { print "VERIFIED: $SRC_DIR/run\n"; }

  if ( ! -l "/opt/tomcat/dspace" ) {
    print "EXEC: creating /opt/tomcat/dspace softlink\n";
    $cmd = "ln -s $SRC_DIR /opt/tomcat/dspace";
    $out = `$cmd`;
    print "EXEC: '$cmd' returned '$out'\n";
  }
  else { print "VERIFIED: /opt/tomcat/dspace\n"; }

  $cmd = "cd $SRC_DIR; campusrepo/bin/overlay-softlink.sh campusrepo src; cd -";
  print "EXEC: $cmd\n";
  `$cmd`;
}

&get_dev_style();

&check_env();

&checkout_src();

#&create_docker_container();
