#!/usr/bin/perl
use strict;
use warnings;

use DBI;
use strict;

my $db_host    = shift @ARGV;
my $db_admin   = shift @ARGV;
my $db_pswd    = shift @ARGV;
my $db_dspace  = shift @ARGV;
my $dbh        = undef;
my $dsn        = undef;
my $NULL       = '_NULL_';

if ( ! $db_host ) {
  $db_host = 'localhost';
}

if ( ! $db_admin ) {
  $db_admin = 'postgresDBA';
}

if ( ! $db_pswd ) {
  $db_pswd = 'postgresD5vops-G5tt.62';
}

if ( ! $db_dspace ) {
  $db_dspace = 'dspacedev';
}

sub open_db {
  my $database = $db_dspace;
  my $userid   = $db_admin;
  my $password = $db_pswd;

  # Connection string for postgres:
  my $driver   = "Pg";

  $dsn = "DBI:$driver:dbname = $database;host = $db_host;port = 5432";

  $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })
     or die $DBI::errstr;

  print "DBACCESS: Opened $dsn successfully\n";
}

sub close_db {
  print "DBACCESS: Closed $dsn successfully\n";
  $dbh->disconnect();
  undef $dbh;
}

sub extract_table {
  my ( $table ) = @_;
  
  my $stmt = qq(SELECT * FROM $table;);
  my $sth = $dbh->prepare( $stmt );
  my $rv = $sth->execute() or die $DBI::errstr;
  if($rv < 0) {
  print $DBI::errstr;
  }
  
  my @names = map { lc } @{$sth->{NAME}};
  my $types = $sth->{TYPE};
  print "SELECT:  ".$stmt."\n";
  print "COLUMNS: ".join( ', ', @names )."\n";
  print "TYPES:   ".join( ', ', @$types )."\n";
  my $rownum = 1;
  my $row;
  
  while( defined( $row = $sth->fetchrow_arrayref() ) ) {
    printf( 'ROW%-6d', $rownum );
    print( join( ', ', map { defined ? $_ : $NULL } @$row )."\n" );
    $rownum++;
  }

  $sth->finish();
  undef $sth;
}

&open_db();

&extract_table( 'metadatafieldregistry' );

&close_db();
