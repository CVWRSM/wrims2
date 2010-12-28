grammar ParseTable;

options {
  language = Java;
}

@header {
  package Parser;
  import java.util.Map;
  import java.util.HashMap;
  import java.util.Iterator;
  import java.util.Arrays;
  import java.io.File;
  import java.io.FileInputStream;
  import java.io.BufferedInputStream;
    
  import org.antlr.runtime.ANTLRFileStream;
  import org.antlr.runtime.CharStream;
  import org.antlr.runtime.CommonTokenStream;
  import org.antlr.runtime.RecognitionException;
  import org.antlr.runtime.TokenStream;
  
  import Components.Alias;
  import Components.Dvar;
  import Components.Constraint;
  import Components.Svar;
  import Components.LRWeight;
}

@lexer::header {
  package Parser;
}

@members {

  public static ArrayList<String>   error_grammer = new ArrayList<String> ();
  public static Map<String, ArrayList<String>>   cycle = new HashMap<String, ArrayList<String>>();
  public static Map<String, ArrayList<String>>   node = new HashMap<String, ArrayList<String>>();
  public static Map<String, Dvar>   dvar = new HashMap<String, Dvar>();
  public static Map<String, Svar>   svar = new HashMap<String, Svar>();
  public static ArrayList<String>   outputSvar = new ArrayList<String>();
  public static Map<String, String> weight = new HashMap<String, String>();
  public static ArrayList<String>   file = new ArrayList<String>();
  public static Map<String, Constraint>   constraint = new HashMap<String, Constraint>();
  public static Map<String, LRWeight>   lgr = new HashMap<String, LRWeight>();
  public static Map<String, LRWeight>   rgl = new HashMap<String, LRWeight>();
  public static Map<String, String> function = new HashMap<String, String>();
  public static Map<String, Alias>   alias = new HashMap<String, Alias>();

  public static Map<String, ArrayList<String>>   nodeGlobal = new HashMap<String, ArrayList<String>>();
  public static Map<String, Dvar>   dvarGlobal = new HashMap<String, Dvar>();
  public static Map<String, Svar>   svarGlobal = new HashMap<String, Svar>();
  public static ArrayList<String>   outputSvarGlobal = new ArrayList<String>();
  public static Map<String, String> weightGlobal = new HashMap<String, String>();
  public static ArrayList<String>   fileGlobal = new ArrayList<String>();
  public static Map<String, Constraint>   constraintGlobal = new HashMap<String, Constraint>();
  public static Map<String, LRWeight>   lgrGlobal = new HashMap<String, LRWeight>();
  public static Map<String, LRWeight>   rglGlobal = new HashMap<String, LRWeight>();
  public static Map<String, String> functionGlobal = new HashMap<String, String>();
  public static Map<String, Alias>   aliasGlobal = new HashMap<String, Alias>();
  
  private static String currentFile="";
  private static String currentCycle="";
  private static ArrayList<String> fileAnchestry=new ArrayList<String>();
  
  private static boolean testDefine=false;
  private static boolean isSvFile=false;
  private static boolean isConstraintStatement=false;
  private static boolean isSumFunction=false;
  ///private final ArrayList<String> reservedToken=new ArrayList<String>(Arrays.asList("month", "wateryear","jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec")); 
  
  private String svType= "NULL"; 
  private String svUnits = "NULL"; 
  private String preSV ="";
  private String preCondition = "always";
  private int n_always=0;
  private boolean redefineSV=false;
  private String output="n"; 
  
  private String preConstraint="";
  private boolean redefineConstraint=false;
  private boolean constraintOnly=false;
  
  private String preReservoir="";
  private boolean includeReservoir=false;
  private int ilevel=1;
  private String reservoirUnits="taf";
  
  private static CharStream stream;

  public String strip(String s) {
    return s.substring(1, s.length()-1);
    }
  
  public String equalConstraint(String relationStatement){
    String[] expressions = relationStatement.split("[<=>]");
    return expressions[0]+"="+expressions[1]; 
  }
  
  public String smallerConstraint(String relationStatement){
    String[] expressions = relationStatement.split("[<=>]");
    return expressions[0]+"<"+expressions[1]; 
  }
  
  public String largerConstraint(String relationStatement){
    String[] expressions = relationStatement.split("[<=>]");
    return expressions[0]+">"+expressions[1]; 
  }
  
  public String lMinusR(String relationStatement){
    String[] expressions = relationStatement.split("[<=>]");
    return expressions[0]+"-("+expressions[1]+")"; 
  }  
  
  public String rMinusL(String relationStatement){
    String[] expressions = relationStatement.split("[<=>]");
    return expressions[1]+"-("+expressions[0]+")"; 
  }
  
  public void dvTestDefineSV(){
    Iterator iterator=dvar.keySet().iterator();
    while(iterator.hasNext()){ 
      String dvarName=(String)iterator.next();
      Dvar currDvar=dvar.get(dvarName);
      String lowerBound=currDvar.getLowerBound();
      String upperBound=currDvar.getUpperBound();
      try{        
        Integer.parseInt(lowerBound);    
      } catch(NumberFormatException nfe0) {        
        try {
          Float.parseFloat(lowerBound);
        }catch (NumberFormatException nfe1) { 
          try {
            Double.parseDouble(lowerBound);
          }catch (NumberFormatException nfe2) {
            if (!svar.containsKey(lowerBound)){
              error_grammer.add(currDvar.getSourceFileName()+" "+currDvar.getLineNumber()+"@"+currDvar.getPosLowerBound()+": "+lowerBound+" as the lower bound of decision variable "+dvarName+" is not a defined state variable before used");
            }
          }
        }   
      }
      try{        
        Integer.parseInt(upperBound);    
      } catch(NumberFormatException nfe3) {        
        try {
          Float.parseFloat(upperBound);
        }catch (NumberFormatException nfe4) { 
          try {
            Double.parseDouble(upperBound);
          }catch (NumberFormatException nfe5) {
            if (!svar.containsKey(upperBound)){
              error_grammer.add(currDvar.getSourceFileName()+" "+currDvar.getLineNumber()+"@"+currDvar.getPosUpperBound()+": "+upperBound+" as the upper bound of decision variable "+dvarName+" is not a defined state variable before used");
            }
          }
        }   
      }
    }
  }
   
  public void setGlobal(){
        nodeGlobal = node;
        dvarGlobal = dvar;
        svarGlobal = svar;
        outputSvarGlobal = outputSvar;
        weightGlobal = weight;
        fileGlobal = file;
        constraintGlobal = constraint;
        lgrGlobal = lgr;
        rglGlobal = rgl;
        functionGlobal = function;
        aliasGlobal = alias;
  }
  
  public void initialCycle(){
        node = nodeGlobal;
        dvar = dvarGlobal;
        svar = svarGlobal;
        outputSvar = outputSvarGlobal;
        weight = weightGlobal;
        file = fileGlobal;
        constraint = constraintGlobal;
        lgr = lgrGlobal;
        rgl = rglGlobal;
        function=functionGlobal;
        alias = aliasGlobal;        
  }
  
  @Override
  public void reportError(RecognitionException e) {
       error_grammer.add(currentFile+" "+e.line+"@"+e.charPositionInLine+": "+getErrorMessage(e, tokenNames));
  }
}

