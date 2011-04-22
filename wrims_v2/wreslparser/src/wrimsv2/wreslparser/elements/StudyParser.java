package wrimsv2.wreslparser.elements;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import org.antlr.runtime.RecognitionException;

import wrimsv2.commondata.wresldata.ModelDataSet;
import wrimsv2.commondata.wresldata.StudyDataSet;
import wrimsv2.commondata.wresldata.Timeseries;
import wrimsv2.wreslparser.elements.LogUtils;
import wrimsv2.wreslparser.grammar.WreslTreeWalker;


public class StudyParser {
	
	public static StudyDataSet writeWreslData(StudyConfig sc, TempData td){
		
		StudyDataSet studyDataSet = new StudyDataSet();
		
		studyDataSet.setModelList(sc.modelList);
		studyDataSet.setModelConditionList(sc.modelConditionList);
		
		Map<String, ModelDataSet> modelDataSetMap = new HashMap<String, ModelDataSet>();
		Map<String, Timeseries> timeseriesMap = new HashMap<String, Timeseries>();
		
		for (String modelName: studyDataSet.getModelList()){
			
			SimulationDataSet ds = td.model_dataset_map.get(modelName);
			ModelDataSet thisModelDataSet = new ModelDataSet();

			thisModelDataSet.svTsDvList = ds.svTsDvList; 
			thisModelDataSet.svTsList = ds.svTsList; 
			
			thisModelDataSet.dvList = ds.dvList; 
			thisModelDataSet.dvList_global = ds.dvList_global; 
			thisModelDataSet.dvList_local = ds.dvList_local; 
			thisModelDataSet.dvMap = ds.dvMap; 

			thisModelDataSet.tsList = ds.tsList; 
			thisModelDataSet.tsList_global = ds.tsList_global; 
			thisModelDataSet.tsList_local = ds.tsList_local; 
			thisModelDataSet.tsMap = ds.tsMap;
			
			thisModelDataSet.svList = ds.svList; 
			thisModelDataSet.svList_global = ds.svList_global; 
			thisModelDataSet.svList_local = ds.svList_local; 
			thisModelDataSet.svMap = ds.svMap;
			
			thisModelDataSet.gList = ds.gList; 
			thisModelDataSet.gList_global = ds.gList_global; 
			thisModelDataSet.gList_local = ds.gList_local; 
			thisModelDataSet.gMap = ds.gMap;

			thisModelDataSet.asList = ds.asList; 
			thisModelDataSet.asList_global = ds.asList_global; 
			thisModelDataSet.asList_local = ds.asList_local; 
			thisModelDataSet.asMap = ds.asMap;

			thisModelDataSet.exList = ds.exList; 
			thisModelDataSet.exList_global = ds.exList_global; 
			thisModelDataSet.exList_local = ds.exList_local; 
			thisModelDataSet.exMap = ds.exMap;
			
			thisModelDataSet.wtList = ds.wtList; 
			thisModelDataSet.wtMap = ds.wtMap;	
			
			thisModelDataSet.incFileList=ds.incFileList;
			thisModelDataSet.incFileList_global=ds.incFileList_global;
			thisModelDataSet.incFileList_local=ds.incFileList_local;
			
			modelDataSetMap.put(modelName, thisModelDataSet);
			timeseriesMap.putAll(ds.tsMap);
		}
		
		studyDataSet.setModelDataSetMap(modelDataSetMap);
		studyDataSet.setTimeseriesMap(timeseriesMap);
		
		return studyDataSet;
	}
	
	public static StudyConfig processMainFileIntoStudyConfig(String relativeMainFilePath) throws RecognitionException, IOException {
		
		File absMainFile = new File(relativeMainFilePath).getAbsoluteFile();
		String absMainFilePath = absMainFile.getCanonicalPath().toLowerCase();
		
		LogUtils.importantMsg("Parsing study main file: " + absMainFilePath);
		
		WreslTreeWalker walker = FileParser.parseFile(absMainFilePath);
		
		StudyConfig sc = new StudyConfig();

		sc.sequenceMap = walker.thisFileDataSet.seqMap;
		
		/// Sort sequence order
		
		for ( Integer i : sc.sequenceMap.keySet()){ sc.sequenceOrder.add(i); }
		Collections.sort(sc.sequenceOrder);

		for ( Integer i : sc.sequenceOrder){ 
			sc.sequenceList.add(sc.sequenceMap.get(i).sequenceName);
			sc.modelList.add(sc.sequenceMap.get(i).modelName);
			
			sc.modelConditionList.add(sc.sequenceMap.get(i).condition);
		}		

		sc.absMainFilePath = absMainFilePath;
		sc.modelDataMap = walker.modelDataMap;
				
		for ( Integer i : sc.sequenceOrder){	
			LogUtils.importantMsg("Sequence: "+i+" : "+sc.sequenceMap.get(i).sequenceName +"   Model: "+sc.sequenceMap.get(i).modelName);		
		}	
		
		return sc;
	}
	
