#!../../bin/linux-x86_64/lakeshore336

## You may have to change lakeshore336 to something else
## everywhere it appears in this file

< envPaths
< /epics/common/xf23id1-ioc3-netsetup.cmd

cd ${TOP}

## Register all support components
dbLoadDatabase("$(TOP)/dbd/lakeshore336.dbd",0,0)
lakeshore336_registerRecordDeviceDriver(pdbbase) 

epicsEnvSet("STREAM_PROTOCOL_PATH"    , "$(TOP)/protocols")

drvAsynIPPortConfigure("LAKE1", "xf23id1-ls336-2.nsls2.bnl.local:7777")
#asynSetTraceMask("LAKE1", 0, 0x9)
#asynSetTraceIOMask("LAKE1", 0, 0x2)
drvAsynIPPortConfigure("LAKE2", "xf23id1-ls336-1.nsls2.bnl.local:7777")
#asynSetTraceMask("LAKE2", 0, 0x9)
#asynSetTraceIOMask("LAKE2", 0, 0x2)
drvAsynIPPortConfigure("LAKE3", "xf23id1-ls336-3.nsls2.bnl.local:7777")
#asynSetTraceMask("LAKE3", 0, 0x9)
#asynSetTraceIOMask("LAKE3", 0, 0x2)
#drvAsynIPPortConfigure("LAKE4", "xf23id1-ls336-3.nsls2.bnl.local:7777")
#asynSetTraceMask("LAKE4", 0, 0x9)
#asynSetTraceIOMask("LAKE4", 0, 0x2)

## Load record instances
dbLoadTemplate("$(TOP)/db/lakeshore336.template")
dbLoadRecords("$(EPICS_BASE)/db/iocAdminSoft.db", "IOC=XF:23ID1-CT{IOC:TCTRL1}")
dbLoadRecords("$(TOP)/db/derivative.db", "Sys=XF:23ID1-ES,Dev={TCtrl:1-Chan:A},DevSP={TCtrl:1-Out:1}")
dbLoadRecords("$(TOP)/db/derivative.db", "Sys=XF:23ID1-ES,Dev={TCtrl:1-Chan:B},DevSP={TCtrl:1-Out:1}")
dbLoadRecords("$(TOP)/db/asynRecord.db", "P=XF:23ID1-ES{TCtrl:1},R=Asyn,PORT=LAKE1,ADDR=0,IMAX=100,OMAX=100")
dbLoadRecords("$(TOP)/db/asynRecord.db", "P=XF:23ID1-ES{TCtrl:2},R=Asyn,PORT=LAKE2,ADDR=0,IMAX=100,OMAX=100")
dbLoadRecords("$(TOP)/db/asynRecord.db", "P=XF:23ID1-OP{TCtrl:1},R=Asyn,PORT=LAKE3,ADDR=0,IMAX=100,OMAX=100")
#dbLoadRecords("$(TOP)/db/asynRecord.db", "P=XF:23ID1-OP{TCtrl:2},R=Asyn,PORT=LAKE4,ADDR=0,IMAX=100,OMAX=100")

system("install -m 777 -d $(TOP)/as/save") 
system("install -m 777 -d $(TOP)/as/req")

set_savefile_path("${TOP}/as","/save")
set_requestfile_path("${TOP}/as","/req")
set_pass0_restoreFile("info_positions.sav")
set_pass1_restoreFile("info_settings.sav")

asSetSubstitutions("WS=csxws1")
asSetFilename("/epics/common/xf23id.acf")

iocInit()

caPutLogInit("xf23id-ca.cs.nsls2.local:7004", 0)

cd ${TOP}/as/req
makeAutosaveFiles()
create_monitor_set("info_positions.req", 5 , "")
create_monitor_set("info_settings.req", 15 , "")

dbl > ${TOP}/records.dbl
system("cp ${TOP}/records.dbl /cf-update/xf23id1-ioc3.es-tctrl1.dbl")
