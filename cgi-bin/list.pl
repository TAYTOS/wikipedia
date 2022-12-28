#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
print $q->header('text/html;charset=UTF-8');

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.0.41";
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
my $HTMLtitulos = renderSelect(@titles);
my $body = renderBody($HTMLtitulos);
print renderHTMLpage('List',$body);

sub renderSelect{
  my @lines = @_;
  my $titulos = "";
  foreach my $titulo (@lines){
    if (defined($titulo)){
      my $link_delete = "<a href='delete.pl?fn=$titulo' id='linkboton'>X</a>";
      my $link_edit = "<a href='edit.pl?fn=$titulo' id='linkboton'>E</a>";
      $titulos.= "     <li><a href='view.pl?fn=$titulo'>$titulo</a> $link_delete $link_edit</li>\n";
    }
  }
  return $titulos;
}

sub renderBody{
  my $HTMLtitulos = $_[0];
  my $body = <<"BODY";
    <h1>Nuestras páginas de wikipedia</h1>
    <ul>
    $HTMLtitulos
    </ul>
    <hr>
    <a href="../new.html">Nueva página</a>
    <br>
    <a href="../index.html">Volver al inicio</a>
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
