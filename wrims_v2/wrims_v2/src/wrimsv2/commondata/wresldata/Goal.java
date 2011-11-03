package wrimsv2.commondata.wresldata;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import wrimsv2.evaluator.EvaluatorParser;
import wrimsv2.evaluator.ValueEvaluatorParser;


public class Goal implements Serializable {
	
	private static final long serialVersionUID = 1L;
	public String scope;
	public String lhs;
	public ArrayList<String> caseName;
	
	//     ArrayList< Map< dvarName, Weight > >
	public ArrayList<Map<String,String>> dvarWeightMapList;
	public ArrayList<ArrayList<String>> dvarSlackSurplusList;	
	public ArrayList<String> dvarName; // from slack or surplus
	public ArrayList<String> dvarWeight; // for the slack or surplus. Negative penalty leads to positive weight
	public ArrayList<String> caseCondition;
	public ArrayList<ValueEvaluatorParser> caseConditionParsers;
	public ArrayList<String> caseExpression;
	public Set<String> expressionDependants;
	public ArrayList<EvaluatorParser> caseExpressionParsers;
//	public ArrayList<String> casePenalty;
	public String fromWresl;
	public Set<String> neededVarInCycleSet;
	public boolean needVarFromEarlierCycle;
	
	public Goal(){
		scope=Param.undefined;
		lhs=Param.undefined;
		caseName       = new ArrayList<String>();
		dvarWeightMapList = new ArrayList<Map<String, String>>(); // ArrayList< Map< dvarName, Weight > >
		dvarSlackSurplusList = new ArrayList<ArrayList<String>>(); // ArrayList< ArrayList< dvarName > >
		dvarName       = new ArrayList<String>();
		dvarWeight     = new ArrayList<String>();		
		caseCondition  = new ArrayList<String>();
		caseExpression = new ArrayList<String>();
		expressionDependants = new HashSet<String>();
//		casePenalty    = new ArrayList<String>();
		fromWresl = Param.undefined;
		neededVarInCycleSet = new HashSet<String>();
		needVarFromEarlierCycle = false;
	}
	
	public String equalEva(){
		
		String s = "|";
		String caseNameStr="";
		String caseConditionStr="";
//		String casePenaltyStr="";
		String caseExpressionStr="";
//		String case_lhs_gt_rhs_str="";
//		String case_lhs_lt_rhs_str="";
		
		for (String i: caseName){caseNameStr = caseNameStr + s + i;}
		for (String i: caseCondition){caseConditionStr = caseConditionStr + s + i;}
		for (String i: caseExpression){caseExpressionStr = caseExpressionStr + s + i;}	
		
		//TODO: add expressionDependants
//		for (String i: casePenalty){casePenaltyStr = casePenaltyStr + s + i;}	
//		for (String i: case_lhs_gt_rhs){case_lhs_gt_rhs_str = case_lhs_gt_rhs_str + s + i;}	
//		for (String i: case_lhs_lt_rhs){case_lhs_lt_rhs_str = case_lhs_lt_rhs_str + s + i;}	
		
		String temp = scope+s+lhs+s+caseNameStr+caseConditionStr+s+caseExpressionStr;
		
		return temp;
	}

	@Override
	public boolean equals(Object obj)
	{

		if ((obj == null) || (obj.getClass() != this.getClass())) {
			return false;
		}

		else if (((Goal) obj).equalEva() == null) {
			return false;
		}

		else if (this.equalEva() == ((Goal) obj).equalEva()) {
			return true;
		}

		else {
			return false;
		}
	}
}
	
