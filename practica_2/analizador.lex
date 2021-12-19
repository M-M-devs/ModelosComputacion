%{
    int n_asig = 0;
    int n_lec = 0;
    int n_esc = 0;
    int correcto = 0;
    int programa_correcto = 0;
    int main_correcto = 0;
    int punto_coma = 0;
    int lectura_incorrecta = 0;
    int asignacion_err = 0;
    int num_sentencia = 1;
    int num_sentencia_err = 0;
    int num_lectura_err = 0;
    int num_caracter_err = 0;
    int num_asignacion_err = 0;
    int caracter_invalido = 0;

%}
minus           [a-z]
ignore          [ \t]
linea           [ \t\n]
car_inv         [^a-z{}\t\n\;#=MRW ]
variable        ({minus}*)
digito          [0-9]
literal         ({digito}+)
operador        (\-|\+|\*|\/|\%)
operando        ({literal}|{variable})
operacion       ({operando}({ignore}*{operador}{ignore}*{operando})+{ignore}*)
asignacion      ({variable}{ignore}*"="{ignore}*({operando}|{operacion}+){ignore}*)
asignacion_err  ({literal}{ignore}*"="{ignore}*({operando}|{operacion}+){ignore}*)
lectura         ("R"{ignore}*\({ignore}*{variable}{ignore}*\){ignore}*)
lectura_err     ("R"{ignore}*\({ignore}*{literal}{ignore}*\){ignore}*)
escritura       ("W"{ignore}*\({ignore}*({operando}|{operacion}){ignore}*\){ignore}*)
sentencia       (({asignacion}|{lectura}|{operacion}|{escritura})";"{ignore}*)
sentencia_err   (({asignacion}|{lectura}|{operacion}|{escritura})+{linea}?(\})?{ignore}*)
main            ({comentarios}*{linea}*"M"{linea}*"{"{linea}*(({sentencia}|{comentarios}){linea}*)*"}"{linea}*)
main_err        ({main}{linea}*((({sentencia}|{sentencia_err}){linea}*)*)+.+)
operador_solo   ({linea}*{operador}+{linea}*";"?{linea}*)
comentarios     ("#".*)
%%
{operacion}         {printf("Operacion: %s\n", yytext);}
{asignacion}        {printf("Asignacion: %s\n", yytext);}
{lectura}           {printf("Lectura: %s\n", yytext);}
{escritura}         {printf("Escritura: %s\n", yytext);}
{comentarios}       {num_sentencia++;printf("Comentario: %s\n", yytext);}
{sentencia}         {num_sentencia++; printf("Sentencia: %s\n", yytext);}
{lectura_err}       {num_sentencia++; num_lectura_err = num_sentencia; lectura_incorrecta = 1;  printf("Lectura incorrecta: %s\n", yytext);}
{sentencia_err}     {num_sentencia++; num_sentencia_err = num_sentencia; punto_coma = 1;  printf("Sentencia incorrecta: %s\n", yytext);}
{asignacion_err}    {num_sentencia++; num_asignacion_err = num_sentencia; asignacion_err = 1;  printf("Asignacion incorrecta: %s\n", yytext);}
{main}              {programa_correcto = 1;}
{main_err}          {main_correcto = 1;}
{car_inv}           {num_sentencia++; num_caracter_err = num_sentencia; caracter_invalido = 1;}
{operador_solo}     {num_sentencia++; num_caracter_err = num_sentencia; caracter_invalido = 1;}
%%
int main()
{
    yylex();
    printf("\n\n\n");
    printf("**********************************************************\n");
    printf("*                         SALIDA                         *\n");
    printf("**********************************************************\n");
    if(programa_correcto == 1){
        printf("Programa correcto\n");
    }
    else if(programa_correcto == 0 || caracter_invalido == 1){
        printf("Error de sintaxis:\n"); 
        if(punto_coma == 1)
           printf("En la linea %d falta un ;\n", num_sentencia_err);
        if (lectura_incorrecta == 1)
            printf ("En la linea %d No se puede escribir en un literal\n", num_lectura_err);
        if (asignacion_err == 1)
            printf ("En la linea %d No se puede asignar un valor a un literal\n", num_asignacion_err);
        if (main_correcto == 1 && punto_coma == 0)
            printf ("Sentencias declaradas fuera del main\n");
        if(caracter_invalido == 1)
            printf ("En la linea %d caracter invalido detectado\n", num_caracter_err);
        if(main_correcto == 0 && punto_coma == 0 && lectura_incorrecta == 0 && asignacion_err == 0 && caracter_invalido == 0 )
            printf ("Falta main\n");
    }
    return 0;
}