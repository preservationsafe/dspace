#!/usr/bin/perl
use strict;
use warnings;

my %url_list;
my %file_list;

foreach my $filename ( @ARGV ) {
  print STDERR "OPENING " . $filename . "\n";

#  open( my $fh, '<:encoding(UTF-8)', $filename )
  open( my $fh, '<', $filename )
    or die "Could not open file '$filename' $!";

  while ( <$fh> ) {
    while ( $_ =~ m|(https?://[^/'\| \\]+)|g ) {
      $url_list{ $1 }++;
      $file_list{ $filename }{ $1 }++;
    }
  }

  close $fh;
}

sub print_url_list {
  my ( $urls ) = @_;

  
  my @sort_appeared = sort { $$urls{$b} <=> $$urls{$a} } keys %$urls;
  
  foreach my $url ( @sort_appeared ) {
    print "[URL] " . $url . " APPEARED " . $$urls{ $url } . "\n";
  }
}

&print_url_list( \%url_list );

foreach my $file ( keys %file_list ) {

  print "\n";
  print "[FILE] " . $file . "\n";
  print_url_list( $file_list{ $file } );
}

  
# From https://stackoverflow.com/questions/3958180/how-can-i-extract-urls-from-plain-text-in-perl, but tricky to use:
# my ( %url ) = $_ =~ /((?<=[^a-zA-Z0-9])(?:https?\:\/\/|[a-zA-Z0-9]{1,}\.{1}|\b)(?:\w{1,}\.{1}){1,5}(?:com|org|edu|gov|uk|net|ca|de|jp|fr|au|us|ru|ch|it|nl|se|no|es|mil|iq|io|ac|ly|sm){1}(?:\/[a-zA-Z0-9]{1,})*)/mg;
