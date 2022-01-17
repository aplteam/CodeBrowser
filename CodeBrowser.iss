; This script is best executed by CodeBrowser's "Make" utility.

#define MyAppVersion "2.0.0+48"
#define MyAppName "CodeBrowser"
#define MyAppExeName "CodeBrowser.dws"
#define MyAppPublisher "APL Team Ltd"
#define MyAppURL "https://github.com/aplteam/CodeBrowser"
#define MyBlank " "
#define TargetDir "Dist\"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
AppId={{D09BC349-43F8-43DC-BBF1-949682B6CD72}

AppName="{#MyAppName}"
AppVersion={#MyAppVersion}
AppVerName={#MyAppName}{#MyBlank}{#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={userdocs}\\MyUCMDs\\{#MyAppName}
DefaultGroupName={#MyAppPublisher}\{#MyAppName}
AllowNoIcons=yes
OutputDir=C:/Users/kai/AppData/Local/Temp/InnoTempDir
OutputBaseFilename="SetUp_{#MyAppName}_{#MyAppVersion}"
Compression=lzma
SolidCompression=yes
SetupIconFile={#MyAppIcoName}
PrivilegesRequired=Lowest
AlwaysShowDirOnReadyPage=yes
DisableWelcomePage=no
DisableDirPage=no
CreateUninstallRegKey=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; LicenseFile: "License";

[Registry]

[Dirs]

[Files]
Source: "{#TargetDir}\CodeBrowser_uc.dyalog"; DestDir: "{app}\..\";
Source: "{#TargetDir}\CodeBrowser\{#MyAppExeName}"; DestDir: "{app}"
Source: "{#TargetDir}packages\*"; DestDir: "{app}"; Flags: recursesubdirs
Source: "LICENSE"; DestDir: "{app}"
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]

[Run]
Filename: "{app}\ReleaseNotes.html"; Description: "View the Release Notes"; Flags: postinstall shellexec skipifsilent

[Tasks]

[Code]
