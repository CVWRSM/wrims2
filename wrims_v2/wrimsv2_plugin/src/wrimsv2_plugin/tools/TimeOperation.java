package wrimsv2_plugin.tools;

public class TimeOperation {
	public static boolean isLeapYear(int year){
		if (year % 4 == 0) {
		    if (year % 100 != 0) {
		    	return true;
		    }else if (year % 400 == 0) {
		    	return true;
		    }else {
		    	return false;
		    }
		}else{
			return false;
		}
	}
	
	public static int numberOfDays(int month, int year){
		int days;
		if (month==1 || month==3 || month==5 || month==7 
				||month==8 || month==10 ||month==12){
			days=31;
		}else if (month==4|| month==6 || month==9 || month==11){ 
			days=30;
		}else {
			if (TimeOperation.isLeapYear(year)){
				days=29;
			}else{
				days=28;
			}
		}
		return days;
	}
	
	public static int[] searchYearMonth(int noOfMonths, int startYear, int startMonth){
		int detYear=noOfMonths/12;
		int detMonth=noOfMonths%12;
		int debugMonth=startMonth+detMonth;
		int debugYear=startYear+detYear;
		if (debugMonth>12){
			debugMonth=debugMonth-12;
			debugYear=debugYear+1;
		}
		int[] yearMonth=new int[2];
		yearMonth[0]=debugYear;
		yearMonth[1]=debugMonth;
		return yearMonth;
	}
	
	public static int findMonthInBetween(int startYear, int startMonth, int endYear, int endMonth){
		return (endYear-startYear)*12+endMonth-startMonth+1;
	}
	
	
	public static int monthValue(String month){
		if (month.equalsIgnoreCase("jan")){
			return 1;
		}else if (month.equalsIgnoreCase("feb")){
			return 2;
		}else if (month.equalsIgnoreCase("mar")){
			return 3;
		}else if (month.equalsIgnoreCase("apr")){
			return 4;
		}else if (month.equalsIgnoreCase("may")){
			return 5;
		}else if (month.equalsIgnoreCase("jun")){
			return 6;
		}else if (month.equalsIgnoreCase("jul")){
			return 7;
		}else if (month.equalsIgnoreCase("aug")){
			return 8;
		}else if (month.equalsIgnoreCase("sep")){
			return 9;
		}else if (month.equalsIgnoreCase("oct")){
			return 10;
		}else if (month.equalsIgnoreCase("nov")){
			return 11;
		}else{
			return 12;
		}
	}
}
