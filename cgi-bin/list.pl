#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
print $q->header('text/html;charset=UTF-8');

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.0.22";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");;

my $sth = $dbh->prepare("SELECT titulo FROM wikipedia");
$sth->execute();
my @row;
my @titles;
while (@row = $sth->fetchrow_array){
  push (@titles,@row);
}

$sth->finish;
$dbh->disconnect;
my $body = renderBody($HTMLtitulos);
print renderHTMLpage('List',$body);

sub renderHTMLpage{
  my $title = $_[0];
  my $body = $_[1];
  my $html = <<"HTML";
<!DOCTYPE html>
<html lang="es">
  <head>
    <title>$title</title>
    <meta charset="UTF-8">
  </head>
  <body>
    $body
  </body>
</html>
HTML
  return $html;
}