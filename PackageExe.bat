@echo off
set PAUSE_ERRORS=1
call bat\SetupSDK.bat
call bat\SetupApplication.bat

::set PLATFORM=desktop
set TARGET=-captive-runtime

::if exist "dist" rd /s /q "dist"
md "dist"

adt -package -keystore cert\supermarkettimemobile.p12 -storetype pkcs12 -storepass fd -target bundle dist application.xml bin\supermarkettimemobile.swf -C bin . -C icons/android .
	
pause