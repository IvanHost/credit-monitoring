echo ���ݵ�ǰ����ʱ�䣬�����ļ����ƣ�......  
set YYYYmmdd=%date:~0,4%%date:~5,2%%date:~8,2%
set hhmiss=%time:~0,2%%time:~3,2%%time:~6,2%


kitchen -file %CREDIT_MONITOR_HOME%/run.kjb -level Debug -logfile %CREDIT_MONITOR_HOME%\logs\log_%YYYYmmdd%%hhmiss%.log
pause