evaluator //returns [Map<String, String> map1]
	:	modules //{ $map1 = constants; }
	;

modules
	:	cycletable
	| filetable
	|	dvartable
	|	svartable
	|	constrainttable
	|	weighttable
	| externaltable
	| aliastable
	;


cycletable
  : headline_cycletable ('\n'|'\r'|COMMENT*) content_globalline content_cycleline*
  ;

filetable
	:	headline_filetable ('\n'|'\r'|COMMENT*) content_fileline*
	;
		
dvartable
	:	headline_dvartable ('\n'|'\r'|COMMENT*) content_dvarline*
	;

svartable @init {isSvFile=true;}
	:	headline_svartable ('\n'|'\r'|COMMENT*) content_svarline* {
	    isSvFile=false;
      if (!(preCondition.equals("always"))){
          error_grammer.add(currentFile+": "+preSV+" the last case should be always");
      }
	  }
	;
	
constrainttable
	:	headline_constrainttable ('\n'|'\r'|COMMENT*) content_constraintline*{
	    if (!(preCondition.equals("always"))){
          error_grammer.add(currentFile+": "+preConstraint+" the last case should be always");
      }
	}
	;

weighttable
	:	headline_weighttable ('\n'|'\r'|COMMENT*) content_weightline*
	;

externaltable
  : headline_externaltable ('\n'|'\r'|COMMENT*) content_externalline*
  ;
  
aliastable
  : headline_aliastable ('\n'|'\r'|COMMENT*) content_aliasline*
  ;

headline_cycletable
  : CYCLE ',' FILE ',' CONDITION{
    }
  ;

headline_filetable
  : FILE ',' INCLUDE{
    }
  ;
	
headline_dvartable
	:	NAME ',' LOWERBOUND ',' UPPERBOUND ',' INTEGERTYPE ',' UNITS ',' TYPE{
		}
	;
	
headline_svartable
	:	NAME ',' TYPE ',' UNITS ',' OUTPUT ',' CASE ',' ORDER ',' CONDITION ',' EXPRESSION {
		}
	;

headline_constrainttable
	:	NAME ',' CASE ',' ORDER ',' CONDITION ',' EXPRESSION ',' LHSGTRHS ',' LHSLTRHS {
		}
	;
		
headline_weighttable
	:	NAME ',' WEIGHT{
		}
	;
	
headline_externaltable
  : FUNCTION ',' FILE{
    }
  ;
  
headline_aliastable
  : NAME ',' TYPE ',' UNITS ',' EXPRESSION{
    }
  ;

content_globalline
  : content_global (('\n' EOF)|('\r' EOF)|'\n'|'\r'|COMMENT*|EOF)
  ;

content_cycleline
  : content_cycle (('\n' EOF)|('\r' EOF)|'\n'|'\r'|COMMENT*|EOF)
  ;

content_fileline
  : content_file (('\n' EOF)|('\r' EOF)|'\n'|'\r'|COMMENT*|EOF)
  ;

content_dvarline
	:	content_dvar (('\n' EOF)|('\r' EOF)|'\n'|'\r'|COMMENT*|EOF)
	;
	
content_svarline
	:	content_svar (('\n' EOF)|('\r' EOF)|'\n'|'\r'|COMMENT*|EOF)
	;
	
content_constraintline
	:	content_constraint (('\n' EOF)|('\r' EOF)|'\n'|'\r'|COMMENT*|EOF)
	;
	
content_weightline
	:	content_weight (('\n' EOF)|('\r' EOF)|'\n'|'\r'|COMMENT*|EOF)
	;
	
content_externalline
  : content_external (('\n' EOF)|('\r' EOF)|'\n'|'\r'|COMMENT*|EOF)
  ;
  
content_aliasline
  : content_alias (('\n' EOF)|('\r' EOF)|'\n'|'\r'|COMMENT*|EOF)
  ;

