package gov.ca.dwr.hecdssvue.views;

import gov.ca.dwr.hecdssvue.PluginCore;
import gov.ca.dwr.hecdssvue.actions.ReportButtonAction;
import gov.ca.dwr.hecdssvue.actions.ReportCheckBoxAction;
import hec.io.DataContainer;

import java.awt.Component;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JPanel;
import javax.swing.JScrollPane;

import org.eclipse.swt.widgets.Composite;

public class DeliveryShortagesView extends AbstractCalSimView{

	public static String ID="gov.ca.dwr.hecdssvue.views.DeliveryShortagesView";
	private Component[] components = new Component[0];
	
	public DeliveryShortagesView(){
	
	}

	
	public void createPartControl(Composite parent){
		super.createPartControl(parent);
		JPanel panel = (JPanel)PluginCore.swix.find("DShort");
		contentPane.add(new JScrollPane(panel));
		components = panel.getComponents();
		for (int i = 0; i < components.length; i++) {
			if (components[i] instanceof JCheckBox) {
				JCheckBox c = (JCheckBox) components[i];
				c.addActionListener(new ReportCheckBoxAction());
			}else if (components[i] instanceof JButton){
				JButton b = (JButton) components[i];
				b.addActionListener(new ReportButtonAction());
			}
		}
	}

	public void clearAll(){
		for (int i = 0; i < components.length; i++) {
			if (components[i] instanceof JCheckBox) {
				JCheckBox c = (JCheckBox) components[i];
				c.setSelected(false);
			}
		}
	}
}
