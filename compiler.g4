grammar compiler;

@header {
    import java.util.HashMap;
    import java.util.ArrayList;
}

@members {
      
      HashMap<String, Simbolo> tabelaSimbolos = new HashMap<String, Simbolo>();
      
      class Simbolo {
           public String nome;
           public String tipo;
           public Object valor;
           public ArrayList<Integer> linhas = new ArrayList<Integer>();                   
      }

}


programa : expresoes* {
   for (Simbolo simbolo : tabelaSimbolos.values()) {
       System.out.println(simbolo.nome + " " + simbolo.tipo 
            + " " + simbolo.valor + " ");
       for (Integer linha : simbolo.linhas) {
           System.out.println(linha);
       }    
            
   }                    
                       
};


expresoes : declaracao PV | atribuicao PV;

declaracao : TIPO IDENTIFICADOR OP_ATRIBUICAO expressao {
     
     if (tabelaSimbolos.get($IDENTIFICADOR.text) != null) {
          System.out.println("Erro! Variável já declarada!");                                                  
     } else {
          Simbolo simbolo = new Simbolo();
          simbolo.nome = $IDENTIFICADOR.text;
          simbolo.tipo = $TIPO.text;
          simbolo.valor = $expressao.valor;
          simbolo.linhas.add($start.getLine());
          
          boolean insereTabela = true;
          if (simbolo.tipo.equals("int")) {
              if (!(simbolo.valor instanceof Integer)) {
                 System.out.println("Valor inválido!");    
                 insereTabela = false;
              }                                    
          } 
          
          if (simbolo.tipo.equals("boolean")) {
              if (!(simbolo.valor instanceof Boolean))  {
                  System.out.println("Valor inválido");
                  insereTabela = false;
              }
          }                                               
          
          if (insereTabela) {
              tabelaSimbolos.put($IDENTIFICADOR.text, simbolo);
              System.out.println("Variavel declarada com sucesso!");
          }   
             
             
     }
};

atribuicao : IDENTIFICADOR OP_ATRIBUICAO expressao {
  Simbolo simbolo = tabelaSimbolos.get($IDENTIFICADOR.text);                                                  
  if (simbolo != null) {
      simbolo.valor = $expressao.valor;   
      simbolo.linhas.add($start.getLine());                   
  } else {
      System.out.println("Variável não encontrada!");
  }
                        
};

expressao returns [Object valor]: v1 OP_MATEMATICO v2 
             { $valor = (Integer) $v1.valor + (Integer) $v2.valor; }
           | v1
             { $valor = $v1.valor; }
           ;

v1 returns [Object valor] : IDENTIFICADOR 
                         { 
                            Simbolo simbolo = tabelaSimbolos.get($IDENTIFICADOR.text);
                            if (simbolo == null) {
                                System.out.println("Variável não encontrada!");
                                $valor = 0;
                            } else {
                                $valor = simbolo.valor;        
                            }                                 
                         }
                       | NUMERO
                         { $valor = Integer.parseInt($NUMERO.text); }
                       | BOOLEAN 
                         { $valor = Boolean.parseBoolean($BOOLEAN.text); }                          
                          ;

v2 returns [Object valor] : IDENTIFICADOR 
                         { 
                            Simbolo simbolo = tabelaSimbolos.get($IDENTIFICADOR.text);
                            if (simbolo == null) {
                                System.out.println("Variável não encontrada!");
                                $valor = 0;
                            } else {
                                $valor = simbolo.valor;        
                            }       
                         }
                       | NUMERO
                         { $valor = Integer.parseInt($NUMERO.text); }
                       | BOOLEAN 
                         { $valor = Boolean.parseBoolean($BOOLEAN.text); }                          
                          ;

TIPO : 'int' | 'float' | 'boolean';
BOOLEAN : 'true' | 'false';
IDENTIFICADOR : [a-z]+;
OP_ATRIBUICAO : '=';
OP_MATEMATICO : '+' | '*' | '-' | '/' | '%';
NUMERO : [0-9]+;
PV : ';';

WS : [ \t\r\n]+ -> skip;