content_global
  : i1=IDENT ',' i2=directory ',' i3=conditionStatement{
      if ($i1.text.equals("global")){
        node = new HashMap<String, ArrayList<String>>();
        dvar = new HashMap<String, Dvar>();
        svar = new HashMap<String, Svar>();
        outputSvar = new ArrayList<String>();
        weight = new HashMap<String, String>();
        file = new ArrayList<String>();
        constraint = new HashMap<String, Constraint>();
        lgr = new HashMap<String, LRWeight>();
        rgl = new HashMap<String, LRWeight>();
        function =  new HashMap<String, String>();
        alias = new HashMap<String, Alias>();
      
        if (cycle.containsKey($i1.text)){
          error_grammer.add("main file: cycle"+" "+$i1.line+"@"+($i1.pos+1)+": "+ $i1.text+" redefined");
        }else{
          ArrayList<String> list = new ArrayList<String>();
          list.add($i3.text);
          list.add($i2.text);
          cycle.put($i1.text, list);
        
          byte[] buffer = new byte[(int) new File($i2.text).length()];
          BufferedInputStream f = null;
          try {
              f = new BufferedInputStream(new FileInputStream($i2.text));
              f.read(buffer);
              f.close();
          } catch (Exception e) { 
              e.printStackTrace();
          }
             
          String fileString=new String(buffer);
          fileString=fileString.toLowerCase();
             
          try {
            stream=new ANTLRStringStream(fileString);
          }
          catch(Exception e) {
            e.printStackTrace();
          }
          
          fileAnchestry.add("main file");   
          currentFile=$i2.text;
          ParseTableLexer lexer = new ParseTableLexer(stream);
          TokenStream tokenStream = new CommonTokenStream(lexer);
          ParseTableParser parser = new ParseTableParser(tokenStream);
          parser.evaluator();
          currentFile=fileAnchestry.get(fileAnchestry.size()-1);
          fileAnchestry.remove(fileAnchestry.size()-1);
          
          setGlobal();
        }           
      }else{
        error_grammer.add("main file "+$i1.line+"@"+($i1.pos+1)+ ": cycle name "+$i1.text+" is wrong. The first line cycle name should be global");
      }      
  }
  ;

content_cycle
  : i1=IDENT ',' i2=directory ',' i3=conditionStatement{
      node = new HashMap<String, ArrayList<String>>();
      dvar = new HashMap<String, Dvar>();
      svar = new HashMap<String, Svar>();
      outputSvar = new ArrayList<String>();
      weight = new HashMap<String, String>();
      file = new ArrayList<String>();
      constraint = new HashMap<String, Constraint>();
      lgr = new HashMap<String, LRWeight>();
      rgl = new HashMap<String, LRWeight>();
      function = new HashMap<String, String>();
      alias = new HashMap<String, Alias>();
      
      initialCycle();
      
      if (cycle.containsKey($i1.text)){
        error_grammer.add("main file "+$i1.line+"@"+($i1.pos+1)+": cycle"+ $i1.text+" redefined");
      }else{
        ArrayList<String> list = new ArrayList<String>();
        list.add($i3.text);
        list.add($i2.text);
        cycle.put($i1.text, list);
        currentCycle=$i1.text;
        
        byte[] buffer = new byte[(int) new File($i2.text).length()];
        BufferedInputStream f = null;
        try {
            f = new BufferedInputStream(new FileInputStream($i2.text));
            f.read(buffer);
            f.close();
        } catch (Exception e) { 
            e.printStackTrace();
        }
             
        String fileString=new String(buffer);
        fileString=fileString.toLowerCase();
             
        try {
           stream=new ANTLRStringStream(fileString);
        }
        catch(Exception e) {
           e.printStackTrace();
        }
        
        fileAnchestry.add("main file");
        currentFile=$i2.text;     
        ParseTableLexer lexer = new ParseTableLexer(stream);
        TokenStream tokenStream = new CommonTokenStream(lexer);
        ParseTableParser parser = new ParseTableParser(tokenStream);
        parser.evaluator();
        currentFile=fileAnchestry.get(fileAnchestry.size()-1);
        fileAnchestry.remove(fileAnchestry.size()-1);
        
        dvTestDefineSV();
      }   
  }
  ;

content_file
  : i1=directory ',' i2=IDENT {
       if ($i2.text.equals("y")){
           if (file.contains($i1.text)) {
               error_grammer.add(currentFile+" "+$i2.line+"@"+"0"+": "+ $i1.text+" redefined");
           }else{
             file.add($i1.text); 
             byte[] buffer = new byte[(int) new File($i1.text).length()];
             BufferedInputStream f = null;
             try {
                f = new BufferedInputStream(new FileInputStream($i1.text));
                f.read(buffer);
                f.close();
             } catch (Exception e) { 
                e.printStackTrace();
             }
             
             String fileString=new String(buffer);
             fileString=fileString.toLowerCase();
             
             try {
                stream=new ANTLRStringStream(fileString);
             }
             catch(Exception e) {
                e.printStackTrace();
             }
             
             fileAnchestry.add(currentFile);
             currentFile=$i1.text;
             ParseTableLexer lexer = new ParseTableLexer(stream);
             TokenStream tokenStream = new CommonTokenStream(lexer);
             ParseTableParser parser = new ParseTableParser(tokenStream);
             parser.evaluator();
             currentFile=fileAnchestry.get(fileAnchestry.size()-1);
             fileAnchestry.remove(fileAnchestry.size()-1);
           }           
       }else if (!($i2.text.equals("n"))){
           error_grammer.add(currentFile+" "+$i2.line+"@"+($i2.pos+1)+": "+$i1.text+" include field should be y or n");
       }
    }
  ;
	
content_dvar
	:	i1=IDENT s1=',' lowerbound s2=',' upperbound ',' i3=IDENT ',' i4=IDENT ',' partC{
	       if (dvar.containsKey($i1.text) || svar.containsKey($i1.text) || alias.containsKey($i1.text)){
            error_grammer.add(currentFile+" "+$i1.line+"@"+($i1.pos+1)+": "+ $i1.text+" redefined");
         }else{
            Dvar currDvar=new Dvar();
            if ($lowerbound.text.equals("ul")){
              currDvar.setLowerBound("-1.e38");
            }else{
              currDvar.setLowerBound($lowerbound.text);
            }
            
            if ($upperbound.text.equals("ul")){
              currDvar.setUpperBound("1.e38");
            }else{
              currDvar.setUpperBound($upperbound.text);
            }
            
            if ($i3.text.equals("y")){
              currDvar.setIntegerType(true);
            }else if ($i3.text.equals("n")){
              currDvar.setIntegerType(false);
            }else{
              error_grammer.add(currentFile+" "+$i3.line+"@"+($i3.pos+1)+": "+$i1.text+" integer field should be y or n");
            }
            
            currDvar.setUnits($i4.text);
            currDvar.setType($partC.text);
            currDvar.setSourceFileName(currentFile);
            currDvar.setLineNumber($s1.line);
            currDvar.setPosLowerBound($s1.pos+2);
            currDvar.setPosUpperBound($s2.pos+2);
            dvar.put($i1.text,currDvar);
         }
	}
	;
	
