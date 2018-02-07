package wrimsv2_plugin.debugger.dialog;


import org.eclipse.debug.core.DebugException;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Dialog;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.IViewPart;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.console.IConsoleConstants;
import org.eclipse.ui.internal.Workbench;

import wrimsv2_plugin.debugger.core.DebugCorePlugin;
import wrimsv2_plugin.debugger.exception.WPPException;

public class WPPSolverOptionDialog extends Dialog {
	
	public WPPSolverOptionDialog(Shell parent) {
		super(parent, SWT.MIN);
		setText("Solver Option");
	}

	public void openDialog(){
		Shell shell=new Shell(getParent(), getStyle());
		shell.setText(getText());
		createContents(shell);
		shell.setSize(300, 170);
		shell.setLocation(450, 300);
		//shell.pack();
		shell.open();
	}

	protected void createContents(final Shell shell) {
		GridLayout layout=new GridLayout(2, false);
		layout.marginWidth=20;
		layout.marginHeight=15;
		shell.setLayout(layout);
		
		GridData gridData=new GridData(GridData.FILL_BOTH);
		gridData.horizontalSpan=1;
		
		Label label1 = new Label(shell, SWT.NONE);
		label1.setText("Solver:");
		
		final Combo solverCombo = new Combo(shell, SWT.BORDER);
		solverCombo.add("XA");
		solverCombo.add("CBC");
		//solverCombo.add("LPSolve");
		
		Label label2 =  new Label(shell, SWT.NONE);
		label2.setText("Log:");
		
		final Combo logCombo = new Combo(shell, SWT.BORDER);
		logCombo.add("None");
		logCombo.add("Log");
		
		if (DebugCorePlugin.solver.equals("XA")){
			solverCombo.select(0);
		}else if (DebugCorePlugin.solver.equals("CBC")){
			solverCombo.select(1);
		}else if (DebugCorePlugin.solver.equals("LPSolve")){
			solverCombo.select(2);
		}
		if (DebugCorePlugin.target==null){
			solverCombo.setEnabled(true);
			logCombo.setEnabled(true);
		}else if (DebugCorePlugin.target.isTerminated()){
			solverCombo.setEnabled(true);
			logCombo.setEnabled(true);
		}else if (DebugCorePlugin.target.isSuspended()){
			solverCombo.setEnabled(true);
			logCombo.setEnabled(true);
		}else{
			solverCombo.setEnabled(false);
			logCombo.setEnabled(false);
		}
		
		if (DebugCorePlugin.log.equals("None")){
			logCombo.select(0);
		}else if (DebugCorePlugin.log.equals("Log")){
			logCombo.select(1);
		}
		
		Button ok = new Button(shell, SWT.PUSH);
		ok.setText("OK");
		ok.addSelectionListener(new SelectionAdapter(){
			public void widgetSelected(SelectionEvent event){
				DebugCorePlugin.solver=solverCombo.getText();
				DebugCorePlugin.log=logCombo.getText();
				if (DebugCorePlugin.isDebugging){
					try {
						DebugCorePlugin.target.sendRequest("solveroption:"+DebugCorePlugin.solver+":"+DebugCorePlugin.log);
					} catch (DebugException e) {
						WPPException.handleException(e);
					}
				}
				showSolverStatus();
				shell.close();
			}
		});
		
		Button cancel = new Button(shell, SWT.PUSH);
		cancel.setText("Cancel");
		cancel.addSelectionListener(new SelectionAdapter(){
			public void widgetSelected(SelectionEvent event){
				shell.close();
			}
		});
		
		shell.setDefaultButton(ok);
	}
	
	public void showSolverStatus(){
		Display.getDefault().syncExec(new Runnable() {
			public void run() {
				String log="";
				if (!DebugCorePlugin.log.equalsIgnoreCase("NONE")){
					log=DebugCorePlugin.log;
				}
				String status=DebugCorePlugin.solver+"  "+log;
				
				IWorkbenchPage page = Workbench.getInstance().getActiveWorkbenchWindow().getActivePage();
				try {
					IViewPart console = page.showView( IConsoleConstants.ID_CONSOLE_VIEW );
					if (console != null){
						console.getViewSite().getActionBars().getStatusLineManager().setMessage(status);
					}
				} catch (PartInitException e) {
					WPPException.handleException(e);
				} 
			}
		});
	}
}
