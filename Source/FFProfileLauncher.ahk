SetWorkingDir, %A_ScriptDir%
scriptDir = %A_ScriptDir%
scriptName := RegExReplace(A_ScriptName, "i)(\.ahk|\.exe)", "")
settingsIni := scriptName ".ini"

; Read INI file
resolveSetting(iniSection, iniKey, ifEmpty, ifErr) {
  global settingsIni
  IniRead, settingVar, %settingsIni%, %iniSection%, %iniKey%
  If (settingVar="") {
    settingVar := ifEmpty
  }
  If (settingVar="ERROR") {
    settingVar := ifErr
  }
  return settingVar
}

Runpath := ""

FFPath := resolveSetting("SystemSettings", "FFPath", "Default", "Default")
If (FFPath="Default") {
  Runpath := ProgramFiles "\Mozilla Firefox\firefox.exe"
} Else {
  Runpath := FFPath
}

Profile := resolveSetting("Profile", "UseProfile", "", "")
If (Profile != "") {
  Runpath := Runpath " -p " """" Profile """"
}

StartURL := resolveSetting("Profile", "StartURL", "Default", "Default")
If (StartURL != "Default") {
  Runpath := Runpath " """ StartURL """"
}

Noremote := resolveSetting("SystemSettings", "Noremote", "True", "True")
If (Noremote != "False") {
  Runpath := Runpath " -no-remote"
}

Args := resolveSetting("SystemSettings", "Args", "", "")
If (Args != "") {
  Runpath := Runpath " " Args
}

Run %Runpath%