content_svar
	:	i1=IDENT  s1=',' i2=partC ',' i3=IDENT ',' i4=IDENT ',' IDENT ',' INTEGER s2=',' i5=conditionStatement ',' i6=tableExpression{
     				if ($i1.text.equals(preSV)){
			        	if (!$i2.text.equals(svType)){
			        	  error_grammer.add(currentFile+" "+$s1.line+"@"+($s1.pos+2)+": "+$i1.text+" type field should be the same");
			        	}
			        	if (!$i3.text.equals(svUnits)){
                  error_grammer.add(currentFile+" "+$i3.line+"@"+($i3.pos+1)+": "+$i1.text+" units field should be the same");
                }
                if (!$i4.text.equals(output)){
                  error_grammer.add(currentFile+" "+$i4.line+"@"+($i4.pos+1)+": "+$i1.text+" output field should be the same");
                }
			        	if (!redefineSV){
			        	   if ($i5.text.equals("always")){
            				  n_always=n_always+1;
			        		    if (n_always>1){
		              				error_grammer.add(currentFile+" "+$s2.line+"@"+($s2.pos+2)+": "+$i1.text+" has more than 1 always condition");
            				  }
          			   }
                   
                   Svar currSvar=svar.get($i1.text);
                   currSvar.getCaseCondition().add($i5.text);
                   ArrayList<String> list=new ArrayList<String>();
                   list.addAll($i6.list);
                   currSvar.getCaseExpression().add(list);
          			}
        		}else{
        			  svType=$i2.text;
                svUnits=$i3.text;
          			if (svar.containsKey($i1.text) || dvar.containsKey($i1.text) || alias.containsKey($i1.text)){
                    error_grammer.add(currentFile+" "+$i1.line+"@"+($i1.pos+1)+": "+ $i1.text+" redefined");
                    redefineSV=true;
                }else{
                    redefineSV=false;
          				  n_always=0;
          				  if ($i4.text.equals("y")){
            					output=$i4.text;
            					outputSvar.add($i1.text);
            				}else if ($i4.text.equals("n")){
            				  output=$i4.text;
          				  }else{
            					error_grammer.add(currentFile+" "+$i4.line+"@"+($i4.pos+1)+": "+$i1.text+" output field should be y or n");
            					output="n";
          				  }
          				
          				  if (!(preCondition.equals("always"))){
            					error_grammer.add(currentFile+" "+$s2.line+"@"+($s2.pos+2)+": "+preSV+" the last case should be always");
          				  }
          				  
          				  if ($i5.text.equals("always")){
            					n_always=n_always+1;
          				  }
            				
            				Svar currSvar=new Svar();
            				currSvar.setType(svType);
                    currSvar.setUnits(svUnits);
                    currSvar.getCaseCondition().add($i5.text);

            				ArrayList<String> list=new ArrayList<String>();
            				list.addAll($i6.list);
            				currSvar.getCaseExpression().add(list);
            				svar.put($i1.text, currSvar);
          			}
          	}
     			  preCondition=$i5.text;
     			  preSV=$i1.text;
		   }
	;
	
