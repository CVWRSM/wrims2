package wrimsv2.wreslplus.elements;

import java.io.File;
import java.util.ArrayList;

public class Workflow {
	
	
	private Workflow(){}


	public static StudyTemp checkStudy(String mainFilePath) {
		
		
		String canonicalMainFilePath = Tools.checkPath(mainFilePath);
		
		ParserUtils.setRunDir(new File(canonicalMainFilePath).getParent()); 
		
		StudyTemp st = ParserUtils.parseWreslMain(canonicalMainFilePath);
		// TODO: need to check sequence error here
		// check study
		ErrorCheck.checkVarRedefined(st);		
		ToLowerCase.convert(st);	
		// TODO: make backup of original var list
		Procedures.findEffectiveModelinMain(st); // main file only

		Procedures.processIncFilePath(st);
		Procedures.processSvIncFileList(st);
		Procedures.processT_svList(st);
		Procedures.processDependants(st);

		/// store main file models in fileModelDataTable
		for (String se : st.seqList){
			
			String modelName = st.seqMap.get(se).model;
			ModelTemp mt = st.modelMap.get(modelName);
				
			
			if (st.fileModelNameMap.keySet().contains(mt.pathRelativeToRunDir)) {
				
				st.fileModelNameMap.get(mt.pathRelativeToRunDir).add(modelName);
				
			} else {
				ArrayList<String> modelNameList = new ArrayList<String>();
				modelNameList.add(modelName);
				st.fileModelNameMap.put(mt.pathRelativeToRunDir, modelNameList);
			}
			
			st.fileModelDataTable.put(mt.pathRelativeToRunDir, modelName, mt);			
			
		}


		
		// parse all included files		
		// store results to a map using relativePath as key
		for (String se : st.seqList){
			
			SequenceTemp seqObj = st.seqMap.get(se); 
			String m = seqObj.model;
			
			System.out.println("[M]"+m);

			ModelTemp mt = st.modelMap.get(m);

			ParserUtils.parseAllIncFile(mt.incFileRelativePathList, st);					
			
		}
	
		
		
		
		
		// find all offspring
		// store results to kidMap and AOMap, fileGroupOrder
		Procedures.findKidMap(st);
		
		
		Procedures.findAOM(st);
		
		
		Procedures.findFileGroupOrder(st);
		

		Procedures.postProcessVarListinIncFile(st);
		Procedures.postProcessIncFileList(st);		

		
		// can be processed after error check 
		Procedures.processGoalHS(st);  // changes dvList and ssList
		Procedures.convertAliasToGoal(st);  // changes
		
		
		// can be processed at final stage
		Procedures.copyModelVarMapToSequenceVarMap(st);
		Procedures.collectWeightVar(st);
		
		
//		//test
//		String mn = st.modelList_effective.get(0);
//		ModelTemp mmm = st.modelMap.get(mn);
//		
//		System.out.println("!!! wv: "+mmm.wvList_defaultType);
		
		return st;
		
	}	



}
	
