#!/usr/bin/perl
use strict;
use warnings;

my $DOCKER_IMAGE  = "dspace6-dev";
my $DSPACE_SRC    = "dspace-6.1-src-release";

# git command outputs the absolute path to root of the repository
my $out = `git rev-parse --show-toplevel`;
chomp($out);
my $SRC_DIR = $out;

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

  print "\n************* SECTION 2: Environment check ***************\n";

  &check_cmd('Are you running campusrepo-install-dev.pl from the campusrepo repository', '',
                'git remote -v | grep vitae | grep "/data1/vitae/repos/campusrepo.git"',
                "You need to run campusrepo-install-dev.pl from the root of the campusrepo repository");

  &check_cmd( 'Is docker installed', '',
              'docker -v',
              "Docker CE is required. Please install for your system via:\n".
              "   https://docs.docker.com/engine/installation/" );

  &check_cmd( 'Does your system user belong to the "docker" group', '',
              'id | grep docker',
              "Your system user needs to belong to the \"docker\" group\n".
              "Try running the command:\n".
              "sudo usermod -a -G docker <your_unix_userid>" );

  &check_cmd( 'Does the dspace group, gid=800 exist', '800',
              'perl -e \'$gid = getgrnam("dspace"); print $gid\'',
              "Your system needs the group dspace to exist with id=800\n".
              "On linux try running the command:\n".
              "sudo groupadd dspace --gid 800" );

  &check_cmd( 'Does the dspace user, uid=800 exist', '800',
              'perl -e \'$gid = getgrnam("dspace"); print $gid\'',
              "Your system needs the user dspace to exist with id=800\n".
              "On linux try running the command:\n".
              "sudo useradd dspace --uid --gid 800" );

  &check_cmd( 'Does your system user belong to the "dspace" group', '',
              "id $ENV{USER} | grep dspace",
              "Your system user needs to belong to the \"dspace\" group\n".
              "Try running the command:\n".
              "sudo usermod -a -G dspace <your_unix_userid>" );

  &check_cmd( 'Does /opt/tomcat exist with proper permissions', 'success',
              'touch /opt/tomcat/dspace-tst && rm /opt/tomcat/dspace-tst && echo -n "success"',
              "The directory /opt/tomcat needs to exist with rw permissions.\n".
              "Run 'sudo mkdir -p /opt/tomcat; sudo chown $ENV{USER}.$ENV{USER} /opt/tomcat'" );

  &check_cmd( 'Have you mounted //dspace-nfsdev/dspace-assetstore-dev', '',
              'mount | grep dspace-assetstore',
              "The nfs dspace assetstore needs to be mounted. Try running the commands (on linux):\n".
              "sudo cp /etc/fstab /etc/fstab.bak\n".
              "sudo mkdir -p /mnt/dspace-assetstore\n".
              "sudo chown dspace.dspace /mnt/dspace-assetstore\n".
              "sudo echo \"dspace-nfsdev:/dspace-assetstore-dev /mnt/dspace-assetstore nfs nfsvers=4,proto=tcp,hard 0 0\" >> /etc/fstab\n".
              "sudo mount /mnt/dspace-assetstore" );

  &check_cmd( 'Is the pipe progress utility "pv" installed', '',
              'pv --version | head -1',
              "The pv command line utility needs to be installed" );

  &check_cmd( 'Is netstat installed', '',
              'netstat -i 2>/dev/null',
              "The netstat command line utility needs to be installed" );

  &check_cmd( 'Is a service listening at 8080', 'NE',
              'netstat -l --numeric | grep 8080',
              "A service is already listening at port 8080, tomcat will not".
              "be able to start correctly. Please disable the service running at port 8080." );

}

