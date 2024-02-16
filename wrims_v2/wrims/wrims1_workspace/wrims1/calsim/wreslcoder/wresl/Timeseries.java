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


package calsim.wreslcoder.wresl;

/**
 *	Contains parser parameters associated with input DSS timeseries variables.
 * @author Armin Munevar
 * @version $Id: Timeseries.java,v 1.1.2.3 2001/07/12 02:00:10 amunevar Exp $
 */
public class Timeseries {

//	private String _name,_bpart,_cpart,_units,_convert;
	private String _name,_units,_convert;


    /**
      * Creates a new instance with default values
      */
    public Timeseries() {
        _name = new String();
//		_bpart = new String();
//		_cpart = new String();
		_units = new String("UNKNOWN");
		_convert = new String("UNKNOWN");
    }

    /**
      * Creates a new instance with specified name, bpart, cpart, units, and convert units
      */
    public Timeseries (String name, String bpart, String cpart, String units, String convert) {
        _name = name.toUpperCase();
//		_bpart = bpart.toUpperCase();
//		_cpart = cpart.toUpperCase();
		_units = units.toUpperCase();
		_convert = convert.toUpperCase();
    }

    /**
      * Sets name of timeseries
      */
	public void setName(String name) {
		_name = name.toUpperCase();
	}

    /**
      * Sets units of timeseries
      */
	public void setUnits(String units) {
		_units = units.toUpperCase();
	}

    /**
      * Sets conversion units for timeseries
      */
	public void setConvert(String convert) {
		_convert = convert.toUpperCase();
	}

    /**
      * Gets name of timeseries
      */
	public String getName() {
		return _name;
	}

    /**
      * Gets units of timeseries
      */
	public String getUnits() {
		return _units;
	}

    /**
      * Gets conversion units for timeseries
      */
	public String getConvert() {
		return _convert;
	}

}