content_constraint
	:	i1=IDENT ',' i3=IDENT ',' INTEGER s1=',' i5=conditionStatement s2=',' i6=constraintStatement s3=',' ((i7=lhsrhs)|'#') s4=',' ((i8=lhsrhs)|'#'){
            ArrayList<String> list;
            if ($i1.text.equals(preConstraint)){
                if (!redefineConstraint){
                   if ($i5.text.equals("always")){
                      n_always=n_always+1;
                      if (n_always>1){
                          error_grammer.add(currentFile+" "+$s1.line+"@"+($s1.pos+2)+": "+$i1.text+" has more than 1 always condition");
                      }
                   }
                   if (constraintOnly){
                        Constraint currConstraint = constraint.get($i1.text);
                        currConstraint.getCaseCondition().add($i5.text);
                        currConstraint.getCaseExpression().add($i6.text);
                        if (!(($i7.text==null) && ($i8.text==null))){
                          error_grammer.add(currentFile+" "+$s3.line+"@"+($s3.pos+2)+": "+$i1.text+" lhs_gt_rhs and rhs_gt_lhs fields can only be both # or neither");
                        }
                   }else{
                        if ($i7.text.equals("constrain") && $i8.text.equals("constrain")){
                          Constraint currConstraint = constraint.get($i1.text);
                          currConstraint.getCaseCondition().add($i5.text);
                          currConstraint.getCaseExpression().add(equalConstraint($i6.text));
                          
                          LRWeight currLgr = lgr.get($i1.text);
                          currLgr.getCaseCondition().add($i5.text);
                          currLgr.getCaseExpression().add("0");
                          currLgr.getCaseWeight().add("0");
                          
                          LRWeight currRgl = rgl.get($i1.text);
                          currRgl.getCaseCondition().add($i5.text);
                          currRgl.getCaseExpression().add("0");
                          currRgl.getCaseWeight().add("0");
                        }else if ($i7.text.equals("constrain") && !($i8.text.equals("constrain"))){
                          Constraint currConstraint = constraint.get($i1.text);
                          currConstraint.getCaseCondition().add($i5.text);
                          currConstraint.getCaseExpression().add(smallerConstraint($i6.text));
                          
                          LRWeight currLgr = lgr.get($i1.text);
                          currLgr.getCaseCondition().add($i5.text);
                          currLgr.getCaseExpression().add("0");
                          currLgr.getCaseWeight().add("0");
                          
                          LRWeight currRgl = rgl.get($i1.text);
                          currRgl.getCaseCondition().add($i5.text);
                          currRgl.getCaseExpression().add(rMinusL($i6.text));
                          currRgl.getCaseWeight().add($i8.text);                    
                        } else if (!($i7.text.equals("constrain")) && $i8.text.equals("constrain")){                         
                          Constraint currConstraint = constraint.get($i1.text);
                          currConstraint.getCaseCondition().add($i5.text);
                          currConstraint.getCaseExpression().add(largerConstraint($i6.text));
                                                   
                          LRWeight currLgr = lgr.get($i1.text);
                          currLgr.getCaseCondition().add($i5.text);
                          currLgr.getCaseExpression().add(lMinusR($i6.text));
                          currLgr.getCaseWeight().add($i7.text);
                          
                          LRWeight currRgl = rgl.get($i1.text);
                          currRgl.getCaseCondition().add($i5.text);
                          currRgl.getCaseExpression().add("0");
                          currRgl.getCaseWeight().add("0");                      
                        } else{                         
                          Constraint currConstraint = constraint.get($i1.text);
                          currConstraint.getCaseCondition().add($i5.text);
                          currConstraint.getCaseExpression().add("0=0");
                          
                          LRWeight currLgr = lgr.get($i1.text);
                          currLgr.getCaseCondition().add($i5.text);
                          currLgr.getCaseExpression().add(lMinusR($i6.text));
                          currLgr.getCaseWeight().add($i7.text);
                          
                          LRWeight currRgl = rgl.get($i1.text);
                          currRgl.getCaseCondition().add($i5.text);
                          currRgl.getCaseExpression().add(rMinusL($i6.text));
                          currRgl.getCaseWeight().add($i8.text);
                        }                       
                   }
                }
            }else{
                if (constraint.containsKey($i1.text)){
                    error_grammer.add(currentFile+" "+$i1.line+"@"+($i1.pos+1)+": "+ $i1.text+" redefined");
                    redefineConstraint=true;
                }else{
                    redefineConstraint=false;
                    constraintOnly=false;
                    n_always=0;
                  
                    if (!(preCondition.equals("always"))){
                      error_grammer.add(currentFile+" "+$s1.line+"@"+($s1.pos+2)+": "+preConstraint+" the last case should be always");
                    }

                    if ($i5.text.equals("always")){
                      n_always=n_always+1;
                    }

                    if (($i7.text==null) || ($i8.text==null)){
                        constraintOnly=true;
                        Constraint currConstraint = new Constraint();
                        currConstraint.getCaseCondition().add($i5.text);
                        currConstraint.getCaseExpression().add($i6.text);
                        constraint.put($i1.text, currConstraint);
                        if (!(($i7.text==null) && ($i8.text==null))){                          
                          error_grammer.add(currentFile+" "+$s3.line+"@"+($s3.pos+2)+": "+$i1.text+" lhs_gt_rhs and rhs_lt_lhs fields can only be both # or neither");
                        }
                    }else{
                        if ($i7.text.equals("constrain") && $i8.text.equals("constrain")){                        
                          Constraint currConstraint = new Constraint();
                          currConstraint.getCaseCondition().add($i5.text);
                          currConstraint.getCaseExpression().add(equalConstraint($i6.text));
                          constraint.put($i1.text, currConstraint);
                          
                          LRWeight currLgr = new LRWeight();
                          currLgr.getCaseCondition().add($i5.text);
                          currLgr.getCaseExpression().add("0");
                          currLgr.getCaseWeight().add("0");
                          lgr.put($i1.text, currLgr);
                          
                          LRWeight currRgl = new LRWeight();
                          currRgl.getCaseCondition().add($i5.text);
                          currRgl.getCaseExpression().add("0");
                          currRgl.getCaseWeight().add("0");
                          rgl.put($i1.text, currRgl); 
                        }else if ($i7.text.equals("constrain") && !($i8.text.equals("constrain"))){                         
                          Constraint currConstraint = new Constraint();
                          currConstraint.getCaseCondition().add($i5.text);
                          currConstraint.getCaseExpression().add(smallerConstraint($i6.text));
                          constraint.put($i1.text, currConstraint);
                          
                          LRWeight currLgr = new LRWeight();
                          currLgr.getCaseCondition().add($i5.text);
                          currLgr.getCaseExpression().add("0");
                          currLgr.getCaseWeight().add("0");
                          lgr.put($i1.text, currLgr);
                                                    
                          LRWeight currRgl = new LRWeight();
                          currRgl.getCaseCondition().add($i5.text);
                          currRgl.getCaseExpression().add(rMinusL($i6.text));
                          currRgl.getCaseWeight().add($i8.text);
                          rgl.put($i1.text, currRgl);                        
                        } else if (!($i7.text.equals("constrain")) && $i8.text.equals("constrain")){                         
                          Constraint currConstraint = new Constraint();
                          currConstraint.getCaseCondition().add($i5.text);
                          currConstraint.getCaseExpression().add(largerConstraint($i6.text));
                          constraint.put($i1.text, currConstraint);
                          
                          LRWeight currLgr = new LRWeight();
                          currLgr.getCaseCondition().add($i5.text);
                          currLgr.getCaseExpression().add(lMinusR($i6.text));
                          currLgr.getCaseWeight().add($i7.text);
                          lgr.put($i1.text, currLgr);
                          
                          LRWeight currRgl = new LRWeight();
                          currRgl.getCaseCondition().add($i5.text);
                          currRgl.getCaseExpression().add("0");
                          currRgl.getCaseWeight().add("0");
                          rgl.put($i1.text, currRgl);                      
                        } else{
                          Constraint currConstraint = new Constraint();
                          currConstraint.getCaseCondition().add($i5.text);
                          currConstraint.getCaseExpression().add("0=0");
                          constraint.put($i1.text, currConstraint);                          
                          
                          LRWeight currLgr = new LRWeight();
                          currLgr.getCaseCondition().add($i5.text);
                          currLgr.getCaseExpression().add(lMinusR($i6.text));
                          currLgr.getCaseWeight().add($i7.text);
                          lgr.put($i1.text, currLgr);
                          
                          LRWeight currRgl = new LRWeight();
                          currRgl.getCaseCondition().add($i5.text);
                          currRgl.getCaseExpression().add(rMinusL($i6.text));
                          currRgl.getCaseWeight().add($i8.text);
                          rgl.put($i1.text, currRgl);
                        }                       
                    }
                }
            }
            preCondition=$i5.text;
            preConstraint=$i1.text;	       
	} 
	;
	
