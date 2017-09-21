#!../../bin/linux-x86_64/lakeshore336

## You may have to change lakeshore336 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase("$(TOP)/dbd/lakeshore336.dbd",0,0)
lakeshore336_registerRecordDeviceDriver(pdbbase) 

epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST" , "NO")
epicsEnvSet("EPICS_CA_ADDR_LIST"      , "10.02.0.255") # really is 02, not 2
epicsEnvSet("STREAM_PROTOCOL_PATH"    , "$(TOP)/protocols")

drvAsynIPPortConfigure("LAKE1", "10.2.2.110:7777") 
#asynSetTraceMask("LAKE1", 0, 0x9)
#asynSetTraceIOMask("LAKE1", 0, 0x2)
#drvAsynIPPortConfigure("LAKE2", "10.2.2.111:7777") #
#asynSetTraceMask("LAKE2", 0, 0x9)
#asynSetTraceIOMask("LAKE2", 0, 0x2)
#drvAsynIPPortConfigure("LAKE3", "10.2.2.112:7777") #
#asynSetTraceMask("LAKE3", 0, 0x9)
#asynSetTraceIOMask("LAKE3", 0, 0x2)

## Load record instances
dbLoadTemplate("$(TOP)/db/lakeshore336.template")
dbLoadRecords("$(EPICS_BASE)/db/iocAdminSoft.db", "IOC=XF:02ID1-CT{IOC:TCTRL1}") #TODO set this up in CSS
#dbLoadRecords("$(TOP)/db/derivative.db", "Sys=XF:02ID-ES,Dev={TCtrl:1-Chan:A}") #this is for looking at derivative of temperature change.  It is not needed to be enabled for all controllers
#dbLoadRecords("$(TOP)/db/derivative.db", "Sys=XF:02ID-ES,Dev={TCtrl:1-Chan:B}")
dbLoadRecords("$(TOP)/db/asynRecord.db", "P=XF:02ID-OP{TCtrl:1},R=Asyn,PORT=LAKE1,ADDR=0,IMAX=100,OMAX=100")
#dbLoadRecords("$(TOP)/db/asynRecord.db", "P=XF:02ID-ES{TCtrl:1},R=Asyn,PORT=LAKE2,ADDR=0,IMAX=100,OMAX=100") 
#dbLoadRecords("$(TOP)/db/asynRecord.db", "P=XF:02ID-ES{TCtrl:2},R=Asyn,PORT=LAKE2,ADDR=0,IMAX=100,OMAX=100")

system("install -m 777 -d $(TOP)/as/save") 
system("install -m 777 -d $(TOP)/as/req")

set_savefile_path("${TOP}/as","/save")
set_requestfile_path("${TOP}/as","/req")
set_pass0_restoreFile("info_positions.sav")
set_pass1_restoreFile("info_settings.sav")

#asSetSiubstitutions("WS=csxws1")  #This is for access control at 23ID
#asSetFilename("/epics/xf/23id/xf23id.acf") #This is for access control at 23ID

iocInit()

#caPutLogInit("xf02id-ca1.cs.nsls2.local:7004", 0)  #TODO this is enabled at CSX. is this correct for 2ID - what does this do

cd ${TOP}/as/req
makeAutosaveFiles()
create_monitor_set("info_positions.req", 5 , "")
create_monitor_set("info_settings.req", 15 , "")

dbl > ${TOP}/records.dbl
system("cp ${TOP}/records.dbl /cf-update/xf02id1-ioc1.lakeshore336.dbl")
