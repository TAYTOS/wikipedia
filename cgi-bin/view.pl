#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $titulo = $q->param('fn');

print $q->header('text/html;charset=UTF-8');

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.0.22";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");;

my $sth = $dbh->prepare("SELECT cuerpo FROM wikipedia WHERE titulo=?");
$sth->execute($titulo);

my @row;
my @text;
while (@row = $sth->fetchrow_array){
  push (@text,@row);
}

$sth->finish;
$dbh->disconnect;

sub matchLine{
  my $linea = $_[0];

  #El primer if para descartar las lineas en blanco
  if (!($linea =~ /^\s*$/ )){

    while ($linea =~ /(.*)(\_)(.*)(\_)(.*)/){
      $linea = "$1<em>$3</em>$5";
    }

    while ($linea =~ /(.*)(\[)(.*)(\])(\()(.*)(\))(.*)/) {
      $linea = "$1<a href='$6'>$3</a>$8";
    }

    while ($linea =~ /(.*)(\*\*\*)(.*)(\*\*\*)(.*)/) {
      $linea = "$1<strong><em>$3</em></strong>$5";
    }

    while ($linea =~ /(.*)(\*\*)(.*)(\*\*)(.*)/) {
      $linea = "$1<strong>$3</strong>$5";
    }

    while ($linea =~ /(.*)(\*)(.*)(\*)(.*)/) {
      $linea = "$1<em>$3</em>$5";
    }

    while ($linea =~ /(.*)(\~\~)(.*)(\~\~)(.*)/){
      $linea = "$1<del>$3</del>$5";
    }

    if ($linea =~ /^(\#)([^#\S].*)/) {
      return $linea = "<h1>$2</h1>\n";
    }

    elsif ($linea =~ /^(\#\#)([^#\S].*)/) {
      return $linea = "<h2>$2</h2>\n";
    }

    elsif ($linea =~ /^(\#\#\#)([^#\S].*)/) {
      return $linea = "<h3>$2</h3>\n";
    }

    elsif ($linea =~ /^(\#\#\#\#)([^#\S].*)/) {
      return $linea = "<h4>$2</h4>\n";
    }

    elsif ($linea =~ /^(\#\#\#\#\#)([^#\S].*)/) {
      return $linea = "<h5>$2</h5>\n";
    }
