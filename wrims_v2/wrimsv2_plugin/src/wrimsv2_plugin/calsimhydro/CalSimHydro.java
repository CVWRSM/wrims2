package wrimsv2_plugin.calsimhydro;

import java.io.File;
import java.io.IOException;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.IDebugTarget;
import org.eclipse.debug.core.model.IProcess;

import wrimsv2_plugin.debugger.core.DebugCorePlugin;
import wrimsv2_plugin.debugger.exception.WPPException;
import wrimsv2_plugin.debugger.model.WPPDebugTarget;
import wrimsv2_plugin.tools.FileProcess;

public class CalSimHydro {

	public void run(ILaunchConfiguration configuration){
		System.out.println("CalSim Hydro Run Started");
		try {
			String che = configuration.getAttribute(DebugCorePlugin.ATTR_WPP_CALSIMHYDROEXE, "");
			if (che.trim().equals("")){
				DefaultCalSimHydro dch=new DefaultCalSimHydro();
				dch.run();
			}else{
				String cheAbs=che;
				if (!new File(che).isAbsolute()){
					cheAbs=FileProcess.procRelativePath(che, configuration);
				}
				Process process = Runtime.getRuntime().exec(new String[] {"cmd.exe", "/c", "start", "/w", cheAbs});
				process.waitFor();
				int terminateCode=process.exitValue();
			}
		} catch (CoreException e) {
			WPPException.handleException(e);
		} catch (IOException e) {
			WPPException.handleException(e);
		} catch (InterruptedException e) {
			WPPException.handleException(e);
		}
		System.out.println("CalSim Hydro Run Completed");
	}
	
}