	public static Map<String, SimulationDataSet> parseModels(StudyConfig sc, TempData td) throws RecognitionException, IOException {

		Map<String, SimulationDataSet> model_dataset_map = new HashMap<String, SimulationDataSet>();
		
		for ( Integer iSequence : sc.sequenceOrder){	

			String modelName = sc.sequenceMap.get(iSequence).modelName;
		
			LogUtils.importantMsg("Processing sequence: "+iSequence+", model: "+modelName);
			
			SimulationDataSet adhoc = sc.modelDataMap.get(modelName);
			
			/// get new dataset in this model
			Map<String,SimulationDataSet> fileDataMap_new = getNewDataSet(adhoc.incFileSet, td.fileDataMap_wholeStudy.keySet());
			
			/// update whole study
			td.fileDataMap_wholeStudy.putAll(fileDataMap_new);
			/// update whole study t1Map
			td.t1Map_wholeStudy.putAll(Tools.getType1Map(fileDataMap_new));
			td.fileScopeMap_wholeStudy.putAll(Tools.getFileScopeMap(fileDataMap_new));
			
			
			/// copy file data map from updated whole study to this model
			Map<String,SimulationDataSet> fileDataMap_thisModel = copyDataSetToThisModel(adhoc.incFileSet, td.fileDataMap_wholeStudy);
			
			
			/// correct scope and prioritize
			SimulationDataSet model_dataset = correctScopeAndPrioritize(modelName,
														adhoc,
														sc.absMainFilePath,
														fileDataMap_thisModel,
														td.fileDataMap_wholeStudy,  
														td.t1Map_wholeStudy,        
														td.fileScopeMap_wholeStudy
														);
			
			/// get whole study reverse map / TODO: not needed for global because source file is the same
			td.t1Map_wholeStudy.put(sc.absMainFilePath, adhoc.incFileSet);
			Map<String,Set<String>> t1ReverseMap_wholeStudy = Tools.getReverseMap(td.t1Map_wholeStudy);
			
//			String ttt="";
//			Map<String,Set<String>> qwe = t1ReverseMap_wholeStudy;
//			for (String s : qwe.keySet()){
//				ttt = ttt + "{"+s+"}"+"::"+qwe.get(s);
//			}
//			LogUtils.errMsg(ttt);
			
			/// include global data
			/// previous globals have lowest priority /TODO: remove reverse map
			System.out.println(" globals in common :"+td.cumulative_global_complete.dvSet_global );
			System.out.println(" globals in model before :"+model_dataset.dvSet_global );
	
			///  a working route for overwrite_set
			///////////////////////////////////////////////////////////
			SimulationDataSet e = new SimulationDataSet();
			e.overwrittenWith_set(td.cumulative_global_complete);
			e.overwrittenWith_set(model_dataset);
			model_dataset = e;
			////////////////////////////////////////////////////////////
			
			System.out.println(" globals in model after :"+model_dataset.dvSet_global );			

			
			//LogUtils.normalMsg("========== Finish cumulative globals prioritization =========== ");

			
			////////////////////////////////////////////////////////////////

			lousyConvert(model_dataset);

			/////////////////////////////////////////////////////////////////////
			
			
		    model_dataset_map.put(modelName, model_dataset);
		    
			/// update/overwrite cumulative globals
			td.cumulative_global_adhocs.overwrittenWith_set(sc.modelDataMap.get(modelName).getGlobalVars_set());
			td.cumulative_global_complete.overwrittenWith_set(model_dataset.getGlobalVars_set());	
			
			lousyConvert(td.cumulative_global_adhocs);
			lousyConvert(td.cumulative_global_complete);

		}
		return model_dataset_map;		
	}
	
	public static Map<String,SimulationDataSet> getNewDataSet(Set<String> adhoc_incFileSet, Set<String> fileDataMap_wholeStudy_keySet ) throws RecognitionException, IOException{
		
		Map<String,SimulationDataSet> fileDataMap_new = new HashMap<String, SimulationDataSet>();
		
		/// process include files in this model and those in previous globals
		for (String f: adhoc_incFileSet) {
			
			if (fileDataMap_wholeStudy_keySet.contains(f))  {
				
				LogUtils.importantMsg("....Skip file: "+f);				
			} 
			else { /// new file
				Map<String, SimulationDataSet> each = FileParser.processNestedFileExceptFor(f,fileDataMap_wholeStudy_keySet);
				fileDataMap_new.putAll(each);

			}				
		}			
		return fileDataMap_new;
	}

	public static Map<String,SimulationDataSet> copyDataSetToThisModel(Set<String> incFileSet, 
																	   Map<String,SimulationDataSet> fileDataMap_wholeStudy ){
		
		/// get all file data map for this study
		Map<String,SimulationDataSet> fileDataMap_thisModel = new HashMap<String, SimulationDataSet>();		
						
			/// copy to this model
			for (String f: incFileSet) {
			
				fileDataMap_thisModel.putAll(Tools.putDataFileMapFromWholeStudy(f,fileDataMap_wholeStudy));
			}
		
		return fileDataMap_thisModel;
		
	}
	
