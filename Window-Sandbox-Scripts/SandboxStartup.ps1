# Change context menu to old style
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_ShowClassicMode" /t REG_DWORD /d 1 /f

# Show file extensions
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f

# Show hidden files
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f

# ---- Add 'Edit With Notepad' and 'Open Notepad' to context menu -------
# Set the path to your specific Notepad executable which you'll put in the shared folder, since notepad isn't included in the sandbox for some reason
# Go to C:\Windows on your main computer and copy Notepad.exe, then copy notepad.exe.mui from your main language folder, such as C:\Windows\en-US
#    Important: Notepad.exe.mui can't simply go next to notepad.exe. You need to actually create the language folder (like en-US) again next to notepad.exe and put it in that. Otherwise notepad won't run.
$notepadPath = "C:\Users\WDAGUtilityAccount\Desktop\HostShared\notepad.exe"
reg add "HKEY_CLASSES_ROOT\*\shell\Edit with Notepad" /f
reg add "HKEY_CLASSES_ROOT\*\shell\Edit with Notepad" /v "Icon" /t REG_SZ /d "$notepadPath,0" /f
reg add "HKEY_CLASSES_ROOT\*\shell\Edit with Notepad\command" /ve /d "`"$notepadPath`" `"%1`"" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Notepad" /ve /d "Open Notepad" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Notepad" /v "Icon" /t REG_SZ /d "$notepadPath,0" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Notepad\command" /ve /d "`"$notepadPath`"" /f
# ---- Add 'Open PowerShell Here' and 'Open CMD Here' to context menu -------
$powershellPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$cmdPath = "C:\Windows\System32\cmd.exe"
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\MyPowerShell" /ve /d "Open PowerShell Here" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\MyPowerShell" /v "Icon" /t REG_SZ /d "$powershellPath,0" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\MyPowerShell\command" /ve /d "powershell.exe -noexit -command Set-Location -literalPath '%V'" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Mycmd" /ve /d "Open CMD Here" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Mycmd" /v "Icon" /t REG_SZ /d "$cmdPath,0" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Mycmd\command" /ve /d "cmd.exe /s /k cd /d `"\`"%V`"\`"" /f
# ---- Set .txt files to open with Notepad, Create txt option in Context Menu 'New' list
cmd /c assoc .txt=txtfile
cmd /c ftype txtfile=`"$notepadPath`" "%1"
reg add "HKEY_CLASSES_ROOT\txtfile" /ve /d "Text Document" /f
reg add "HKEY_CLASSES_ROOT\.txt\ShellNew" /f
reg add "HKEY_CLASSES_ROOT\.txt\ShellNew" /v "NullFile" /t REG_SZ /d "" /f
reg add "HKEY_CLASSES_ROOT\.txt\ShellNew" /v "ItemName" /t REG_SZ /d "New Text Document" /f
# -------------------------------------------------------------------------


# Restart Explorer so changes take effect
Stop-Process -Name explorer -Force
# Open an explorer window to the host-shared folder
Start-Process explorer.exe C:\Users\WDAGUtilityAccount\Desktop\HostShared

# Change execution policy for powershell to allow running scripts
Set-ExecutionPolicy -ExecutionPolicy unrestricted -Scope LocalMachine

# Uncomment to pause after running
#Read-Host "Pause"