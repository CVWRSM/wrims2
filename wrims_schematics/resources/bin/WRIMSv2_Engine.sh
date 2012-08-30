#!/bin/bash

# declare EXTERNALFOLDER variable
EXTERNALFOLDER="/home/hxie/fam/external"
MAINFILE="/home/hxie/fam/main_bo_fam_longterm_notarget_fixcvp.wresl"
SVFILE="/home/hxie/fam/dss/cl_future_bo_011012_sv.dss"
INITFILE="/home/hxie/fam/dss/callite2020d09einit.dss"
DVFILE="/home/hxie/fam/dss/testdv.dss"

PATH=/home/hxie/wrimsv2_SG/bin/lib:$path
PATH=$EXTERNALFOLDER:$path
export PATH

/home/hxie/wrimsv2_SG/jre6/bin/java -Xmx1600m -Xss1024K -Duser.timezone=UTC -Djava.library.path=$EXTERNALFOLDER:/home/hxie/wrimsv2_SG/bin/../lib -cp "$EXTERNALFOLDER:/home/hxie/wrimsv2_SG/bin/../lib/external:/home/hxie/wrimsv2_SG/bin/../lib/WRIMSv2.jar:/home/hxie/wrimsv2_SG/bin/../lib/XAOptimizer.jar:/home/hxie/wrimsv2_SG/bin/../lib/gurobi.jar:/home/hxie/wrimsv2_SG/bin/../lib/heclib.jar:/home/hxie/wrimsv2_SG/bin/../lib/jnios.jar:/home/hxie/wrimsv2_SG/bin/../lib/jpy.jar:/home/hxie/wrimsv2_SG/bin/../lib/misc.jar:/home/hxie/wrimsv2_SG/bin/../lib/pd.jar:/home/hxie/wrimsv2_SG/bin/../lib/commons-io-2.1.jar:/home/hxie/wrimsv2_SG/bin/../lib/javatuples-1.2.jar:/home/hxie/wrimsv2_SG/bin/../lib/guava-11.0.2.jar:/home/hxie/wrimsv2_SG/bin/../lib/vista.jar" wrimsv2.components.ControllerSG / $MAINFILE $SVFILE $INITFILE $DVFILE 2020D09E 2020D09E CALSIM 1MON 1921 10 31 2003 9 30 XA csv 
exit