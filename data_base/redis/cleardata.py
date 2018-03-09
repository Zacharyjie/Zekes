#!/usr/bin/python
# -*- coding: utf-8 -*-
import json,os

dict_Code_did={}
gDel = 0
gTol = 0

def parseJson(strpath):
    js = json.load(open(strpath,"r"))
    return js

def makedir(strDir):
    if os.path.exists(strDir) == True:
        return
    try:
        os.makedirs(strDir)
    except IOError,e:
        print e
    else:
        print strDir + " is exist"

def fiterFile(strDir,ibasedid,orgid):
    global gDel,gTol
    # dat
    srcDir = strDir + "dat/"
    bakDir = strDir + "dat_bak/"

    isignDel = 0
    isignTol = 0

    makedir(bakDir)

    for p,dirs,files in os.walk(srcDir):
        for fn in files:
            fname = fn[0:len(fn)-4]
            fpath = os.path.join(p,fn)

            isignTol = isignTol + 1
            gTol = gTol + 1

            # 没查询到fname
            if dict_Code_did.has_key( fname ) == False:
                #cmmd = 'cp -f ' + fpath + " " + bakDir
                cmmd = 'mv -f ' + fpath + " " + bakDir
                os.system( cmmd )
                print fpath + " not exist"
                isignDel = isignDel + 1
                gDel = gDel + 1
            else:
                print fpath + " exist"

    ##os.system('rm -rf ' + bakDir)
    print '[dat], id=[',orgid,'], total=[',isignTol,'], del=[',isignDel,']'


    # idx
    isignDel = 0
    isignTol = 0
    srcDir = strDir + "idx/"
    bakDir = strDir + "idx_bak/"

    makedir(bakDir)

    for p,dirs,files in os.walk(srcDir):
        for fn in files:
            fname = fn[0:len(fn)-4]
            fpath = os.path.join(p,fn)

            isignTol = isignTol + 1
            gTol = gTol + 1

            # 没查询到fname
            if dict_Code_did.has_key( fname ) == False:
                #cmmd = 'cp -f ' + fpath + " " + bakDir
                cmmd = 'mv -f ' + fpath + " " + bakDir
                os.system( cmmd )
                print fpath + " not exist"
                isignDel = isignDel + 1
                gDel = gDel + 1
            else:
                print fpath + " exist"

    ##os.system('rm -rf ' + bakDir)
    print '[idx], id=[',orgid,'], total=[',isignTol,'], del=[',isignDel,']'



if __name__=="__main__":
    print 'do main'
    dict_Code_did=parseJson('./info.json')

    print type(dict_Code_did)
    print dict_Code_did.has_key("09879999")

    print '--------------start--------------'

    fiterFile("/home/IB0011/100104/", 100004, 100104)
    fiterFile("/home/IB0011/100204/", 100004, 100204)
    fiterFile("/home/IB0011/100200/", 100004, 100200)

    print 'total ', gTol, ' del ', gDel
    print '----------end----------'

