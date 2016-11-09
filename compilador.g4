grammar compilador;


@header {
         import java.util.Set;
         
}

@members {
         String teste = "";         
          
         public static boolean isNumeric(String str)
        {
            for (char c : str.toCharArray())
            {
                if (!Character.isDigit(c)) return false;
            }
            return true;
        }
}
// regras sintáticas

programa : pacote? classe*;

pacote : PACKAGE IDENTIFICADOR (PONTO IDENTIFICADOR)* PV;

classe : PUBLIC? CLASS IDENTIFICADOR AC metodo* FC;

metodo : visibilidade? retorno IDENTIFICADOR AP 
         (parametro lista_parametro*)? FP AC declaracao* FC;

parametro : TIPO IDENTIFICADOR;
lista_parametro : VIRGULA parametro;

retorno : TIPO | VOID;

declaracao : var_declaracao PV | if_declaracao | for_declaracao;             

var_declaracao : TIPO IDENTIFICADOR (OP_ATRIBUICAO valor)? {
                                                            
   if ($TIPO.text.equals("int")) {        
    System.out.println("Tipo: " + $TIPO.text);    
    if (!isNumeric($valor.text)) {                        
      System.out.println("Tipo inválido! Linha: " + $start.getLine());
    }                                 
   }
                                        
};
                 
if_declaracao : if_dec
                (ELSE if_dec)*
                (ELSE AC declaracao* FC)?              
              ;

for_declaracao : FOR AP var_declaracao? PV expr_logica 
                 PV expr_aritmetica? FP AC declaracao* FC;

if_dec : IF AP expr_logica FP AC  declaracao* FC;

expr_logica : valor OP_LOGICO valor;
expr_aritmetica : valor OP_ARITMETICO valor | IDENTIFICADOR OP_UNARIO;

valor : IDENTIFICADOR | NUMERO;

visibilidade : PUBLIC | VISIBILIDADE;

// regras léxicas
FOR : 'for';
PACKAGE : 'package';
PONTO : '.';
CLASS : 'class';
VIRGULA : ',';
VISIBILIDADE : 'private' | 'protected';
PUBLIC : 'public';
VOID : 'void';
ELSE : 'else';
IF : 'if';
AC : '{';
FC : '}';
AP : '(';
FP : ')';
PV : ';';
TIPO : 'int' | 'double' | 'char' | 'long' | 'float';
OP_LOGICO : '<' | '>' | '==' | '!=' | '>=' | '<=';
OP_ATRIBUICAO : '=';
OP_ARITMETICO : '+' | '-' | '*' | '/' | '%';
OP_UNARIO : '++' | '--';
IDENTIFICADOR : [a-z]([a-z]|[0-9])*;
NUMERO : [0-9]+;


WS : [' '|'\r'|'\n'|'\t'] -> skip;
