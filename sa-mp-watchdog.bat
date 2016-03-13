@ECHO OFF
TITLE SA-MP Watchdog
COLOR 09

SET option_log=0

SET folder=Server
SET file_1=server_log.txt
SET file_2=%folder%\server.log
SET file_3=%folder%\restarter.log
SET file_4=%folder%\reset.reg
SET server=samp-server.exe
SET count=0
SET regkey="HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug"



IF NOT EXIST %server% (

	COLOR 0C
	ECHO %server% was not found!
	ECHO Press any key to exit.
	PAUSE > NUL
	GOTO EOF
)



IF NOT EXIST %folder% MD %folder%



IF NOT EXIST %file_4% (

	REG EXPORT %regkey% %file_4% > NUL
	REG ADD %regkey% /V Auto /D 1 /F > NUL
	REG ADD %regkey% /V Debugger /D 0 /F > NUL
)



:START

	CLS & ECHO.

	SET hh=%time:~0,2%

	IF %hh% LSS 10 SET hh=0%time:~1,1%

	SET msg=[%date%][%hh%:%time:~3,5%] Server

	IF %count% EQU 0 (SET msg=%msg% started.) ELSE SET msg=%msg% restarted [%count%x].

	ECHO  %msg% & ECHO %msg%>> %file_3%

	IF %option_log% EQU 1 (

		ECHO %msg%>> %file_2%
		TYPE %file_1%>> %file_2%
		FOR /L %%i IN (1,1,4) DO ECHO.>> %file_2%
	)

	GOTO NEXT



:NEXT

	SET /A count+=1
	CALL %server%
	GOTO START



:EOF