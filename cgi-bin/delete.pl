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
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.0.41";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");;

my $sth = $dbh->prepare("DELETE FROM wikipedia WHERE titulo=?");
$sth->execute($titulo);
$sth->finish;
$dbh->disconnect;

my $body = renderBody($titulo);
print renderHTMLpage('Delete',$body);

sub renderBody{
  my $titulo = $_[0];
  my $body = <<"BODY";
  <h1>La página "$titulo" ha sido borrada</h1>
  <hr>
  <h2>Volver a <a href="list.pl">Listado de Páginas</a></h2>
BODY
  return $body;
}

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
