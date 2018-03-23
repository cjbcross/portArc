@echo OFF

set "classdrive=C:\Users\chbutl\pkey\ssoext"
set "userdrive=C:\Users\chbutl\pkey"
set "appurl=http://localhost/loginProcess.do"

cd /d %userdrive%

java -cp .;%classdrive%\* ssoext.cryptohelp %username% %userdrive%

set /p pkey= < %userdrive%\pkey.txt

start "" %appurl%?%pkey%
