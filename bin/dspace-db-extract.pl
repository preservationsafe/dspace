#!/usr/bin/perl
use strict;
use warnings;

use DBI;
use strict;

my $db_host    = shift @ARGV;
my $db_admin   = shift @ARGV;
my $db_pswd    = shift @ARGV;
my $db_dspace  = shift @ARGV;

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

my $driver   = "Pg";
my $database = $db_dspace;
my $dsn      = "DBI:$driver:dbname = $database;host = $db_host;port = 5432";
my $userid   = $db_admin;
my $password = $db_pswd;
my $dbh      = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })
   or die $DBI::errstr;
print "Opened database successfully\n";

my $stmt = qq(SELECT * FROM metadatafieldregistry;);
my $sth = $dbh->prepare( $stmt );
my $rv = $sth->execute() or die $DBI::errstr;
if($rv < 0) {
print $DBI::errstr;
}

my $names = $sth->{NAME};
my $types = $sth->{TYPE};
print "COLUMNS: ".join( ', ', @names )."\n";
my $row = 1;

while(my @row = $sth->fetchrow_array()) {
  printf 'ROW%-6d%s', $row, join( ', ', @row )."\n";
  row++;
}
print "Operation done successfully\n";
$dbh->disconnect();
