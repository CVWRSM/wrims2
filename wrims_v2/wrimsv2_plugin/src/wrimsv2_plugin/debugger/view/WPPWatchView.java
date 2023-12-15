package wrimsv2_plugin.debugger.view;

import java.util.ArrayList;
import java.util.Iterator;

import org.eclipse.debug.core.DebugException;
import org.eclipse.debug.core.model.IDebugElement;
import org.eclipse.debug.core.model.IDebugTarget;
import org.eclipse.debug.core.model.IValue;
import org.eclipse.debug.ui.AbstractDebugView;
import org.eclipse.debug.ui.DebugUITools;
import org.eclipse.debug.ui.IDebugModelPresentation;
import org.eclipse.debug.ui.IDebugUIConstants;
import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.action.IToolBarManager;
import org.eclipse.jface.viewers.ILabelProvider;
import org.eclipse.jface.viewers.ILabelProviderListener;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.viewers.ITableLabelProvider;
import org.eclipse.jface.viewers.ITreeContentProvider;
import org.eclipse.jface.viewers.LabelProvider;
import org.eclipse.jface.viewers.StructuredSelection;
import org.eclipse.jface.viewers.StructuredViewer;
import org.eclipse.jface.viewers.TableViewer;
import org.eclipse.jface.viewers.TreeViewer;
import org.eclipse.jface.viewers.Viewer;
import org.eclipse.jface.viewers.ViewerComparator;
import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableColumn;
import org.eclipse.swt.widgets.TableItem;
import org.eclipse.ui.ISelectionListener;
import org.eclipse.ui.IWorkbench;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.IWorkbenchPart;
import org.eclipse.ui.PlatformUI;

import wrimsv2_plugin.debugger.core.DebugCorePlugin;
import wrimsv2_plugin.debugger.exception.WPPException;
import wrimsv2_plugin.debugger.listener.TableCopyListener;
import wrimsv2_plugin.debugger.model.IWPPEventListener;
import wrimsv2_plugin.debugger.model.WPPDebugTarget;
import wrimsv2_plugin.debugger.model.WPPValue;
import wrimsv2_plugin.debugger.view.WPPAllGoalView.ViewLabelProvider;
import wrimsv2_plugin.debugger.view.WPPAllVariableView.WPPComparator;
import wrimsv2_plugin.tools.ProcImage;
import wrimsv2_plugin.tools.ProcWatchItem;
import wrimsv2_plugin.tools.SearchTable;
import wrimsv2_plugin.tools.SetSelectionInTable;

public class WPPWatchView extends AbstractDebugView implements ISelectionListener { 
	private IValue[] dataStack=null;
	private ViewLabelProvider vlp;
	static public boolean isAscending=true;
	
	public class ViewLabelProvider implements ITableLabelProvider {

		@Override
		public void addListener(ILabelProviderListener listener) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void dispose() {
			ProcImage.disposeImages();
		}

		@Override
		public boolean isLabelProperty(Object element, String property) {
			// TODO Auto-generated method stub
			return false;
		}

		@Override
		public void removeListener(ILabelProviderListener listener) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public Image getColumnImage(Object element, int index) {
			if (index==0 && DebugCorePlugin.watchControlGoals.contains(((WPPValue)element).getVariableString())){
				return ProcImage.getControlImage();
			}else{
				return null;
			}
		}

		public String getColumnText(Object element, int index) {
			if (element instanceof WPPDebugTarget){
				return null;
			}else if (element instanceof WPPValue){
				try {
					if (((WPPValue) element).hasVariables()){
						if (index==0){
							return ((WPPValue) element).getVariableString();
						}else if (index==1){
							return ((WPPValue) element).getValueString();
						}else{
							return ProcessAltColumn.addAltColumnData(((WPPValue) element).getVariableString(), 1, index);
						}
					}else{
						if (index==0){
							return ((WPPValue) element).getVariableString();
						}else if (index==1){	
							return ((WPPValue) element).getValueString();
						}else{
							return ProcessAltColumn.addAltColumnData(((WPPValue) element).getVariableString(), 1, index);
						}
					}
				} catch (DebugException e) {
					WPPException.handleException(e);
				}
			}
			return null;
		}
		
	}
	
	class ViewContentProvider implements ITreeContentProvider {

