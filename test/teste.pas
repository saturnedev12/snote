program teste;
var
 tab : array[1..4] of integer;
 i,somme:integer;
 moyenne:real;
begin
  somme := 0;
  for i := 1 to 4 do
    begin
      write('entrez la note n°',i,': ');
      read(tab[i]);
    end;
    
  for i := 1 to 4 do
    begin
      somme := somme + tab[i];
    end;
     moyenne := somme/ length(tab) ;
     writeln(somme);
     writeln(length(tab));
     writeln('la moyenne est : ',moyenne:20:2);
end.