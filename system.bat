REM Last-ик ActivityView
COLOR 0B
netsh winsock reset
netsh winsock reset catalog
netsh int ip reset
netsh advfirewall reset
netsh int reset all
netsh int ipv4 reset
netsh int ipv6 reset
ipconfig / release
ipconfig / renew
ipconfig / flushdns

@ECHO OFF
title dont close while cleaning // @ecisowned

REM Надеюсь, сохранить файл в кодировке DOS-866 не забыли

CHCP 866



REM Зеленый на черном - интригующе... опять же, хакеры и все такое

COLOR 0B



CLS



FOR /F "tokens=1,2*" %%V IN ('bcdedit') DO SET adminTest=%%V

	IF (%adminTest%)==(Отказано) GOTO errNoAdmin

	IF (%adminTest%)==(Access) GOTO errNoAdmin



ECHO.



	ECHO.

	ECHO ОЧИСТКА ВСЕХ ЖУРНАЛОВ Windows

	FOR /F "tokens=*" %%G in ('wevtutil.exe el') DO (call :do_clear "%%G")

	ECHO.

	ECHO Выполнено

	ECHO.

ECHO.

ECHO ОЧИСТКА ИСТОРИИ ShellBag - реестр

REG DELETE "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" /va /f

REG DELETE "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f

REG DELETE "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f

REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\BagMRU" /f

REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Bags" /f

ECHO.



ECHO.

ECHO ОЧИСТКА ИСТОРИИ Explorer - реестр

REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f

ECHO.

REM ------------------------------------------------------------------------------------------





REM ------------------------------------------------------------------------------------------

REM ComDlg32. История диалогов "открыть\сохранить" и "последних мест посещений"

REM утилиты NirSoft - LastActivityView

ECHO.

ECHO ОЧИСТКА ИСТОРИИ OpenSave и LastVisited - реестр

REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\FirstFolder" /va /f

REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU" /va /f

REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRULegacy" /va /f

REM (утилиты NirSoft - OpenSaveFilesView)

REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU" /f

REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU"

ECHO.

REM ------------------------------------------------------------------------------------------





REM ------------------------------------------------------------------------------------------

REM если пользователь выбрал в меню не 1 т.е. 2 или 3



	REM UserAssist. Очистка списока запущенных программ в меню "Пуск"

	REM утилиты NirSoft - UserAssistView

	ECHO.	

	ECHO ОЧИСТКА ИСТОРИИ UserAssist - реестр

	REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist" /f

	REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist"

	ECHO.





REM ------------------------------------------------------------------------------------------

REM AppCompatCache

ECHO.

ECHO ОЧИСТКА ИСТОРИИ AppCompatCache - реестр

REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache" /va /f

REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\AppCompatCache" /va /f

ECHO.

REM ------------------------------------------------------------------------------------------





REM ------------------------------------------------------------------------------------------

REM DiagnosedApplications. Диагностика утечек памяти в приложении ОС Windows

ECHO.

ECHO ОЧИСТКА ИСТОРИИ DiagnosedApplications - реестр

REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RADAR\HeapLeakDetection\DiagnosedApplications" /f

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RADAR\HeapLeakDetection\DiagnosedApplications"

ECHO.

REM ------------------------------------------------------------------------------------------





REM ------------------------------------------------------------------------------------------

REM Получение SID - идентификатор безопасности текущего пользователя 

FOR /F "tokens=2" %%i IN ('whoami /user /fo table /nh') DO SET usersid=%%i

REM ------------------------------------------------------------------------------------------





REM ------------------------------------------------------------------------------------------

REM Search. История поиска 

ECHO.

ECHO ОЧИСТКА ИСТОРИИ Search - реестр

	REG DELETE "HKEY_USERS\%usersid%\Software\Microsoft\Windows\CurrentVersion\Search\RecentApps" /f

	REG ADD "HKEY_USERS\%usersid%\Software\Microsoft\Windows\CurrentVersion\Search\RecentApps"

ECHO.

REM ------------------------------------------------------------------------------------------





REM ------------------------------------------------------------------------------------------

REM BAM. 

REM По идее, при перезагрузке затрется само.  

REM Но можно сделать отдельный bat и запускать, например, после работы с portable-приложениями

ECHO.