		/* (non-Javadoc)
		 * @see org.eclipse.jface.viewers.ITreeContentProvider#getChildren(java.lang.Object)
		 */
		public Object[] getChildren(Object parentElement) {
			if (parentElement instanceof WPPDebugTarget) {
				return DebugCorePlugin.watchStack;
			} else if (parentElement instanceof WPPValue){
				try{
					if (((WPPValue)parentElement).hasVariables()){
						return ((WPPValue)parentElement).getValues();
					}
				}
				catch (DebugException e) {
					WPPException.handleException(e);
				}
			}
			return new Object[0];
		}

		/* (non-Javadoc)
		 * @see org.eclipse.jface.viewers.ITreeContentProvider#getParent(java.lang.Object)
		 */
		public Object getParent(Object element) {
			if (element instanceof IDebugTarget) {
				return null;
			} else if (((WPPValue)element).hasParentValue()) {
				return (((WPPValue)element).getParentValue());
			} else {
				return ((IDebugElement)element).getDebugTarget();
			}
		}

		/* (non-Javadoc)
		 * @see org.eclipse.jface.viewers.ITreeContentProvider#hasChildren(java.lang.Object)
		 */
		public boolean hasChildren(Object element) {
			if (element instanceof IDebugElement) {
				return getChildren(element).length > 0;
			}
			return false;
		}

		/* (non-Javadoc)
		 * @see org.eclipse.jface.viewers.IStructuredContentProvider#getElements(java.lang.Object)
		 */
		public Object[] getElements(Object inputElement) {
			return getChildren(inputElement);
		}

		/* (non-Javadoc)
		 * @see org.eclipse.jface.viewers.IContentProvider#dispose()
		 */
		public void dispose() {
		}

		/* (non-Javadoc)
		 * @see org.eclipse.jface.viewers.IContentProvider#inputChanged(org.eclipse.jface.viewers.Viewer, java.lang.Object, java.lang.Object)
		 */
		public void inputChanged(Viewer viewer, Object oldInput, Object newInput) {
		}
		
	}
	
	class WPPComparator extends ViewerComparator{
		@Override
		public int compare(Viewer viewer, Object e1, Object e2) {
			String s1 = vlp.getColumnText(e1, 0);
			String s2 = vlp.getColumnText(e2, 0);
			int c =s1.compareTo(s2);
			if (isAscending){
				return c;
			}else{
				return -c;
			}
		}
	}
	
	@Override
	protected Viewer createViewer(Composite parent) {
		final IWorkbench workbench=PlatformUI.getWorkbench();
		workbench.getDisplay().asyncExec(new Runnable(){
			public void run(){
				WPPVarDetailView varDetailView = (WPPVarDetailView) workbench.getActiveWorkbenchWindow().getActivePage().findView(DebugCorePlugin.ID_WPP_VARIABLEDETAIL_VIEW);
			}
		});
		
		TableViewer viewer = new TableViewer(parent);
		vlp=new ViewLabelProvider();
		viewer.setLabelProvider(vlp);
		viewer.setContentProvider(new ViewContentProvider());
		viewer.setComparator(new WPPComparator());
		getSite().setSelectionProvider(viewer);
		Table table = viewer.getTable();
	    new TableColumn(table, SWT.LEFT).setText("Variable/Goal");
	    new TableColumn(table, SWT.LEFT).setText("Value");
	    
	    // Pack the columns
	    for (int i = 0, n = table.getColumnCount(); i < n; i++) {
	    	table.getColumn(i).pack();
	    }
	    
	    // Turn on the header and the lines
	    table.setHeaderVisible(true);
	    table.setLinesVisible(true);
	    
	    TableCopyListener tcl=new TableCopyListener(table);
	    table.addKeyListener(tcl);
	    
	    UpdateView.addNameSortListener(table, this);

	    setInitialWatchVariables(table);
	    
	    // Pack the window
	    parent.pack();
	    
		return viewer;
	}

	public void setInitialWatchVariables(Table table){
		ArrayList<String> watchItems= ProcWatchItem.getLastWatchItems();
		DebugCorePlugin.watchItems = watchItems;
		int size = watchItems.size();
		for (int i=0; i<size; i++){
			String varGoalName=watchItems.get(i);
			TableItem item = new TableItem(table, SWT.NONE);
			String[] data=new String[2];
			data[0]=varGoalName;
			data[1]="";
			item.setText(data);
		}
	}
	
