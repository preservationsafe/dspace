#!/usr/bin/perl
use strict;
use warnings;

use DBI;
use strict;

my $db_host    = shift @ARGV;
my $db_admin   = shift @ARGV;
my $db_pswd    = shift @ARGV;
my $db_dspace  = shift @ARGV;
my $dev_env    = 0;
my $dbh        = undef;
my $dsn        = undef;
my $NULL       = '_NULL_';

if ( ! $db_host ) {
  if ( $dev_env ) {
    $db_host = 'localhost';
  }
  else {
    $db_host = 'repository-dbdev';
  }
}

if ( ! $db_admin ) {
  if ( $dev_env ) {
    $db_admin = 'dspace6dba';
  }
  else {
    $db_admin = 'dspacedba';
  }
}

if ( ! $db_pswd ) {
  if ( $dev_env ) {
    $db_pswd = "dspace6D5vops-G5tt62";
  }
  else {
    $db_pswd = "dspaceD5vops-G5tt62";
  }
}

if ( ! $db_dspace ) {
  if ( $dev_env ) {
    $db_dspace = 'dspacedev';
  }
  else {
    $db_dspace = 'dspacetst';
  }
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

sub extract_seed_tables {

  my @seed_tables = (
                     'metadataschemaregistry',
                     'metadatafieldregistry',
                     'eperson',
                     'epersongroup',
                     'epersongroup2eperson',
                     'community',
                     'community2community',
                     'collection',
                     'community2collection',
                     'subscription',
                     );

  for my $table ( @seed_tables ) {
    &extract_table( $table );
  }
}

&open_db();

&extract_seed_tables();

&close_db();