ECHO ОЧИСТКА ИСТОРИИ службы Background Activity Moderator - реестр

REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\bam\UserSettings\%usersid%" /va /f

REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\bam\UserSettings\%usersid%" /va /f

ECHO.

REM ------------------------------------------------------------------------------------------





REM ------------------------------------------------------------------------------------------

REM AppCompatFlags

ECHO.

ECHO ОЧИСТКА ИСТОРИИ AppCompatFlags - реестр

REM утилиты NirSoft - ExecutedProgramsList

REG DELETE "HKEY_USERS\%usersid%\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store" /va /f



	REG DELETE  "HKEY_USERS\%usersid%\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /va /f

ECHO.

REM ------------------------------------------------------------------------------------------





REM ------------------------------------------------------------------------------------------

REM История "монтирования" дисков в т.ч. и TrueCrypt

ECHO.

ECHO ОЧИСТКА ИСТОРИИ MountedDevices - реестр

ECHO.

REG DELETE "HKEY_USERS\%usersid%\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2" /f

REG ADD "HKEY_USERS\%usersid%\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2"

ECHO.

REM ------------------------------------------------------------------------------------------





REM ------------------------------------------------------------------------------------------

REM Очистка списков быстрого перехода

ECHO.

REM утилиты NirSoft - JumpListsView, RecentFilesView

ECHO ОЧИСТКА ИСТОРИИ Recent - файловая система

DEL /f /q %APPDATA%\Microsoft\Windows\Recent\*.*

DEL /f /q %APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*.*

DEL /f /q %APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*.*

ECHO Выполнено

ECHO.

REM ------------------------------------------------------------------------------------------



REM ------------------------------------------------------------------------------------------

ECHO.

ECHO ОЧИСТКА ИСТОРИИ Panther - файловая система

DEL /f /q %systemroot%\Panther\*.*

ECHO Выполнено

ECHO.

REM ------------------------------------------------------------------------------------------



REM ------------------------------------------------------------------------------------------

ECHO.

ECHO ОЧИСТКА ИСТОРИИ AppCompat - файловая система

DEL /f /q %systemroot%\appcompat\Programs\*.dll

DEL /f /q %systemroot%\appcompat\Programs\*.exe

DEL /f /q %systemroot%\appcompat\Programs\*.txt

DEL /f /q %systemroot%\appcompat\Programs\*.xml

DEL /f /q %systemroot%\appcompat\Programs\Install\*.txt

DEL /f /q %systemroot%\appcompat\Programs\Install\*.xml

DEL /f /q %systemroot%\appcompat\Programs\Install\*.dll

DEL /f /q %systemroot%\appcompat\Programs\Install\*.exe

ECHO Выполнено

ECHO.

REM ----





REM ------------------------------------------------------------------------------------------

	ECHO.

	REM Prefetch. Удаление файлов, оптимизирующих запуск приложений. Windows в следующий раз загрузится медленнее

	REM утилиты NirSoft - LastActivityView, ExecutedProgramsList

	ECHO ОЧИСТКА ИСТОРИИ Prefetch - файловая система

	DEL /f /q %systemroot%\Prefetch\*.pf

	DEL /f /q %systemroot%\Prefetch\*.ini

	DEL /f /q %systemroot%\Prefetch\*.7db

	DEL /f /q %systemroot%\Prefetch\*.ebd

	DEL /f /q %systemroot%\Prefetch\*.bin

	REM SuperFetch. Удаление баз оптимизации SuperFetch

	DEL /f /q %systemroot%\Prefetch\*.db

	REM Trace. Удаление файлов трассировки

	DEL /f /q %systemroot%\Prefetch\ReadyBoot\*.fx

	ECHO Выполнено

	ECHO.



	ECHO.

	ECHO ОЧИСТКА ИСТОРИИ Minidump - файловая система

	REM Удаление дампов ошибок

	REM утилиты NirSoft - LastActivityView

	DEL /f /q %systemroot%\Minidump\*.*

	ECHO Выполнено

COLOR 0B

ECHO.







EXIT



:do_clear

ECHO Очистка журнала %1

wevtutil.exe cl %1

GOTO :eof



:errNoAdmin

COLOR 0B

ECHO Необходимо запустить этот скрипт от имени администратора

ECHO.

PAUSE
