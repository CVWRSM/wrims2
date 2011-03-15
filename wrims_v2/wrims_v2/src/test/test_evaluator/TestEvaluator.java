
package test.test_evaluator;

import java.io.File;
import java.io.IOException;

import org.antlr.runtime.ANTLRStringStream;
import org.antlr.runtime.CommonTokenStream;
import org.antlr.runtime.RecognitionException;
import org.antlr.runtime.TokenStream;
import org.testng.annotations.Test;

import wrimsv2.evaluator.EvalConstraint;
import wrimsv2.evaluator.EvalExpression;
import wrimsv2.evaluator.EvaluatorLexer;
import wrimsv2.evaluator.EvaluatorParser;
import wrimsv2.external.LoadDll;
import wrimsv2.components.Error;
import wrimsv2.components.MainFile;

public class TestEvaluator {
	
	
	public String inputFilePath;
	public String logFilePath;
	
	public void testRelationStatement() throws RecognitionException, IOException {
		ANTLRStringStream stream = new ANTLRStringStream("g: (2+a)*3.4-(5+6*7.0)*b<(2+b)*6");
		EvaluatorLexer lexer = new EvaluatorLexer(stream);
		TokenStream tokenStream = new CommonTokenStream(lexer);
		EvaluatorParser evaluator = new EvaluatorParser(tokenStream);
		evaluator.evaluator();
		EvalConstraint ec=evaluator.evalConstraint;
		EvalExpression ee=ec.getEvalExpression();
		System.out.println(ec.getSign());
		System.out.println(ee.getValue().getData());
		System.out.println(ee.getMultiplier().get("a").getData());
		System.out.println(ee.getMultiplier().get("b").getData());
	}
	
	@Test
	public void testInternalFunctions() throws RecognitionException, IOException {
		ANTLRStringStream stream = new ANTLRStringStream("g: max(4;-3)*a+min(3.1;100.2)*b+pow(3;abs(-2))*c+int(5.43)*d+log(2)*e<log10(10.0)");
		EvaluatorLexer lexer = new EvaluatorLexer(stream);
		TokenStream tokenStream = new CommonTokenStream(lexer);
		EvaluatorParser evaluator = new EvaluatorParser(tokenStream);
		evaluator.evaluator();
		EvalConstraint ec=evaluator.evalConstraint;
		EvalExpression ee=ec.getEvalExpression();
		System.out.println(ec.getSign());
		System.out.println(ee.getValue().getData());
		System.out.println(ee.getMultiplier().get("a").getData());
		System.out.println(ee.getMultiplier().get("b").getData());
		System.out.println(ee.getMultiplier().get("c").getData());
		System.out.println(ee.getMultiplier().get("d").getData());
		System.out.println(ee.getMultiplier().get("e").getData());
	}
	
	public void testConditionStatement() throws RecognitionException, IOException {
        String mainFile="z:\\temp\\test";
        new MainFile(mainFile);
		
		ANTLRStringStream stream = new ANTLRStringStream("c: (6+8)*4>(3-2) .and. 100-4<3");
		EvaluatorLexer lexer = new EvaluatorLexer(stream);
		TokenStream tokenStream = new CommonTokenStream(lexer);
		EvaluatorParser evaluator = new EvaluatorParser(tokenStream);
		evaluator.evaluator();
		boolean eCondition=evaluator.evalCondition;
		if (eCondition){
			System.out.println("true");
		}else{
			System.out.println("false");
		}
		
		Error.writeEvaluationErrorFile("log.txt");
	}
	
	public void testExternalFunction() throws RecognitionException, IOException {
        new LoadDll();

        String mainFile="z:\\temp\\test";
        new MainFile(mainFile);
		
		ANTLRStringStream stream = new ANTLRStringStream("v: 1+annlinegen(6472.58740234; 8065.77587891; 9674.55859375; 7614.22070313; 1844.08239746; 829.421325684; 0.0; 2808.64648438;  1565.21533203; 799.454162598; 645.070129395; 816.196533203; 1269.01464844; 0.0; 26.0; 31.0; 31.0; 30.0; 1061.79003906; 3956.91992188; 3897.29638672; 2362.15014648; 1330.7467041; 200.450531006; 241.239242554; 0.0; 54.8862113953; -141; 330.817657471; 365.760253906; 384.316558838; 375.362304688; 346.135650635; 603.290405273; 648.479736328; 647.118896484; 647.933044434; 637.05291748; 31; 30; 31; 31; 30; 964.91; 10000; 12000; 2; 2; 1; 12; 1990; 3)");
		EvaluatorLexer lexer = new EvaluatorLexer(stream);
		TokenStream tokenStream = new CommonTokenStream(lexer);
		EvaluatorParser evaluator = new EvaluatorParser(tokenStream);
		evaluator.evaluator();
		System.out.println(evaluator.evalValue.getData());
		
		Error.writeEvaluationErrorFile("log.txt");
	}
	
	@Test
	public void testInteger() throws RecognitionException, IOException {

        String mainFile="z:\\temp\\test";
        new MainFile(mainFile);
		
		ANTLRStringStream stream = new ANTLRStringStream("g: 3*a/2<1"); 
		EvaluatorLexer lexer = new EvaluatorLexer(stream);
		TokenStream tokenStream = new CommonTokenStream(lexer);
		EvaluatorParser evaluator = new EvaluatorParser(tokenStream);
		evaluator.evaluator();
		System.out.println(evaluator.evalConstraint.getEvalExpression().getMultiplier().get("a").getData());
		
		Error.writeEvaluationErrorFile("log.txt");
	}
}