content_weight 
	:	IDENT ',' weight{
	   if (dvar.containsKey($IDENT.text)){  
	     if (weight.containsKey($IDENT.text)){
          error_grammer.add(currentFile+" "+$IDENT.line+"@"+($IDENT.pos+1)+": "+ $IDENT.text+" redefined");
       }else{
          weight.put($IDENT.text, $weight.text);
       }
     }else{
       error_grammer.add(currentFile+" "+$IDENT.line+"@"+($IDENT.pos+1)+": "+$IDENT.text+" is not defined before used");
     }
	} 
	;
	
content_external
  : IDENT ',' externalFile{  
     if (function.containsKey($IDENT.text)){
        error_grammer.add(currentFile+" "+$IDENT.line+"@"+($IDENT.pos+1)+": "+ $IDENT.text+" redefined");
     }else{
        function.put($IDENT.text, $externalFile.text);
     }
  } 
  ;
	
content_alias @init{testDefine=true;}
  : i1=IDENT ',' partC ',' i2=IDENT ',' expression{
      if (dvar.containsKey($i1.text) || svar.containsKey($i1.text) || alias.containsKey($i1.text)){
        error_grammer.add(currentFile+" "+$i1.line+"@"+($i1.pos+1)+": "+ $i1.text+" redefined");
      }
      Alias currAlias=new Alias();
      currAlias.setType($partC.text);
      currAlias.setUnits($i2.text);
      currAlias.setExpression($expression.list.get(1));
      alias.put($i1.text, currAlias);
      testDefine=false;
  } 
  ;

///////////////////
/// basic rules ///
///////////////////
lhsrhs: weight|CONSTRAIN;

weight	:	allnumber|(allnumber '*taf_cfs');

directory
	:	(';'|'.'|'|'|'_'|'-'|'+'|'/'|BACKSLASH|IDENT|INTEGER|usedKeywords)+{
	}
	;
	
externalFile
  : (';'|'.'|'|'|'_'|'-'|'+'|IDENT|usedKeywords|INTEGER)+
  ;
	
text	:	LETTER (LETTER | DIGIT )*;
	
tableExpression returns [ArrayList<String> list]
  @init { $list = new ArrayList<String>(); testDefine=true;}
	:	((i1=expression)|(i1=tableSQL)|(i1=timeseriesWithUnits)|(i1=timeseries)|(i1=function)|(i1=sumExpression)){
	   list =$i1.list;
	   testDefine=false;
	}
	;

max_func returns [String text]
	: MAX '('{text="max(";} (e1=expression){text=text+$e1.list.get(1);} (';' (e2=expression){text=text+";"+$e2.list.get(1);})+ ')' {text=text+")";}
	;

min_func returns [String text]
	: MIN '(' {text="min(";} (e1=expression){text=text+$e1.list.get(1);} (';' (e2=expression){text=text+";"+$e2.list.get(1);})+ ')' {text=text+")";}
	;

timeseriesWithUnits returns[ArrayList<String> list]
	: 'timeseries' 'kind' '=' i1=partC 'units' '=' i2=IDENT{
				list = new ArrayList<String>();
				list.add("TIMESERIESWITHUNITS");
				list.add($i1.text);	
				list.add($i2.text);
		}
	;

timeseries returns[ArrayList<String> list]
	: 'timeseries' {
				list = new ArrayList<String>();
				list.add("TIMESERIES");	
		}
	;
	
function returns [ArrayList<String> list]
  : ((i1=noArgFunction)|(i2=argFunction)){
      list=new ArrayList<String>();
      if ($i1.list!=null){
        list=$i1.list;
      }else{
        list=$i2.list;
      }
  }
  ;

noArgFunction returns [ArrayList<String> list]
  : IDENT '(' ')'{
      if (!function.containsKey($IDENT.text)){
        error_grammer.add(currentFile+" "+$IDENT.line+"@"+($IDENT.pos+1)+": function "+$IDENT.text+" is not defined before used");
      }
      list=new ArrayList<String>();
      list.add("FUNCTION");
      list.add($IDENT.text+"()"); 
  }
  ;  

argFunction returns [ArrayList<String> list] 
  : IDENT arguements {
      if (!function.containsKey($IDENT.text)){
        error_grammer.add(currentFile+" "+$IDENT.line+"@"+($IDENT.pos+1)+": function "+$IDENT.text+" is not defined before used");
      }
      list=new ArrayList<String>();
      list.add("FUNCTION");
      list.add($IDENT.text+$arguements.text);
  }
  ;  
  
arguements returns [String text] @init{text="";}:
  '('{text="(";} ((i1=IDENT){text=text+"{"+$i1.text+"}"; }|(k1=knownDV){text=text+$k1.text;}) (';' ((i2=IDENT){text=text+";"+"{"+$i2.text+"}";}|(k2=knownDV){text=text+";"+"{"+$k2.text+"}";}))* ')' 
  ;
	
partC: 	(IDENT|IDENT1|usedKeywords) ('-' (IDENT|IDENT1|usedKeywords))*;
  
