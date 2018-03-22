#!/usr/bin/python
# -*- coding: utf-8 -*-

import redis,types,json

r = redis.Redis(host='*.*.*.*',port=6379,db=1,password='password')

DelTol = 0

def clearzset(strkey):
    global DelTol
    zarry = r.keys( strkey )
    for k in zarry:
        resarry = r.zrange(k,0,-1,False,True)

        score = 0
        index = 0
        for a in resarry:
            if score == int(a[1]):
                index = z.zrangk(k, a[0])
                print (k, int(a[1]), index)
                r.zremrangebyrank(k,index,index)
                DelTol = DelTol +1
            else:
                score = int(a[1])

clearzset("zset")

if __name__ == '__main__':
    print ("sum", DelTol)
