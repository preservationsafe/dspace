#!/usr/bin/perl
use strict;
use warnings;

use DBI;
use strict;

my $dev_env    = shift @ARGV;
my $db_host    = shift @ARGV;
my $db_admin   = shift @ARGV;
my $db_pswd    = shift @ARGV;
my $db_dspace  = shift @ARGV;
my $output_sql = 1;
my $output_dir = "sql";
my $datetime   = ""; # "-".`date +%Y-%m-%d.%H.%M.%S`;
my $dbh        = undef;
my $dsn        = undef;
my $NULL       = '_NULL_';
my $table_num  = 2;  # prefix table.sql files starting with 02
my %uuid       = ();

sub init_cmd_params {

  chomp( $datetime );
  
  if ( ! length( $dev_env ) || $dev_env eq "tst" ) {
    $dev_env = 0;
    }
  else {
    $dev_env = 1;
  }
  
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

  if ( ! -d $output_dir ) {
    `mkdir -p "$output_dir"`;
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

sub extract_table_stdout {
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

sub extract_table_sql {
  my ( $table ) = @_;
  
  my $stmt = qq(SELECT * FROM $table;);
  my $sth = $dbh->prepare( $stmt );
  my $rv = $sth->execute() or die $DBI::errstr;
  if($rv < 0) {
  print $DBI::errstr;
  }

  my $prefix = sprintf( "%02d", $table_num );
  $table_num++;
  
  my $filename = "$output_dir/$prefix-$table$datetime.sql";
  my $fh = undef;
  open( $fh, "> $filename" ) || die "ERR: Could not open file '$filename' $!";
  
  my @columns = map { lc } @{$sth->{NAME}};
  my $types = $sth->{TYPE};
  print "SELECT:  ".$stmt."\n";
  my $rownum = 1;
  my $row;
  
  while( defined( $row = $sth->fetchrow_arrayref() ) ) {

    print( $fh "INSERT INTO $table ("
           .join( ',', @columns )
           .") VALUES (" );

    for my $i ( 0 .. $#$types ) {
      if ( $i != 0 ) {
        print( $fh "," );
      }

      if ( ! defined $$row[ $i ] ) {
        print( $fh "NULL" );
      }
      else {
        if ( $columns[ $i ] eq "uuid" ) {
          $uuid{ $$row[ $i ] }++;
        }
        
        # type 4 is integer
        if ( $$types[ $i ] == 4 ) {
          print( $fh $$row[ $i ] );
        }
        else {
          print( $fh "'".$$row[ $i ]."'" );
        }
      }
    }
    print( $fh ");\n" );
    $rownum++;
  }

  close( $fh );
  $sth->finish();
  undef $sth;
}

sub output_uuid_table_sql {
  my $table = "dspaceobject";
  my $prefix = "01";
  my @columns = ( "uuid" );
  my $filename = "$output_dir/$prefix-$table-$datetime.sql";
  my $fh = undef;
  open( $fh, "> $filename" ) || die "ERR: Could not open file '$filename' $!";
  
  print "OUTPUT: dspaceobject table [uuid]\n";

  foreach my $id ( sort keys %uuid ) {
    print( $fh "INSERT INTO $table ("
           .join( ',', @columns )
           .") VALUES ("
           ."'".$id."'".");\n" );
  }

  close( $fh );
}

sub extract_seed_tables {

  my @seed_tables = (
                     'metadataschemaregistry',
                     'metadatafieldregistry' ,
                     'eperson'               ,
                     'epersongroup'          ,
                     'epersongroup2eperson'  ,
                     'community'             ,
                     'community2community'   ,
                     'collection'            ,
                     'community2collection'  ,
                     'subscription'          ,
                     );

  # Hash of db tables to their processing functions
  my %table_func = (
                     'metadataschemaregistry' => \&extract_table_sql,
                     'metadatafieldregistry'  => \&extract_table_sql,
                     'eperson'                => \&extract_table_sql,
                     'epersongroup'           => \&extract_table_sql,
                     'epersongroup2eperson'   => \&extract_table_sql,
                     'community'              => \&extract_table_sql,
                     'community2community'    => \&extract_table_sql,
                     'collection'             => \&extract_table_sql,
                     'community2collection'   => \&extract_table_sql,
                     'subscription'           => \&extract_table_sql,
                     );

  if ( ! $output_sql ) {
    foreach my $table ( @seed_tables ) {
      $table_func{ $table } = \&extract_table_stdout;
    }
  }

  # Calling the function associated with the table name
  for my $table ( @seed_tables ) {
    $table_func{ $table }->( $table );
  }

  &output_uuid_table_sql();
}

&init_cmd_params();

&open_db();

&extract_seed_tables();

&close_db();
