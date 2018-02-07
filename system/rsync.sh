#!/bin/bash
#rsync日常传输备份
/usr/bin/rsync -av /opt/databak/*$(date -d "yesterday" +"%Y%m%d")* /databak/MySQL/database/10.30.105.17__18/ > /dev/null 2>&1