	@Override
	protected void createActions() {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected String getHelpContextId() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected void fillContextMenu(IMenuManager menu) {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected void configureToolBar(IToolBarManager tbm) {
		// TODO Auto-generated method stub
		
	}
	
	public void dispose() {
		getSite().getWorkbenchWindow().getSelectionService().removeSelectionListener(IDebugUIConstants.ID_DEBUG_VIEW, this);
		super.dispose();
	}
	/* (non-Javadoc)
	 * @see org.eclipse.ui.ISelectionListener#selectionChanged(org.eclipse.ui.IWorkbenchPart, org.eclipse.jface.viewers.ISelection)
	 */
	public void selectionChanged(IWorkbenchPart part, ISelection selection) {
	}
	
	public void updateView(){
		DebugCorePlugin.updateSelectedVariable=false;
		dataStack=DebugCorePlugin.watchStack;
		TableViewer viewer=(TableViewer) getViewer();
		IStructuredSelection oldSelection = ((IStructuredSelection)viewer.getSelection());
		Table table=viewer.getTable();
		table.removeAll();
		ProcessAltColumn.AdjustAltColumnNames(viewer, 1);
		viewer.setInput(DebugCorePlugin.target);
	    for (int i = 0, n = table.getColumnCount(); i < n; i++) {
	    	table.getColumn(i).pack();
	    }
		viewer.refresh();
		if (dataStack.length>0) new SetSelectionInTable(oldSelection, viewer, table);
		DebugCorePlugin.updateSelectedVariable=true;
	}
	
	public void addWatched(String varGoalName){
		TableViewer viewer=(TableViewer) getViewer();
		Table table=viewer.getTable();
		TableItem item = new TableItem(table, SWT.NONE);
		String[] data=new String[2];
		data[0]=varGoalName;
		data[1]="";
		item.setText(data);
	}
	
	public void deleteWatched(){
		TableViewer viewer=(TableViewer) getViewer();
		Table table=viewer.getTable();
		TableItem[] tis=table.getSelection();
		for (int i=0; i<tis.length; i++){
			TableItem ti=tis[i];
			String varGoalNameLowerCase=ti.getText(0).toLowerCase();
			DebugCorePlugin.watchItems.remove(varGoalNameLowerCase);
			ProcWatchItem.saveWatchItems(DebugCorePlugin.watchItems);
		}
		int[] indices = table.getSelectionIndices();
		table.remove(indices);
		if (table.getItemCount()>0){
			int selIndex;
			if (indices[0]==0){
				selIndex=0;
			}else{
				selIndex=indices[0]-1;
			}
			table.select(selIndex);
			TableItem ti = table.getItem(selIndex);
			String selVarGoalName=ti.getText(0);
			final ArrayList<String> selectedVariableNames=new ArrayList<String>();
			selectedVariableNames.add(selVarGoalName);
			if(!selectedVariableNames.equals(DebugCorePlugin.selectedVariableNames)){
				DebugCorePlugin.selectedVariableNames=selectedVariableNames;
				if (DebugCorePlugin.target !=null && DebugCorePlugin.target.isSuspended()){
					final IWorkbench workbench=PlatformUI.getWorkbench();
					workbench.getDisplay().asyncExec(new Runnable(){
						public void run(){
							IWorkbenchPage workBenchPage = workbench.getActiveWorkbenchWindow().getActivePage();
							WPPVarDetailView varDetailView=(WPPVarDetailView) workBenchPage.findView(DebugCorePlugin.ID_WPP_VARIABLEDETAIL_VIEW);
							varDetailView.updateDetailVariableView(selectedVariableNames);
						}
					});
				}
			}
		}
	}
	
	public void deleteAllWatched(){
		TableViewer viewer=(TableViewer) getViewer();
		Table table=viewer.getTable();
		DebugCorePlugin.watchItems=new ArrayList<String>();
		ProcWatchItem.saveWatchItems(DebugCorePlugin.watchItems);
		table.removeAll();
	}
	
	public void adjustAltColumnNames(){
		TableViewer viewer=(TableViewer) getViewer();
		ProcessAltColumn.AdjustAltColumnNames(viewer, 1);
	}
}
