#!../../bin/linux-x86_64/lakeshore336

## You may have to change lakeshore336 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase("$(TOP)/dbd/lakeshore336.dbd",0,0)
lakeshore336_registerRecordDeviceDriver(pdbbase) 

epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST" , "NO")
epicsEnvSet("EPICS_CA_ADDR_LIST"      , "10.23.0.255")
epicsEnvSet("STREAM_PROTOCOL_PATH"    , "$(TOP)/protocols")

drvAsynIPPortConfigure("LAKE1", "10.23.3.11:7777")
asynSetTraceMask("LAKE1", 0, 0x9)
asynSetTraceIOMask("LAKE1", 0, 0x2)
## Load record instances
dbLoadRecords("$(TOP)/db/lakeshore336_chan.db","Sys=XF:23ID1-ES,Dev={TCtrl:1-Chan:A},PORT=LAKE1,CHAN=A")
dbLoadRecords("$(TOP)/db/lakeshore336_chan.db","Sys=XF:23ID1-ES,Dev={TCtrl:1-Chan:B},PORT=LAKE1,CHAN=B")
dbLoadRecords("$(TOP)/db/lakeshore336_chan.db","Sys=XF:23ID1-ES,Dev={TCtrl:1-Chan:C},PORT=LAKE1,CHAN=C")
dbLoadRecords("$(TOP)/db/lakeshore336_chan.db","Sys=XF:23ID1-ES,Dev={TCtrl:1-Chan:D},PORT=LAKE1,CHAN=D")
dbLoadRecords("$(TOP)/db/lakeshore336_loop.db","Sys=XF:23ID1-ES,Dev={TCtrl:1-Out:1},PORT=LAKE1,CHAN=1")
dbLoadRecords("$(TOP)/db/lakeshore336_loop.db","Sys=XF:23ID1-ES,Dev={TCtrl:1-Out:2},PORT=LAKE1,CHAN=2")

asSetFilename("/epics/xf/23id/xf23id.acf")

system("install -m 777 -d $(TOP)/as/save") 
system("install -m 777 -d $(TOP)/as/req")

set_savefile_path("${TOP}/as","/save")
set_requestfile_path("${TOP}/as","/req")
set_pass0_restoreFile("info_positions.sav")
set_pass1_restoreFile("info_settings.sav")

iocInit()

caPutLogInit("xf23id-ca.cs.nsls2.local:7004", 0)

cd ${TOP}/as/req
makeAutosaveFiles()
create_monitor_set("info_positions.req", 5 , "")
create_monitor_set("info_settings.req", 15 , "")