	public static SimulationDataSet correctScopeAndPrioritize( String modelName,
												SimulationDataSet adhoc,
												String absMainFilePath,
												Map<String,SimulationDataSet> fileDataMap_thisModel,
												Map<String, SimulationDataSet> fileDataMap_wholeStudy,
												Map<String,Set<String>> t1Map_wholeStudy,
												Map<String,String> fileScopeMap_wholeStudy
												)
	
	throws RecognitionException, IOException {
			
			
			/// this model t1Map, fileScopeMap, and reverseMap /TODO: avoid repeated processing
			Map<String,String> fileScopeMap = new HashMap<String, String>(fileScopeMap_wholeStudy);
			fileScopeMap.putAll(Tools.getScopeMap(adhoc.incFileSet, adhoc.incFileSet_local));
			
			Map<String,Set<String>> t1Map = new HashMap<String,Set<String>>(t1Map_wholeStudy);
			t1Map.put(absMainFilePath, adhoc.incFileSet);
			Map<String,Set<String>> t1ReverseMap = Tools.getReverseMap(t1Map);

			//////////////////////////////////////////////////////////////////////////////////////
			LogUtils.normalMsg(".....Finished fileScopeMap & ReverseMap.");
			
			Map<String,SimulationDataSet> fileDataMap_corrected = new HashMap<String, SimulationDataSet>();
			fileDataMap_corrected.putAll(fileDataMap_thisModel);			
			
			for (String f : fileDataMap_thisModel.keySet()) {

				SimulationDataSet ds = Tools.correctDataScope(f, fileDataMap_thisModel.get(f), fileScopeMap, t1ReverseMap);				
				fileDataMap_corrected.put(f, ds);
			}
			
//----------------------------------------------------------------------------------		
			/// prioritize data if redefined			
			SimulationDataSet model_dataset = new SimulationDataSet();
			LogUtils.normalMsg("========== Start data prioritization =========== ");	
			
			ArrayList<String> reverseList = new ArrayList<String>(adhoc.incFileList); 
			Collections.reverse(reverseList);
			
			/// for kids
			for (String f : adhoc.incFileList) {
				
					SimulationDataSet temp = new SimulationDataSet();		
				//LogUtils.normalMsg("========== Prioritize offsprings in file: "+f);
					temp.addChildren(f, t1Map, fileDataMap_corrected);
					
					temp.overwrittenWith_set(fileDataMap_corrected.get(f));
					
					model_dataset.overwrittenWith_set(temp);
			}
			//LogUtils.normalMsg("========== Finish children prioritization =========== ");
			
			/// for include files in adhoc
//			for (String f : adhoc.incFileList) {
//				
//                //LogUtils.normalMsg("========== Prioritize adhoc include file: "+f);
////				model_dataset.prioritize(fileDataMap_corrected.get(f), f, t1ReverseMap);
//			}
			
			/// for vars in adhoc
			//LogUtils.normalMsg("========== Prioritize adhoc =========== ");
			//model_dataset.prioritize_append(adhoc, absMainFilePath, t1ReverseMap);
			model_dataset.overwrittenWith_set(adhoc);
			LogUtils.normalMsg("========== Finish adhoc prioritization =========== ");
//---------------------------------------------------------------------------------------			

		return model_dataset;
	}

	public static void lousyConvert(SimulationDataSet q){
		
		q.asList = new ArrayList<String>(q.asSet);
		q.asList_global = new ArrayList<String>(q.asSet_global);
		q.asList_local = new ArrayList<String>(q.asSet_local);
		
		q.wtList = new ArrayList<String>(q.wtSet);
		q.wtList_global = new ArrayList<String>(q.wtSet_global);
		q.wtList_local = new ArrayList<String>(q.wtSet_local);
		
		q.svList = new ArrayList<String>(q.svSet);
		q.svList_global = new ArrayList<String>(q.svSet_global);
		q.svList_local = new ArrayList<String>(q.svSet_local);
		
		q.dvList = new ArrayList<String>(q.dvSet);
		q.dvList_global = new ArrayList<String>(q.dvSet_global);
		q.dvList_local = new ArrayList<String>(q.dvSet_local);
		
		q.tsList = new ArrayList<String>(q.tsSet);
		q.tsList_global = new ArrayList<String>(q.tsSet_global);
		q.tsList_local = new ArrayList<String>(q.tsSet_local);
		
		q.exList = new ArrayList<String>(q.exSet);
		q.exList_global = new ArrayList<String>(q.exSet_global);
		q.exList_local = new ArrayList<String>(q.exSet_local);
		
		q.incFileList = new ArrayList<String>(q.incFileSet);
		q.incFileList_global = new ArrayList<String>(q.incFileSet_global);
		q.incFileList_local = new ArrayList<String>(q.incFileSet_local);
		
	}
	
	
	
}