sub checkout_src {

  my $cmd = "";
  my $out = "";
  my $old_umask = umask( 002 );
  my $git_user = undef;

  print "\n************* SECTION 3: Checkout src ***************\n";

  if ( ! -d "$SRC_DIR/src/dspace" ) {
    print "EXEC: exploding the dspace src tarball\n";

    $cmd = "cd $SRC_DIR; ssh vitae 'cat /data1/vitae/repos/$DSPACE_SRC.tar.gz' | pv | tar -xzf -; mv $DSPACE_SRC/* src; rmdir $DSPACE_SRC; cd -";
    print "EXEC: '$cmd'\n";
    `$cmd`;
  }
  else { print "VERIFIED: $SRC_DIR/src/dspace\n"; }

  my @srcdir_cmds =
      (
       "bin/fix-permissions.sh",
       "bin/overlay-softlink.sh overlay src",
      );

    foreach my $src_cmd ( @srcdir_cmds ) {
      $cmd = "cd $SRC_DIR; $src_cmd; cd -";
      print "EXEC: $cmd\n";
      `$cmd`;
    }

    if ( ! -f "$SRC_DIR/src/dspace/config/local.cfg" ) {
      $cmd = "cd $SRC_DIR/src/dspace/config; cp local.cfg-dev local.cfg; cd -";
      print "EXEC: $cmd\n"; $out = `$cmd`;
    }
  else { print "VERIFIED: $SRC_DIR/campusrepo\n"; }

  umask( $old_umask );
  
  # Force recreating softlink of /opt/tomcat/dspace to just created dspace $SRC_DIR
  $cmd = "rm -f /opt/tomcat/dspace; ln -fs $SRC_DIR /opt/tomcat/dspace";
  $out = `$cmd`;
  print "EXEC: '$cmd' returned '$out'\n";
}

sub create_docker_container {

  print "\n************* SECTION 3: Create docker container ***************\n";

  my $cmd = "docker ps -a | grep $DOCKER_IMAGE | awk '{ printf \$1 }'";
  my $out = undef;
  my $docker_id = `$cmd`;
  print "EXEC: $cmd returned '$docker_id'\n";

  if ( length( $docker_id ) ) {
    my $YESNO = undef;
    while ( ! defined( $YESNO ) ) {
      print "EXISTS: A docker container exists using $DOCKER_IMAGE. Do you want to delete it along with any changes you've made, and recreate a new one [y/n]? ";
      chomp( $YESNO = <STDIN> );
      for ( $YESNO ) {
        /[Yy].*/ && do { last; };
        /[Nn].*/ && do { die "Exiting installer...\n"; last; };
        $YESNO = undef;
        print "Please answer yes or no.\n";
      }
    }
    $cmd="docker stop $docker_id"; print "EXEC: $cmd\n"; $out=`$cmd`;
    $cmd="docker rm $docker_id"; print "EXEC: $cmd\n"; $out=`$cmd`;
  }

  my $download_image = 1;
  $cmd = "docker image list | grep $DOCKER_IMAGE";
  $out = `$cmd`;
  print "EXEC: '$cmd' returned '$out'\n";

  if ( length( $out ) ) {
    my $YESNO = undef;
    while ( ! defined( $YESNO ) ) {
      print "EXISTS: The docker image $DOCKER_IMAGE is present. Do you want to delete it and download the latest one [y/n]? ";
      chomp( $YESNO = <STDIN> );
      for ( $YESNO ) {
        /[Yy].*/ && do {
          $cmd = "docker image rm $DOCKER_IMAGE";
          print "EXEC: $cmd\n";
          $out = `$cmd`;
          last };
        /[Nn].*/ && do { $download_image=0; last; };
        $YESNO = undef;
        print "Please answer yes or no.\n";
      }
    }
  }

  if ( $download_image ) {
    $cmd = "ssh vitae \"cat /data1/vitae/repos/$DOCKER_IMAGE.gz\" | gunzip | pv | docker load";
    print "EXEC: $cmd\n";
    `$cmd`;
  }

  $cmd="docker run -d ".
  "--net=host ".
  "-p 8000:8000 ".
  "-p 8080:8080 ".
  "-p 8443:8443 ".
  "-v $SRC_DIR:/opt/tomcat/dspace ".
  "-v /mnt/dspace-assetstore:/opt/tomcat/assetstore ".
  "-it --entrypoint /bin/bash ".
  "--name my-$DOCKER_IMAGE ".
  "$DOCKER_IMAGE:latest";

  print "EXEC: $cmd\n\n"; $out=`$cmd`;
  print "FINISHED: To access the container, type the command:\n";
  print "docker start my-$DOCKER_IMAGE; docker exec -it my-$DOCKER_IMAGE bash\n\n";

  print "\nNOTE: to start tomcat, within the docker container run 'debug-tomcat.sh'\n";
}


&check_env();

&checkout_src();

&create_docker_container();
