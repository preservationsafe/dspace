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

sub extract_table_sql_filter {
  my ( $table, $order_col, $null_column_list ) = @_;

  # Columns to order by
  my $order_by = "";
  if ( defined( $order_col ) && @$order_col > 0 ) {
    $order_by = " ORDER BY ".join( ",", @$order_col );
  }

  my $stmt = "SELECT * FROM $table".$order_by.";";
  my $sth = $dbh->prepare( $stmt );
  my $rv = $sth->execute() or die $DBI::errstr;
  if($rv < 0) {
  print $DBI::errstr;
  }

  # columns to overwrite with null values even if they have a value
  # present. For instance, collection image bitstreams need to get nulled
  # because we currently are not exporting the bitstream images.
  my %null_column = ();
  if ( defined( $null_column_list ) && @$null_column_list > 0 ) {
    foreach my $col ( @$null_column_list ) {
      $null_column{ $col }++;
    }
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

      if ( ! defined $$row[ $i ] ||
           defined( $null_column{ $columns[ $i ] } ) ) {
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

sub extract_table_sql {
  return &extract_table_sql_filter( @_ );
}

sub extract_table_metadataschemaregistry {
  my ( $table ) = @_;
  my @order_by  = ( "metadata_schema_id" );
  return &extract_table_sql_filter( $table, \@order_by );
}

sub extract_table_metadatafieldregistry {
  return &extract_table_sql_filter( @_ );
}

sub extract_table_eperson {
  return &extract_table_sql_filter( @_ );
}

sub extract_table_epersongroup {
  my ( $table ) = @_;
  my @order_by  = ( "eperson_group_id" );
  return &extract_table_sql_filter( $table, \@order_by );
}

sub extract_table_epersongroup2eperson {
  return &extract_table_sql_filter( @_ );
}

sub extract_table_community {
  my ( $table ) = @_;
  my @order_by  = ( "community_id" );
  my @null_cols = ( "logo_bitstream_id" );
  return &extract_table_sql_filter( $table, \@order_by, \@null_cols );
}

sub extract_table_community2community {
  return &extract_table_sql_filter( @_ );
}

sub extract_table_collection {
  return &extract_table_sql_filter( @_ );
}

sub extract_table_community2collection {
  return &extract_table_sql_filter( @_ );
}

sub extract_table_subscription {
  return &extract_table_sql_filter( @_ );
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

sub extract_table_ref {
  no strict 'refs';
  my ( $extract_table_func, $table ) = @_;
  # Calls the function whose name is within $extract_table_func:
  &$extract_table_func( $table );
}

sub extract_seed_tables {

  # Note this is a purposefully ordered array, we want
  # the import of these tables done in this order
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

  # Calling the function associated with the table name
  for my $table ( @seed_tables ) {
    my $extract_table_func = "extract_table_".$table;

    if ( ! $output_sql ) {
      $extract_table_func = "extract_table_stdout";
    }

    &extract_table_ref( $extract_table_func, $table );
  }

  &output_uuid_table_sql();
}

&init_cmd_params();

&open_db();

&extract_seed_tables();

&close_db();
