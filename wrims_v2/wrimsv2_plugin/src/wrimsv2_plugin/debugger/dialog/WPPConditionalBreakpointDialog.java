package wrimsv2_plugin.debugger.dialog;

import java.util.ArrayList;
import java.util.HashMap;

import org.eclipse.debug.core.DebugException;
import org.eclipse.jface.dialogs.PopupDialog;
import org.eclipse.jface.viewers.TableTreeViewer;
import org.eclipse.jface.viewers.CellEditor.LayoutData;
import org.eclipse.jface.viewers.TableViewer;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.TableTree;
import org.eclipse.swt.custom.TableTreeItem;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.layout.RowLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Dialog;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableItem;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.IViewPart;
import org.eclipse.ui.IWorkbench;
import org.eclipse.ui.PlatformUI;

import wrimsv2_plugin.debugger.core.DebugCorePlugin;
import wrimsv2_plugin.debugger.exception.WPPException;
import wrimsv2_plugin.debugger.menuitem.EnableMenus;
import wrimsv2_plugin.debugger.view.WPPAllGoalView;
import wrimsv2_plugin.debugger.view.WPPAllVariableView;
import wrimsv2_plugin.debugger.view.WPPGoalView;
import wrimsv2_plugin.debugger.view.WPPVarDetailView;
import wrimsv2_plugin.debugger.view.WPPVariableView;
import wrimsv2_plugin.tools.SearchTable;

public class WPPConditionalBreakpointDialog extends PopupDialog {
	
	public WPPConditionalBreakpointDialog(Shell parent, int shellStyle,
			boolean takeFocusOnOpen, boolean persistSize,
			boolean persistLocation, boolean showDialogMenu,
			boolean showPersistActions, String titleText, String infoText) {
		super(parent, shellStyle, takeFocusOnOpen, persistSize, persistLocation,
				showDialogMenu, showPersistActions, titleText, infoText);
		// TODO Auto-generated constructor stub
	}

	public void open(int i){
		create();
		getShell().setSize(600, 230);
		open();
	}

	@Override
	 protected Control createDialogArea(Composite parent) {
		Composite dialogArea = (Composite) super.createDialogArea(parent);
		FillLayout layout=new FillLayout(SWT.VERTICAL);
		layout.marginWidth=20;
		layout.marginHeight=20;
		dialogArea.setLayout(layout);
		
		Label label1=new Label(dialogArea, SWT.NONE);
		label1.setText("Set condition:");
		
		final Text text1=new Text(dialogArea, SWT.BORDER|SWT.H_SCROLL);
		text1.setText(DebugCorePlugin.conditionalBreakpoint);
				
		RowLayout layout1=new RowLayout(SWT.HORIZONTAL);
		layout1.fill=true;
		Composite line3=new Composite(dialogArea, SWT.NONE);
		line3.setLayout(layout1);
		Button ok = new Button(line3, SWT.PUSH);
		ok.setText("OK");
		ok.addSelectionListener(new SelectionAdapter(){
			public void widgetSelected(SelectionEvent event){
				DebugCorePlugin.conditionalBreakpoint=text1.getText();
				setConditionalBreakpoint();
				close();
			}
		});
		
		Button clear = new Button(line3, SWT.PUSH);
		clear.setText("Clear");
		clear.addSelectionListener(new SelectionAdapter(){
			public void widgetSelected(SelectionEvent event){
				text1.setText("");
			}
		});
		
		Button cancel = new Button(line3, SWT.PUSH);
		cancel.setText("Cancel");
		cancel.addSelectionListener(new SelectionAdapter(){
			public void widgetSelected(SelectionEvent event){
				close();
			}
		});
		
		dialogArea.getShell().setDefaultButton(ok);
		return dialogArea;
	 }
	
	public void setConditionalBreakpoint(){
		if (DebugCorePlugin.isDebugging){
			try {
				DebugCorePlugin.target.sendRequest("conditional_breakpoint:"+DebugCorePlugin.conditionalBreakpoint);
			} catch (DebugException e) {
				WPPException.handleException(e);
			}
		}
	}
}