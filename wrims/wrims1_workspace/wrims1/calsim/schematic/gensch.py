# generates a schematic file from a connectivity file with
# node x,y positions available in the connectivity file
sys.add_package('calsim.gym')
from calsim.gym import Network, Arc, Node
from java.util import Date
from calsim.gym import Arc, ChannelArc, DemandArc, ReturnArc, InputArc
from calsim.gym import Node, BoundaryNode
import string
cfile = 'test1-connectivity.csv'
net1 = Network.read(cfile)
f=open(cfile,'r')
outf = open('test1-auto-schematic.csv','w')
outf.write("#Auto generated by gensch.py @ ")
outf.write(repr(Date()))
outf.write("\n")
outf.write("# min max info\n")
outf.write("# Schematic information\n")
outf.write("Label\t\tSymbol\t\tX1\tY1\tX2|W\tY2|H\n")
outf.write("# all junction/storage nodes\n")
lines = f.readlines()
header_found = 0
nxy = {}
for line in lines:
    if header_found:
        sa = string.split(line,",")
        try :
            string.atoi(sa[0])
            if len(sa) != 9:
                print "Not enough tokens for line : " + line
                continue
        except:
            continue
        for i in range(len(sa)):
            sa[i] = string.strip(sa[i])
        outf.write(sa[0])
        outf.write("\t\t")
        if string.find(sa[3],"S") >= 0 :
            outf.write("storage\t\t")
        else:
            outf.write("junction\t")
        outf.write(sa[5])
        outf.write("\t")
        outf.write(sa[6])
        outf.write("\t")
        outf.write(sa[7])
        outf.write("\t")
        outf.write(sa[8])
        outf.write("\n")
        nxy.update({sa[0]:(sa[5],sa[6])})
    if (string.find(line,"Node No.") >= 0) : header_found = 1
#        
outf.write("# flows etcetra\n")
arcs = net1.getAllArcs()
for arc in arcs:
    if isinstance(arc,StorageArc):
        continue
    if isinstance(arc,FloodArc):
        continue
    outf.write(arc.getName())
    outf.write("\t\t")
    if isinstance(arc,ChannelArc):
        outf.write("flow")
    elif isinstance(arc,DemandArc):
        outf.write("demand")
    elif isinstance(arc,InputArc):
        outf.write("inflow")
    else:
        outf.write("flow")
    outf.write("\t\t")
    un = arc.getUpstreamNode()
    dn = arc.getDownstreamNode()
    if isinstance(un,BoundaryNode):
        outf.write("--\t--\t")
    else:
        nid = un.getId()
        x,y=nxy[repr(nid)]
        outf.write(x)
        outf.write("\t")
        outf.write(y)
        outf.write("\t")
    if isinstance(dn,BoundaryNode):
        outf.write("--\t--\t")
    else:
        nid = dn.getId()
        x,y = nxy[repr(nid)]
        outf.write(x)
        outf.write("\t")
        outf.write(y)
        outf.write("\t")
    outf.write("\n")
#
    
