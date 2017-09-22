


def lakeshore_curv(num, name, sens, temp, sens_frmt, tempMAX=None, sn='STD'):
    '''Create calibration curve information.
    num:\t calibration curve number on the lakeshore (21 - 59)
    name:\t calibration curve name to write to the lakeshore (15 characters)
    sens:\t sensor data  (e.g., resistance) (200 points max)
    temp:\t temperature data (200 points max)
    sens_frmt:\t format of sensor data. 1 = mV/K, 2=V/K,3=Ohm.K,4=log(Ohm)/K
    tempMAX:\t maximum temperature to extrapolate
    sn:\t sensor serial number to write to the lakeshore (standard = STD)
    '''
    out = []
    if tempMAX == None:
        t_max = int(max(temp))+1
        print(t_max,'is the configured maximum temperature for extrapolation')
    else:
        t_max=tempMAX
    s = 'CRVDEL {}'.format(num)
    out.append(s)
    s = 'CRVHDR {},{},{},4,{},1'.format(num, name, sn,t_max)
    out.append(s)
    for i, (s, t) in enumerate(zip(sens, temp)):
        #s = 'CRVPT {},{},{:.6G},{:.6G}'.format(num, i+1, np.log10(s), t)
        s = 'CRVPT {},{},{:.6G},{:.6G}'.format(num, i+1, s, t)
        out.append(s)
    return out

def put_data(pv, data):
    #epics.caput("{}.OEOS".format(pv+'Asyn'), r'\r\n') #DONT USE.  GOOD REFERENCE FOR OTHER DEVICE
    #epics.caput("{}.IEOS".format(pv+'Asyn'), r'\r\n') #DONT USE.  GOOD REFERENCE FOR OTHER DEVICE
    epics.caput("{}.TMOD".format(pv+'Asyn'), 1)
    epics.caput("{}.TMOT".format(pv+'Asyn'), 10)
    for d in data:
        epics.caput("{}.AOUT".format(pv+'Asyn'), d)
        ttime.sleep(1)
        
# import tqdm
# def put_data2(pv, data):
#     #epics.caput("{}.OEOS".format(pv+'Asyn'), r'\r\n')
#     #epics.caput("{}.IEOS".format(pv+'Asyn'), r'\r\n')
#     epics.caput("{}.TMOD".format(pv+'Asyn'), 1)
#     epics.caput("{}.TMOT".format(pv+'Asyn'), 10)
#     for d in tqdm.tqdm(data):
#         epics.caput("{}.AOUT".format(pv+'Asyn'), d)
#         ttime.sleep(1)

# def lakeshore_curv_qu(num,pt=None):
#     data_out = []
#     data_out.append(epics.caget("{}.AOUT".format(pv+'Asyn'),num))
#     if pt == None:

