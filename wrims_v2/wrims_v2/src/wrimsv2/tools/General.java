package wrimsv2.tools;

import wrimsv2.components.ControlData;

public class General {
	public static boolean isSelectedCycleOutput(String strCycleI){
		if (ControlData.outputAllCycles){
			return true;
		}
		boolean foundTheCycle=false;
		for (int n=0; n<ControlData.selectedCycles.length; n++){
			if (ControlData.selectedCycles[n].equals(strCycleI)){
				foundTheCycle=true;
			}
		}
		if (foundTheCycle){
			return true;
		}else{
			return false;
		}
	}
}
