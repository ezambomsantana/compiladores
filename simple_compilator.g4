grammar simple_compilator;

@header {
    import java.util.Map;
    import java.util.HashMap;         
}

@members {
          
          Map<String, TSToken> ts = new HashMap<String, TSToken>();
          
          class TSToken {
              public String nome;
              public String tipo;
              public int valor;
              public int linha;
          }
          
        public static boolean isNumeric(String str) {
            for (char c : str.toCharArray())
            {
                if (!Character.isDigit(c)) return false;
            }
            return true;
        }       
        
        public void adicionarToken(String nome, String tipo, 
             int valor, int linha) {
                                       
            TSToken token = new TSToken();
            token.nome = nome;
            token.tipo = tipo;
            token.valor = valor;
            token.linha = linha;
         
            ts.put(nome, token);                                                                            
        }                                                                                      
                                                                                              
}

programa : expresoes* {
    for (TSToken token : ts.values()) {
        System.out.println("Nome: " + token.nome + 
        " Tipo: " + token.tipo + " Valor: " + token.valor + " Linha: " + token.linha);                                   
    }
                            
};

expresoes : declaracao PV | atribuicao PV;

declaracao : TIPO IDENTIFICADOR OP_ATRIBUICAO expressao {
        System.out.println("Tipo: " + $TIPO.text);   
        System.out.println("Identificador: " + $IDENTIFICADOR.text);
        System.out.println("Valor: " + $expressao.value);
        
  if (ts.get($IDENTIFICADOR.text) != null) {
      System.out.println("Erro! Variável já declarada: " + $start.getLine());                                           
  } else {
      adicionarToken($IDENTIFICADOR.text, $TIPO.text, $expressao.value, $start.getLine());
  }
};

atribuicao : IDENTIFICADOR OP_ATRIBUICAO expressao { 
  TSToken token =  ts.get($IDENTIFICADOR.text);  
  
  if (token == null) {
     System.out.println("Erro! Variável " + $IDENTIFICADOR.text + " não declarada: " + $start.getLine());                                        
  }      
};

expressao returns [int value] : v1 OP_MATEMATICO v2 { $value = $v1.value + $v2.value; }
                      | v1 { $value = $v1.value;  };

v1 returns [int value]  : IDENTIFICADOR {
         TSToken token =  ts.get($IDENTIFICADOR.text); 
         if (token != null) {
                                             
            $value = token.valor; 
          } else {
            System.out.println("Erro! Variável não encontrada");  
            $value = 0;        
          }
        }
      | NUMERO {
          $value = Integer.parseInt( $NUMERO.text, 10 ); 
        };

v2 returns [int value]  : IDENTIFICADOR {
         TSToken token =  ts.get($IDENTIFICADOR.text); 
         if (token != null) {
                                             
            $value = token.valor; 
          } else {
            System.out.println("Erro! Variável não encontrada");      
            $value = 0;        
          }
        }
      | NUMERO {
          $value = Integer.parseInt( $NUMERO.text, 10 ); 
        };

TIPO : 'int' | 'float';
IDENTIFICADOR : [a-z]+;
OP_ATRIBUICAO : '=';
OP_MATEMATICO : '+' | '*' | '-' | '/' | '%';
NUMERO : [0-9]+;
PV : ';';

WS : [ \t\r\n]+ -> skip;

