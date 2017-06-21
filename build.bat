@ECHO OFF

::XPatchLibÏîÄ¿Â·¾¶
IF EXIST "%~dp0\XPatchLib.Localization.sln" SET "SLN=%~dp0\XPatchLib.Localization.sln"

IF EXIST "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\MSBuild\15.0" SET "VS150COMNTOOLS=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\MSBuild\15.0"
IF EXIST "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\MSBuild\15.0" SET "VS150COMNTOOLS=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\MSBuild\15.0"
IF EXIST "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0" SET "VS150COMNTOOLS=%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0"

IF EXIST "%VS150COMNTOOLS%\bin\MSBuild.exe" (
SET MSBUILD="%VS150COMNTOOLS%\bin\MSBuild.exe"
GOTO Build
)

FOR %%b in (
	"%VS140COMNTOOLS%..\..\VC\vcvarsall.bat"
	"%VS120COMNTOOLS%..\..\VC\vcvarsall.bat" 
	"%VS110COMNTOOLS%..\..\VC\vcvarsall.bat"
	"%VS90COMNTOOLS%..\..\VC\vcvarsall.bat" 
) do (
if exist %%b (
	call %%b
	SET MSBUILD="msbuild.exe"
	goto Build
	)
)
 
::https://social.msdn.microsoft.com/Forums/en-US/1071be0e-2a46-4c30-9546-ea9d7c4755fa/where-is-vcvarsallbat-file?forum=visualstudiogeneral
echo "not found vcvarshall.bat"

:Build
(

dotnet restore %SLN%
call %MSBUILD% /nologo /v:m /m %SLN% /t:Rebuild /p:Configuration=Release /clp:Summary;
goto CopyResult
)

:CopyResult
(
IF NOT EXIST "%~dp0bin\" MD "%~dp0bin\"
echo xcopy /S /E /Y "%~dp0*.*" "%~dp0bin\" /exclude:"%~dp0exclude.txt"

xcopy /S /E /Y "%~dp0XPatchLib.Localization\bin\Release\net20\*.resources.dll" "%~dp0bin\" /exclude:%~dp0exclude.txt
)
 
:End