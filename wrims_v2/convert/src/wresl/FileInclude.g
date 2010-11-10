grammar FileInclude;

options {
  language = Java;
}

@header {
  package wresl;
  import java.util.Map;
  import java.util.HashMap;
  import java.util.Arrays;
  import evaluators.Struct;
  import evaluators.Tools;  
}

@lexer::header {
  package wresl;
}

@members {

	public Struct F = new Struct();	
	//public ArrayList<Model> modelList = new ArrayList<Model>();
	
	/// temp variables 
 	private ArrayList<String> list;

	/// error message
	public String currentFilePath;
	public ArrayList<String> outputErrorMessage = new ArrayList<String>();
	public String getErrorMessage(RecognitionException e, String[] tokenNames) {
    		String msg = super.getErrorMessage(e, tokenNames);
			msg = msg+" in file \""+currentFilePath+"\"";
			if (msg!=null){outputErrorMessage.add(msg);}
			return msg;
			}
}

evaluator 
	:	includes EOF  ;

includes
	:  .* include*   ;

include
	:   INCLUDE filePath .* ; 

filePath
	:	 PATH  ;

MULTILINE_COMMENT : '/*' .* '*/' {$channel = HIDDEN;} ;
COMMENT : '!' .* ('\n'|'\r') {$channel = HIDDEN;};


INCLUDE: 'include' | 'Include' | 'INCLUDE'  ;


fragment LETTER : ('a'..'z' | 'A'..'Z') ;
fragment DIGIT : '0'..'9';
fragment SYMBOLS : '_' | '-' ;
fragment IDENT : (LETTER | DIGIT | SYMBOLS )+ ;

fragment WRESL : '.wresl' | '.WRESL' ;

PATH : '\'' IDENT  ('\\' IDENT )* WRESL  '\'';

WS : (' ' | '\t' | '\n' | '\r' | '\f')+ {$channel = HIDDEN;};

