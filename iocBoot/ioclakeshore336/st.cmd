#!../../bin/linux-x86_64/lakeshore336

## You may have to change lakeshore336 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase("$(TOP)/dbd/lakeshore336.dbd",0,0)
lakeshore336_registerRecordDeviceDriver(pdbbase) 

epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST" , "NO")
epicsEnvSet("EPICS_CA_ADDR_LIST"      , "10.23.0.255") #TODO change IP address for changel access - is it simple 10.02.0.255
epicsEnvSet("STREAM_PROTOCOL_PATH"    , "$(TOP)/protocols")

drvAsynIPPortConfigure("LAKE1", "10.23.3.11:7777") #TODO change IP addresses for each LAKE
#asynSetTraceMask("LAKE1", 0, 0x9)
#asynSetTraceIOMask("LAKE1", 0, 0x2)
#drvAsynIPPortConfigure("LAKE2", "10.23.3.10:7777") #TODO this is for ES controller.  don't enable next two lines.
#asynSetTraceMask("LAKE2", 0, 0x9)
#asynSetTraceIOMask("LAKE2", 0, 0x2)

## Load record instances
dbLoadTemplate("$(TOP)/db/lakeshore336.template")
dbLoadRecords("$(EPICS_BASE)/db/iocAdminSoft.db", "IOC=XF:02ID1-CT{IOC:TCTRL1}") #TODO this is 02ID1.  change it?
#dbLoadRecords("$(TOP)/db/derivative.db", "Sys=XF:02ID-ES,Dev={TCtrl:1-Chan:A}") #TODO this is for looking at derivative of temperature change.  It is not needed to be enabled for all controllers
#dbLoadRecords("$(TOP)/db/derivative.db", "Sys=XF:02ID-ES,Dev={TCtrl:1-Chan:B}")
dbLoadRecords("$(TOP)/db/asynRecord.db", "P=XF:02ID-OP{TCtrl:1},R=Asyn,PORT=LAKE1,ADDR=0,IMAX=100,OMAX=100")
#dbLoadRecords("$(TOP)/db/asynRecord.db", "P=XF:02ID-ES{TCtrl:1},R=Asyn,PORT=LAKE2,ADDR=0,IMAX=100,OMAX=100")

system("install -m 777 -d $(TOP)/as/save") 
system("install -m 777 -d $(TOP)/as/req")

set_savefile_path("${TOP}/as","/save")
set_requestfile_path("${TOP}/as","/req")
set_pass0_restoreFile("info_positions.sav")
set_pass1_restoreFile("info_settings.sav")

#asSetSiubstitutions("WS=csxws1")  #TODO what does this do? is enabled at CSX
#asSetFilename("/epics/xf/23id/xf23id.acf") #TODO  where is the access control files for 2id  or was this enabled at CSX by mistake.  I think only EPU have acf that are utilized.

iocInit()

#caPutLogInit("xf23id-ca.cs.nsls2.local:7004", 0)  #TODO this is enabled at CSX. what is it for 2id

cd ${TOP}/as/req
makeAutosaveFiles()
create_monitor_set("info_positions.req", 5 , "")
create_monitor_set("info_settings.req", 15 , "")

dbl > ${TOP}/records.dbl
system("cp ${TOP}/records.dbl /cf-update/xf02id1-ioc1.lakeshore336.dbl")