usedKeywords: I|YEAR|MONTH|PASTMONTH|TAFCFS|SUM|MAX|MIN|WHERE|CONSTRAIN|ALWAYS|NAME|CYCLE|FILE|CONDITION
|INCLUDE|LOWERBOUND|UPPERBOUND|INTEGERTYPE|UNITS|TYPE|OUTPUT
|CASE|ORDER|EXPRESSION|LHSGTRHS|LHSLTRHS|WEIGHT|FUNCTION;

tableSQL returns[ArrayList<String> list]
	: 'select' ((i1=IDENT)|(u1=usedKeywords)) 'from' i2=IDENT 
	  ('given' i3=assignStatement)? ('use' i4=IDENT)? 
	  (where_items)?	  
	  {       
				list = new ArrayList<String>();
				list.add("TABLE");
				if ($i1.text ==null){
				  list.add($u1.text);
				}else{
				  list.add($i1.text);
				}
				list.add($i2.text);
				if ($i3.text !=null){
				  list.add($i3.text);
				}else{
				  list.add("");
				}
				if ($i4.text !=null){
				  list.add($i4.text);
				}else{
				  list.add("");
				}				
				if ($where_items.list !=null){
				  list.addAll($where_items.list);
				}
		}
	;

where_items returns[ArrayList<String> list]
	@init { $list = new ArrayList<String>(); }

	:	 WHERE  (r1=whereStatement{list.add($r1.text);} )
	        (';' r=whereStatement {
	           if ($r.text !=null) {list.add($r.text);}}  )*
	;


upperbound:	IDENT|allnumber;

lowerbound:	IDENT|allnumber;

sumExpression returns [ArrayList<String> list] @init{isSumFunction=true;}
  : SUM '(' I '=' e1=expression_sum ';' e2=expression_sum (';' INTEGER )? ')' e3=expression{
      String text;
      if ($INTEGER.text ==null){
        text="sum(i="+$e1.text+";"+$e2.text+") "+$e3.list.get(1);
      }else{
        text="sum(i="+$e1.text+";"+$e2.text+";"+$INTEGER.text+") "+$e3.list.get(1);
      }
      list=new ArrayList<String>();
      list.add("SUM");
      list.add(text);
      isSumFunction=false;
  } 
  ;

term_sum: (MONTH|pastMonth|INTEGER|'(' expression_sum ')');

unary_sum : ('-')? term_sum ;
add_sum  :  unary_sum(('+' | '-') unary_sum)* ;
expression_sum returns [String text]: add_sum {
  text=$add_sum.text.replace(" ", "");
  text=text.replace("\\t","");
};

term returns [String text]
	:	(knownDV
	| (i1=IDENT) 
	|	'(' (e=expression) ')' 
	|	(i=INTEGER) 
	| (f=FLOAT) 
	| max_func
	| min_func
	| TAFCFS
	| YEAR
	| MONTH)
	{
    if ($i1 !=null){
      if (testDefine && !isSvFile && !dvar.containsKey($i1.text) && !svar.containsKey($i1.text) && !alias.containsKey($i1.text)){
        error_grammer.add(currentFile+" "+$i1.line+"@"+($i1.pos+1)+": "+$i1.text+" is not defined before used");
      }
      if (!isConstraintStatement && dvar.containsKey($i1.text)){
        error_grammer.add(currentFile+" "+$i1.line+"@"+($i1.pos+1)+": decision variable "+$i1.text+" in current month and current cycle can only be used in constraint relationship or defining weight");
      }
      if (!isConstraintStatement && alias.containsKey($i1.text)){
        error_grammer.add(currentFile+" "+$i1.line+"@"+($i1.pos+1)+": alias variable "+$i1.text+" in current month and current cycle can only be used in constraint relationship");
      }
      if (svar.containsKey($i1.text)||alias.containsKey($i1.text)||isSvFile){
        text="{"+$i1.text+"}";
      }else{
        text=$i1.text;
      }
    }
    if ($knownDV.text !=null){
      text=$knownDV.text;
    }
    if ($e.list !=null){
      text="("+$e.list.get(1)+")";
    }
    if ($i.text !=null){
      text=$i.text;
    }
    if ($f.text !=null){
      text=$f.text;
    }
    if ($max_func.text !=null){
      text=$max_func.text;
    }
    if ($min_func.text !=null){
      text=$min_func.text;
    }
    if ($TAFCFS.text !=null){
      text="{"+$TAFCFS.text+"}";
    }
    if ($YEAR.text !=null){
      text="{"+$YEAR.text+"}";
    }
    if ($MONTH.text !=null){
      text="{"+$MONTH.text+"}";
    }
	}
	;
	
knownDV returns [String text] 
  : pastMonthDV{text=$pastMonthDV.text;}|preMonthDV{text=$preMonthDV.text;}|pastCycleDV{text=$pastCycleDV.text;}
  ;
  
pastMonth returns [int line, int pos]:  (PASTMONTH{$line=$PASTMONTH.line; $pos=$PASTMONTH.line;}|I{$line=$I.line; $pos=$I.line;});
  
pastMonthDV returns [String text] 
  : ((i1=IDENT)|TAFCFS) '(' pastMonth ')'{
    if (!isSumFunction && $pastMonth.text.equals("i")){
      error_grammer.add(currentFile+" "+$pastMonth.line+"@"+($pastMonth.pos+1)+": i acts as a past month index of a decision variable can only be used in sum function");
    }
    if ($i1.text ==null){
      text="{"+$TAFCFS.text+"}"+"("+$pastMonth.text+")";
    }else{
      if (testDefine && !dvar.containsKey($i1.text) && !alias.containsKey($i1.text)){
        error_grammer.add(currentFile+" "+$i1.line+"@"+($i1.pos+1)+": decision variable "+$i1.text+" is not defined before used");
      }
      text="{"+$i1.text+"}"+"("+$pastMonth.text+")";
    }
  }
  ;
  
