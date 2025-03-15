# lexicalAnalyser
Lexical Analyser developed by Angel Tapia &amp; Carlos Arroyo

How to use?

Install lex or flex:
Write in the terminal:
sudo apt install flex

Go to the file directory and execute the next commands in the terminal:
flex [fileName].l 
in this case 
flex analizador.l 

Then we will get a file called "lex.yy.c"

compile using:
gcc lex.yy.c 

Then we will get a file called "a.out" or "a.exe" 
execute with the automatic test
./a.out prueba.txt

