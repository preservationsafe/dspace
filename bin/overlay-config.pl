#!/usr/bin/perl
use strict;
use warnings;

my $srcenv = shift @ARGV;
my $dstdir = shift @ARGV;
my %config_env = ();
my $debug = 0;
my $softlink = 0;

# git command outputs the absolute path to root of the repository
my $out = `git rev-parse --show-toplevel`;
chomp($out);
my $dspace_dir = $out;

if ( ! defined( $dstdir ) ) { $dstdir = "dspace-install/config"; }

sub verify_dstdir {
  if ( ! -d "$dstdir" ) {
      die "destination dir $dstdir does not exist\n";
  }
}

sub verify_srcenv {
  
  my @config_files = < "$dstdir/*-*" >;
  my $env_valid = 0;
  
  foreach my $cfg ( @config_files ) {
    print "DEBUG PARSING: $cfg\n" if $debug;

    if ( $cfg =~ /\.[^-]*-([^-]+)$/ ) {

      my $new_env = $1;
      chomp ( $new_env );

      if ( $new_env ne "all" && ! defined $config_env{ $new_env } ) {
        $config_env{ $new_env }++;
      }
    }
  }

  if ( ! keys %config_env ) {
    die "ERROR: dst directory $dstdir does not have any configuration overlay.\n"
       ."ERROR: run $dspace_dir/bin/overlay-softlink.sh overlay/dspace/config $dstdir\n";
  }

  if ( ! defined ( $srcenv ) || ! defined( $config_env{ $srcenv } ) ) {
    die "ERROR: invalid dspace environment [$srcenv]\n"
      ."ERROR: Available environments: ". join( ", ", sort( keys %config_env ) ). "\n\n"
      ."USAGE: overlay-config.pl <environment-suffix> [dest_dir=dspace-install/config]\n"
      ."EXAMPLE: overlay-config.pl tst\n";
  }
}

sub exec_cmd {
  my ( $cmd ) =  @_;
  print "EXEC: $cmd\n";
  `$cmd`;
}

sub overlay_files {

  my ( $suffix ) =  @_;
  my $suffix_len = length( $suffix ) + 1;

  my $cmd = "find $dstdir -type f -name \"*-$suffix\"";
  print "EXEC: $cmd\n";
  my @file_list = `$cmd`;

  foreach my $src_file ( @file_list ) {

    chomp( $src_file );
    print "DEBUG OVERLAY: $src_file\n" if $debug;

    my $dst_file = substr( $src_file, 0, -$suffix_len );
    if ( $dst_file =~ /local.cfg$/ ) {
      # Because local.cfg is used by Apache Commons Configuration, it can't be a softlink"
      &exec_cmd( "cp $src_file $dst_file" );
    }
    else {
      if ( ! -e "$dst_file-orig" ) {
        &exec_cmd( "mv $dst_file $dst_file-orig" );
      }
      # Note $softlink = 0 for now.
      # mvn test is broken when dependant files are softlinks
      if ( $softlink ) {
        &exec_cmd( "rm $dst_file" );
        &exec_cmd( "cp -a $src_file $dst_file" );
      }
      else {
        &exec_cmd( "cp $src_file $dst_file" );
      }
    }
  }
}

sub overlay_env_config {

  &overlay_files( "all" );
  &overlay_files( $srcenv );
}

&verify_dstdir();

&verify_srcenv();

&overlay_env_config();