preMonthDV returns [String text]
  : IDENT '(-' INTEGER ')'  {
    if (testDefine && !dvar.containsKey($IDENT.text)&& !alias.containsKey($IDENT.text)){
      error_grammer.add(currentFile+" "+$IDENT.line+"@"+($IDENT.pos+1)+": decision variable "+$IDENT.text+" is not defined before used");
    }
    text="{"+$IDENT.text+"}"+"(-"+$INTEGER.text+")";
  }
  ;
  
pastCycleDV returns [String text]
  : i1=IDENT '[' i2=IDENT ']'{
    if (testDefine){
      if (!dvar.containsKey($i1.text) && !alias.containsKey($i1.text)){
        error_grammer.add(currentFile+" "+$i1.line+"@"+($i1.pos+1)+": decision variable"+$i1.text+" is not defined before used");
      }  
      if (!cycle.containsKey($i2.text)){
        error_grammer.add(currentFile+" "+$i2.line+"@"+($i2.pos+1)+": cycle name "+$i2.text+" is not defined before used");
      }else{
        if (currentCycle.equals($i2.text)){
          error_grammer.add(currentFile+" "+$i2.line+"@"+($i2.pos+1)+": cycle name "+$i2.text+" should be previous cycle");
        }
      }
    } 
    text="{"+$i1.text+"}"+"["+$i2.text+"]";
  }
  ; 
	
unary returns [String text]
	:	(i1='-')? term{
	   if ($i1==null){
	     text=$term.text;
	   }else{
	     text="-"+$term.text;
	   }
	};
	
allnumber
	:	('-')? number;

mult returns [String text] @init{text=""; String w="";}
	:	(i1=unary) {text=$i1.text;} (('*'{w="*";} | '/' {w="/";}| 'mod'{w="mod";}) (i2=unary){text=text+w+$i2.text;})*
	;
	
add returns [String text] @init{text=""; String w="";}
	:	(i1=mult) {text=$i1.text;} (('+'{w="+";} | '-' {w="-";}) (i2=mult){text=text+w+$i2.text;})*
	;

expression returns [ArrayList<String> list]
	:	i=add {
	         list=new ArrayList<String>();
	         list.add("EXPRESSION");
	         list.add($i.text); 
	  }
	;

relation
	: '=='
	| '<'
	| '>'
	| '>='
	| '<='
	;	

conditionStatement returns [String text]
	:	((i1=relationStatementSeries)|ALWAYS){
	     if ($i1.text!=null){
	       $text=$i1.text;
	     }else{
	       $text="always";
	     }
	}
	;

whereStatement returns [String text]
  : ((i=IDENT)|(u=usedKeywords)) '=' expression{
      if ($i.text==null){
        text=$u.text+"="+$expression.list.get(1);
      }else{
        text=$i.text+"="+$expression.list.get(1);
      }
  }
  ;
	
relationStatementSeries returns [String text] @init { text=""; String w="";}
  : (r1=relationStatement){text=$r1.text;} (('.and.'{w=" .and. ";}|'.or.' {w=" .or. ";}) (r2=relationStatement){text=text+w+$r2.text;})* ;

relationStatement returns [String text] @init { testDefine=true;}
	:	(e1=expression) relation (e2=expression){
	 testDefine=false;
	 text=$e1.list.get(1)+$relation.text+$e2.list.get(1);
	}
	;

constraintStatement returns [String text] @init { testDefine=true; isConstraintStatement=true; text=""; String w="";}
  : (e1=expression) ('='{w="=";}|'>'{w=">";}|'<'{w="<";}) (e2=expression){
   testDefine=false;
   isConstraintStatement=false;
   text=$e1.list.get(1)+w+$e2.list.get(1);
  }
  ;

assignStatement returns [String text] @init { testDefine=true;}
  : IDENT '=' expression{
   testDefine=false;
   text=$IDENT.text+"="+$expression.list.get(1);
  }
  ;

number
	: INTEGER
	| FLOAT
	;

MULTILINE_COMMENT : '/*' .* '*/' {$channel = HIDDEN;} ;

fragment LETTER : ('a'..'z' | 'A'..'Z') ;
fragment DIGIT : '0'..'9';
fragment SYMBOLS : '_';	

BACKSLASH : '\\';	 	 

INTEGER : DIGIT+ ;
FLOAT : INTEGER? '.' INTEGER 
	  | INTEGER '.' 
	  ;

I: 'i';
YEAR: 'wateryear';
MONTH: 'month'|'jan'|'feb'|'mar'|'apr'|'may'|'jun'|'jul'|'aug'|'sep'|'oct'|'nov'|'dec';
PASTMONTH: 'prejan'|'prefeb'|'premar'|'preapr'|'premay'|'prejun'|'prejul'|'preaug'|'presep'|'preoct'|'prenov'|'predec';


TAFCFS: 'taf_cfs'|'cfs_taf';

SUM: 'sum';
MAX : 'max';
MIN : 'min';
WHERE : 'where';

CONSTRAIN: 'constrain';
ALWAYS: 'always';

NAME: 'name';
CYCLE: 'cycle';
FILE: 'file';
CONDITION: 'condition';
INCLUDE: 'include';
LOWERBOUND: 'lowerbound';
UPPERBOUND: 'upperbound';
INTEGERTYPE: 'integer';
UNITS: 'units';
TYPE: 'type';
OUTPUT: 'output';
CASE: 'case';
ORDER: 'order';
EXPRESSION: 'expression';
LHSGTRHS: 'lhs_gt_rhs';
LHSLTRHS: 'lhs_lt_rhs';
WEIGHT: 'weight';
FUNCTION: 'function';

IDENT : LETTER (LETTER | DIGIT | SYMBOLS )*;
IDENT1 : DIGIT (LETTER | DIGIT | SYMBOLS )*; 

WS : (' ' | '\t' | '\n' | '\r' | '\f')+ {$channel = HIDDEN;};
COMMENT : '!' .* ('\n'|'\r') {$channel = HIDDEN;};


	
