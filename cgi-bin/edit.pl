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
my $dsn = "DBI:MariaDB:database=pweb1;host=192.168.0.34";
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

my $body = renderBody($titulo,@text);
print renderHTMLpage('Edit',$body);

sub renderBody{
  my $titulo = $_[0];
  my $texto = $_[1];
  my $body = <<"BODY";
     <h1>$titulo</h1>
     <form action="new.pl">
      <label for="texto">Texto</label>
        <textarea id="cuadro_texto" name="texto" required>$texto</textarea>
      <br>
      <input type="hidden" name="titulo" value="$titulo">
      <input type="submit" id="boton_submit" value="Enviar">
    </form>
    <br>
    <a href="list.pl">Cancelar</a>
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
