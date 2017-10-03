#!/usr/bin/perl
use strict;
use warnings;

my $srcenv = shift @ARGV;
my $dstdir = shift @ARGV;
my %config_env = ();
my $debug = 0;

# git command outputs the absolute path to root of the repository
my $out = `git rev-parse --show-toplevel`;
chomp($out);
my $dspace_dir = $out;

if ( ! defined( $dstdir ) ) { $dstdir = "run"; }

sub verify_dstdir {
  if ( ! -d "$dstdir" ) {
      die "destination dir $dstdir does not exist\n";
  }
}

sub verify_srcenv {
  
  my @config_files = < "$dspace_dir/overlay/dspace/config/*-*" >;
  my $env_valid = 0;
  
  foreach my $cfg ( @config_files ) {
    print "DEBUG PARSING: $cfg\n" if $debug;

    if ( $cfg =~ /-([^-]+)$/ ) {

      my $new_env = $1;
      chomp ( $new_env );

      if ( $new_env ne "all" && ! defined $config_env{ $new_env } ) {
        $config_env{ $new_env }++;
      }
    }
  }

  if ( ! defined( $config_env{ $srcenv } ) ) {
    die "ERROR: invalid dspace environment: $srcenv\n"
       ."Available environments: ". join( ", ", sort( keys %config_env ) ). "\n";
  }
}

sub overlay_files {

  my ( $suffix ) =  @_;
  my $suffix_len = length( $suffix ) + 1;

  my $cmd = "find $dstdir -type l -name \"*-$suffix\"";
  print "EXEC: $cmd\n";
  my @file_list = `$cmd`;

  foreach my $src_file ( @file_list ) {

    chomp( $src_file );
    print "DEBUG OVERLAY: $src_file\n" if $debug;

    my $dst_file = substr( $src_file, 0, -$suffix_len );
    $cmd = "cp $src_file $dst_file";
    print "EXEC: $cmd\n";
    #`$cmd`;
  }
}

sub overlay_env_config {

  my $cmd = "cd $dspace_dir && bin/overlay-softlink.sh overlay/dspace $dstdir";
  print "EXEC: $cmd\n";
  `$cmd`;

  &overlay_files( "all" );
  &overlay_files( $srcenv );
}

&verify_dstdir();

&verify_srcenv();

&overlay_env_config();
