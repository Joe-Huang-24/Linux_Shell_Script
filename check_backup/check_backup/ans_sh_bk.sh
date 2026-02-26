#!/bin/bash

ansible Product -i inventory -m shell -a 'python /mis_daily_check/py/check_backup_v2.py'
