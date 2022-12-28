#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $titulo = $q->param("titulo");
my $texto = $q->param("texto");
print $q->header('text/html;charset=UTF-8');

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.0.41";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");;

my $sth = $dbh->prepare("SELECT titulo FROM wikipedia WHERE titulo=?");
$sth->execute($titulo);
my @row;
my @titles;
while (@row = $sth->fetchrow_array){
  push (@titles,@row);
}
$sth->finish;
my $estado="";     

if($titles[0]eq($titulo)){
  my $sth1 = $dbh->prepare ("UPDATE wikipedia SET cuerpo=? WHERE titulo=?");
  $sth1->execute($texto, $titulo);
  $sth1->finish;
  $estado="Página actualizada";
}
else{  
  my $sth2 = $dbh->prepare("INSERT INTO wikipedia (titulo, cuerpo) VALUES (?,?)");
  $sth2->execute($titulo, $texto);
  $sth2->finish;
  $estado="Página grabada";
}
$dbh->disconnect;

my $body = renderBody($titulo,$texto,$estado);
print renderHTMLpage('Edit',$body);

sub renderBody{
  my $titulo = $_[0];
  my $texto = $_[1];
  my $estado = $_[2];
  my $body = <<"BODY";
  <h1>$titulo</h1>
    <pre>
$texto
    </pre>
    <hr>
    <h2>$estado</h2>
    <h3><a href="view.pl?fn=$titulo">Ver Página</a> - <a href="list.pl">Listado de Páginas</a></h3>
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
