grammar compilador2;

@header {

import java.util.Map;
import java.util.HashMap;
         
}

@members {
          
          Map<String, TSToken> ts = new HashMap<String, TSToken>();
          
          class TSToken {
              public String nome;
              public String tipo;
              public Object valor;
              public int linha;
          }
          
        public static boolean isNumeric(String str) {
            for (char c : str.toCharArray())
            {
                if (!Character.isDigit(c)) return false;
            }
            return true;
        }

        public static boolean isString(String str) {
            char [] vetor = str.toCharArray();
            if (vetor[0] == '\"') {
                return true;
            } else {
                return false;
            }
        }
        
        public static boolean isBoolean(String str) {
            try {
                 Boolean.parseBoolean(str);
                 return true;                 
            } catch (Exception e) {
                return false;
            }                       
        }        
        
        public void adicionarToken(String nome, String tipo, 
             Object valor, int linha) {
                                       
            TSToken token = new TSToken();
            token.nome = nome;
            token.tipo = tipo;
            token.valor = valor;
            token.linha = linha;
         
            ts.put(nome, token);                                                                            
        }                                                                                      
                                                                                              
}

// regras sintáticas

programa : pacote? classe* {
    for (TSToken token : ts.values()) {
        System.out.println("Nome: " + token.nome + 
        " Tipo: " + token.tipo + " Valor: " + token.valor + " Linha: " + token.linha);                                   
    }
                            
};

pacote : PACKAGE IDENTIFICADOR (PONTO IDENTIFICADOR)* PV;

classe : PUBLIC? CLASS IDENTIFICADOR AC metodo* FC {
     System.out.println("Classe = " + $IDENTIFICADOR.text);                                               
                                                    
};

metodo : visibilidade? retorno IDENTIFICADOR AP 
         (parametro lista_parametro*)? FP AC declaracao* FC;

parametro : TIPO IDENTIFICADOR;
lista_parametro : VIRGULA parametro;

retorno : TIPO | VOID;

declaracao : var_declaracao PV | if_declaracao | for_declaracao |
             var_atribuicao PV ;

var_declaracao : TIPO IDENTIFICADOR (OP_ATRIBUICAO valor)? {
  if (ts.get($IDENTIFICADOR.text) != null) {
      System.out.println("Erro! Variável já declarada: " + $start.getLine());                                           
  } else {                                          
    if ($TIPO.text.equals("int")) {
                                   
      if (isNumeric($valor.text)) {             
         adicionarToken($IDENTIFICADOR.text, $TIPO.text, 
            Integer.parseInt($valor.text), $start.getLine());
      } else {
         System.out.println("Valor não é um inteiro: " + $start.getLine());       
       }                             
    } else if ($TIPO.text.equals("String")) {
      if (isString($valor.text)) {
         adicionarToken($IDENTIFICADOR.text, $TIPO.text, 
            $valor.text, $start.getLine());         
      } else {
         System.out.println("Valor não é uma String: " + $start.getLine());       
       }                                     
    } else if ($TIPO.text.equals("boolean")) {
      if (isBoolean($valor.text)) {
         adicionarToken($IDENTIFICADOR.text, $TIPO.text, $valor.text, $start.getLine());          
      } else {
         System.out.println("Valor não é uma boolean: " + $start.getLine());       
       }                                     
    } 
  }
};

var_atribuicao : IDENTIFICADOR OP_ATRIBUICAO valor { 
  TSToken token =  ts.get($IDENTIFICADOR.text);  
  
  if (token == null) {
     System.out.println("Erro! Variável " + $IDENTIFICADOR.text 
        + " não declarada: " + $start.getLine());                                        
  } else {  
    String tipo = token.tipo;
    if (tipo.equals("int")) {     
      if (isNumeric($valor.text)) {             
         adicionarToken($IDENTIFICADOR.text, tipo, Integer.parseInt($valor.text), token.linha);                           
      } else {
         System.out.println("Valor não é um inteiro: " + $start.getLine());       
       }                             
    } else if (tipo.equals("String")) {
      if (isString($valor.text)) {
         adicionarToken($IDENTIFICADOR.text, tipo, $valor.text, token.linha);          
      } else {
         System.out.println("Valor não é uma String: " + $start.getLine());       
       }                                     
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

valor : IDENTIFICADOR | NUMERO | STRING | BOOLEANO;

visibilidade : PUBLIC | VISIBILIDADE;

// regras léxicas
FOR : 'for';
PACKAGE : 'package';
PONTO : '.';
CLASS : 'class';
VIRGULA : ',';
VISIBILIDADE : 'private' | 'protected';
STRING : '\"' IDENTIFICADOR* '\"'; 
PUBLIC : 'public';
VOID : 'void';
ELSE : 'else';
IF : 'if';
AC : '{';
FC : '}';
AP : '(';
FP : ')';
PV : ';';
TIPO : 'int' | 'double' | 'char' | 'long' | 'float' | 'String' | 'boolean';
OP_LOGICO : '<' | '>' | '==' | '!=' | '>=' | '<=';
OP_ATRIBUICAO : '=';
OP_ARITMETICO : '+' | '-' | '*' | '/' | '%';
OP_UNARIO : '++' | '--';
IDENTIFICADOR : [a-z]([a-z]|[0-9])*;
NUMERO : [0-9]+;
BOOLEANO : 'true' | 'false';


WS : [' '|'\r'|'\n'|'\t'] -> skip;
