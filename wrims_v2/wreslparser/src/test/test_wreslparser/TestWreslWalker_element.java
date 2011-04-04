
package test.test_wreslparser;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.antlr.runtime.RecognitionException;
import org.testng.Assert;
import org.testng.annotations.Test;


import wrimsv2.commondata.wresldata.StudyDataSet;
import wrimsv2.commondata.wresldata.Svar;
import wrimsv2.wreslparser.elements.FileParser;
import wrimsv2.wreslparser.elements.LogUtils;
import wrimsv2.wreslparser.elements.RegUtils;
import wrimsv2.wreslparser.elements.SimulationDataSet;
import wrimsv2.wreslparser.elements.StudyConfig;
import wrimsv2.wreslparser.elements.StudyParser;
import wrimsv2.wreslparser.elements.TempData;
import wrimsv2.wreslparser.elements.Tools;
import wrimsv2.wreslparser.elements.WriteCSV;
import wrimsv2.wreslparser.grammar.WreslTreeWalker;

public class TestWreslWalker_element {
	
	public String projectPath = "src\\test\\test_wreslparser\\";	
	public String inputFilePath;
	public String logFilePath;	
	public String csvFolderPath;	
	
	@Test(groups = { "WRESL_elements" })
	public void dvarNonStd() throws RecognitionException, IOException {
		
		inputFilePath =projectPath+"TestWreslWalker_element_dvarNonStd.wresl";
		logFilePath = "TestWreslWalker_element_dvarNonStd.log";
		
		File absFile = new File(inputFilePath).getAbsoluteFile();
		String absFilePath = absFile.getCanonicalPath().toLowerCase();
		
		LogUtils.setLogFile(logFilePath);
		
		WreslTreeWalker walker = FileParser.parseFile(absFilePath);
		//LogUtils.importantMsg("tree = " + walker.commonTree.toStringTree());
		LogUtils.fileSummary(walker.thisFileDataSet);
		LogUtils.closeLogFile();
			
		String fileText = Tools.readFileAsString(logFilePath);	
		int totalErrs = RegUtils.timesOfMatches(fileText, "# Error:");
		Assert.assertEquals(totalErrs, 0);		
	}	
	
	@Test(groups = { "WRESL_elements" })
	public void dvarStd() throws RecognitionException, IOException {
		
		inputFilePath =projectPath+"TestWreslWalker_element_dvarStd.wresl";
		logFilePath = "TestWreslWalker_element_dvarStd.log";
		
		File absFile = new File(inputFilePath).getAbsoluteFile();
		String absFilePath = absFile.getCanonicalPath().toLowerCase();
		
		LogUtils.setLogFile(logFilePath);
		
		WreslTreeWalker walker = FileParser.parseFile(absFilePath);
		LogUtils.importantMsg("tree = " + walker.commonTree.toStringTree());
		
		LogUtils.closeLogFile();
		
		
		String fileText = Tools.readFileAsString(logFilePath);
		int redefineErrs = RegUtils.timesOfMatches(fileText, "# Error: Dvar redefined: C_Banks");
		int totalErrs = RegUtils.timesOfMatches(fileText, "# Error:");
		Assert.assertEquals(redefineErrs, 1);
		Assert.assertEquals(totalErrs, 1);		
	}
	
	@Test(groups = { "WRESL_elements" })
	public void svarDSS() throws RecognitionException, IOException {
		
		inputFilePath =projectPath+"TestWreslWalker_element_svarDSS.wresl";
		logFilePath = "TestWreslWalker_element_svarDSS.log";
		csvFolderPath = "TestWreslWalker_element_svarDSS";

		LogUtils.setLogFile(logFilePath);
		
		File absFile = new File(inputFilePath).getAbsoluteFile();
		String absFilePath = absFile.getCanonicalPath().toLowerCase();
		
		TempData td = new TempData();

		StudyConfig sc = StudyParser.processMainFileIntoStudyConfig(absFilePath);
		
		td.model_dataset_map=StudyParser.parseModels(sc,td);
		
		StudyDataSet sd = StudyParser.writeWreslData(sc, td); 

		LogUtils.studySummary_details(sd);

		LogUtils.closeLogFile();
		
		
		String modelName = sd.getModelList().get(0);
//		Map<String, Svar> svMap = sd.getModelDataSetMap().get(modelName).svMap;
//		ArrayList<String> svList = sd.getModelDataSetMap().get(modelName).svList;
		
		WriteCSV.dataset(sd.getModelDataSetMap().get(modelName),csvFolderPath ) ;
	
		String logText = Tools.readFileAsString(logFilePath);	
		String csvText = Tools.readFileAsString(csvFolderPath+"\\svar.csv");	

		int r1 = RegUtils.timesOfMatches(csvText, "complex,UD_CCWD,DEMAND-CVP,TAF,CFS,n,default,1,always,timeseries,");
		Assert.assertEquals(r1, 1);
		
		int totalErrs = RegUtils.timesOfMatches(logText, "# Error:");
		Assert.assertEquals(totalErrs, 0);		
	}
	
	@Test(groups = { "WRESL_elements" })
	public void svarConst() throws RecognitionException, IOException {
		
		inputFilePath =projectPath+"TestWreslWalker_element_svarConst.wresl";
		logFilePath = "TestWreslWalker_element_svarConst.log";
		csvFolderPath = "TestWreslWalker_element_svarConst";

		LogUtils.setLogFile(logFilePath);
		
		File absFile = new File(inputFilePath).getAbsoluteFile();
		String absFilePath = absFile.getCanonicalPath().toLowerCase();
		
		TempData td = new TempData();

		StudyConfig sc = StudyParser.processMainFileIntoStudyConfig(absFilePath);
		
		td.model_dataset_map=StudyParser.parseModels(sc,td);
		
		StudyDataSet sd = StudyParser.writeWreslData(sc, td); 

		LogUtils.studySummary_details(sd);

		LogUtils.closeLogFile();
		
		
		String modelName = sd.getModelList().get(0);
//		Map<String, Svar> svMap = sd.getModelDataSetMap().get(modelName).svMap;
//		ArrayList<String> svList = sd.getModelDataSetMap().get(modelName).svList;
		
		WriteCSV.dataset(sd.getModelDataSetMap().get(modelName),csvFolderPath ) ;
	
		String logText = Tools.readFileAsString(logFilePath);	
		String csvText = Tools.readFileAsString(csvFolderPath+"\\svar.csv");	

		int r1 = RegUtils.timesOfMatches(csvText, "minflow_C_Orovl,..,..,..,..,n,default,1,always,.29,");
		Assert.assertEquals(r1, 1);
		
		int totalErrs = RegUtils.timesOfMatches(logText, "# Error: State variable redefined");
		Assert.assertEquals(totalErrs, 1);		
	}
}
