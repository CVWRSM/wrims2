/*

Copyright (C) 1998, 2000 State of California, Department of Water Resources.

This program is licensed to you under the terms of the GNU General Public
License, version 2, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License along
with this program; if not, contact Dr. Sushil Arora, below, or the
Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

THIS SOFTWARE AND DOCUMENTATION ARE PROVIDED BY THE CALIFORNIA DEPARTMENT
OF WATER RESOURCES AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE CALIFORNIA DEPARTMENT OF WATER RESOURCES OR ITS
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OR SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

For more information, contact:

Dr. Sushil Arora
California Dept. of Water Resources
Office of State Water Project Planning, Hydrology and Operations Section
1416 Ninth Street
Sacramento, CA  95814
916-653-7921
sushil@water.ca.gov

*/

package calsim.gui;
import calsim.app.*;
import java.awt.event.*;
import java.util.Arrays;
import java.util.Comparator;
import javax.swing.*;
import javax.swing.event.*;
/**
  * Creates the DTS menu list dynamically from the current project's list
  *
  * @author Nicky Sandhu
  * @version $Id: DTSMenuListener.java,v 1.1.2.5 2000/12/20 20:07:03 amunevar Exp $
  */
public class DTSMenuListener implements MenuListener{
  ActionListener _al;
  Comparator _comp;
  /**
    *
    */
  public DTSMenuListener(ActionListener al){
    _al = al;
    _comp = new DTSComparator();
  }
  /**
    * Invoked when a menu item is selected.
    *
    * @param e  a MenuEvent object
    */
  public void menuSelected(MenuEvent e){
    JMenu menu = (JMenu) e.getSource();
    menu.removeAll();
    Project prj = AppUtils.getCurrentProject();
    DerivedTimeSeries [] dtsList = prj.getDTSList();
    if ( dtsList == null ) return;
    Arrays.sort(dtsList,_comp);
    for(int i=0; i < dtsList.length; i++){
      JMenuItem mi = new JMenuItem(dtsList[i].getName());
      mi.addActionListener(_al);
      menu.add(mi);
    }
  }
  /**
    * Invoked when the menu selection changes.
    *
    * @param e  a MenuEvent object
    */
  public void menuDeselected(MenuEvent e){
  }
  /**
    * Invoked when the menu selection is canceled.
    *
    * @param e  a MenuEvent object
    */
  public void menuCanceled(MenuEvent e){
  }
}
