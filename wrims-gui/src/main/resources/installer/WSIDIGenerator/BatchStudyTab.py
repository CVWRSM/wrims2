#     Name: BatchStudyTab.py
#   Author: Hao Xie
#   E-mail: hxie@water.ca.gov
#    Phone: 916.653.1072
# Last Rev: 2024.11.06 - zachary.roy@water.ca.gov
#  Purpose: Batch StudyTab

# python modules
import shutil
import os
import subprocess

#CalsimWsiDi class imports
from BatchWsiDiGen import *

# java class imports - standard
from java.awt import *
from java.awt.event import *
from java.io import *
from java.util import *
from javax.swing import *
from java.lang import *

tab = "   "

# StudyTabCl class
class StudyTabCl:

   # constructor: initialize class parameters
   def __init__(self):

      # assign other class variables
      self.report = True

      #These are user options found in the WRIMS GUI.
      self.hideWarnings = True
      self.hideProgressDetails = False

   ### FUNCTIONS

   # function to run CALSIM
   def execute(self):
      print tab+ "Running Model"
   
      subprocess.call('WRIMSv2_Engine.bat')
      return 0

   # run WSI-DI procedure
   def runForWsi(self,studyDvNames,crvName,crvWsiVar,crvDiVar,crvMax,lookupNames,launchNames,offsets):

      print "Set parameters"

      newPath = os.path.join('..','')
      os.chdir(newPath)

      # number of Calsim runs needed (convergence)
      numRun = 3

      # establish variable for WsiDiGenerator (WRIMS java class)
      wd = []

      # instantiate WsiDiGenerator for each curve to be generated.
      for k in range(len(studyDvNames)):
         for i in range(len(crvName)):
            wd.append(WsiDiGenCl(crvName[i],crvWsiVar[i],crvDiVar[i],crvMax[i],studyDvNames[k],lookupNames[k],launchNames[k],offsets[k]))

      print "finished set parameters"
      
      # run CALSIM and extract wsi-di data points for curve generation
      for i in range(0,numRun):
         print "Start iteration " + str(i+1)

         # save initial wsi-di tables.  Table will be appended with "_0" if it's the first guess.  "_1" if it's the first curve generated by WSI-DI and so on.
         for k in range(len(studyDvNames)):
            for j in range(len(crvName)):
               tblName = lookupNames[k] + File.separator + "wsi_di_" + wd[j+k*len(crvName)].name.lower() + ".table"
               if (File(tblName).exists()):
                  tblNameSave = tblName[:-6] + "_"+str(i)+tblName[-6:]
                  shutil.copy(tblName,tblNameSave) #copy file

         # run CALSIM and check status
         if(self.execute() !=0):
            break

         # load wsi-di data and fit curve
         for k in range(len(studyDvNames)):
            for j in range(len(crvName)):
               wd[j+k*len(crvName)].load(studyDvNames[k])
               wd[j+k*len(crvName)].execute()

         print ""
         
         # save DSS as separate file name.  The DV file name is appended with the same integer as the WSI-DI curves upon which they depended.
         # For instance, the initial WSI-DI curves are saved as "_0".  The first iteration DV file is also labeled "_0".
         for k in range(len(studyDvNames)):
            studyDvName=studyDvNames[k]
            if (i<numRun-1):
               dvNameSave = studyDvName[:-4] + "_"+str(i)+studyDvName[-4:]
               shutil.copy(studyDvName,dvNameSave) #copy file
