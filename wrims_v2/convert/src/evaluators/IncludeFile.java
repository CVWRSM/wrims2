package evaluators;

public class IncludeFile {
	
	public String scope;
	public String absFilePath;
	public String fromWresl;
	
	public IncludeFile(){
		scope=Parameters.undefined;
		fromWresl=Parameters.undefined;
		//absFilePath=Parameters.undefined;

	}
	
	public String equalEva(){
		//String s = "|";				
		String temp = scope; //+s+absFilePath;
		
		return temp;
	}

	@Override
	public boolean equals(Object obj)
	{

		if ((obj == null) || (obj.getClass() != this.getClass())) {
			return false;
		}

		else if (((IncludeFile) obj).equalEva() == null) {
			return false;
		}

		else if (this.equalEva() == ((IncludeFile) obj).equalEva()) {
			return true;
		}

		else {
			return false;
		}
	}
}
	
