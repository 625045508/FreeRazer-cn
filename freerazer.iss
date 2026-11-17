; FreeRazer 的 Inno Setup 安装脚本。用 build.ps1 构建（它会把 freerazer.pyw 里的版本号作为 /DAppVersion 传进来）。
; Per-user install (no admin), upgrades in place, and is what the in-app updater runs silently.

#ifndef AppVersion
  #error Run build.ps1, which passes /DAppVersion
#endif

[Languages]
; 简体中文安装界面（ChineseSimplified.isl 来自 Inno Setup 官方收集的社区翻译）
Name: "chs"; MessagesFile: "ChineseSimplified.isl"

[Setup]
; Fixed forever: Windows uses it to recognise upgrades and the Installed apps entry
AppId={{ED2EAA2A-8EF3-4980-9ACF-10D6B468085E}
AppName=FreeRazer
AppVersion={#AppVersion}
AppVerName=FreeRazer {#AppVersion}（中文版）
AppPublisher=FreeRazer contributors
AppPublisherURL=https://github.com/JSa25/freerazer
AppSupportURL=https://github.com/JSa25/freerazer/issues
DefaultDirName={localappdata}\Programs\FreeRazer
DisableDirPage=yes
; the app was called Mouse Profiles before; upgrades move it to the FreeRazer folder instead of reusing the old one
UsePreviousAppDir=no
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
OutputDir=dist
OutputBaseFilename=FreeRazerSetup
SetupIconFile=icon.ico
UninstallDisplayIcon={app}\FreeRazer.exe
UninstallDisplayName=FreeRazer
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
; the app holds this mutex (the second is the old Mouse Profiles name); Setup and Uninstall ask you to close it first
AppMutex=FreeRazerSingleInstance,MouseProfilesSingleInstance
CloseApplications=yes

[InstallDelete]
; leftovers from when the app was called Mouse Profiles
Type: filesandordirs; Name: "{localappdata}\Programs\Mouse Profiles"
Type: files; Name: "{userprograms}\Mouse Profiles.lnk"

[Files]
Source: "dist\FreeRazer.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{userprograms}\FreeRazer"; Filename: "{app}\FreeRazer.exe"

[Run]
; 普通安装：装完询问是否立即打开
Filename: "{app}\FreeRazer.exe"; Description: "打开 FreeRazer"; Flags: nowait postinstall skipifsilent
; 静默安装（应用内更新用）：在托盘里重新打开，并提示已更新
Filename: "{app}\FreeRazer.exe"; Parameters: "--tray --updated"; Flags: nowait; Check: WizardSilent

[Code]
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  // the app's own leftovers: its start-with-Windows entry and, if you say so, your profiles
  // (a silent uninstall can't ask, so it keeps them)
  if CurUninstallStep = usUninstall then
  begin
    RegDeleteValue(HKCU, 'Software\Microsoft\Windows\CurrentVersion\Run', 'FreeRazer');
    RegDeleteValue(HKCU, 'Software\Microsoft\Windows\CurrentVersion\Run', 'Mouse Profiles');
    if (not UninstallSilent) and (MsgBox('要同时删除你的 FreeRazer 配置吗？' + #13#10 +
        '选择“否”会保留配置，方便以后重新安装。', mbConfirmation, MB_YESNO or MB_DEFBUTTON2) = IDYES) then
    begin
      DelTree(ExpandConstant('{userappdata}\FreeRazer'), True, True, True);
      // the app copies an old Mouse Profiles folder back in when its own is missing: remove that too
      DelTree(ExpandConstant('{userappdata}\MouseProfiles'), True, True, True);
    end;
  end;
end;

function InitializeSetup(): Boolean;
var
  i: Integer;
begin
  // the in-app updater starts Setup a few seconds after FreeRazer closes; if it is slow to exit, wait (up to
  // 20 s) instead of failing the AppMutex check, which a silent install can't ask about
  i := 0;
  while WizardSilent and CheckForMutexes('FreeRazerSingleInstance') and (i < 40) do
  begin
    Sleep(500);
    i := i + 1;
  end;
  Result := True;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  // older versions were installed by install.ps1 with their own Installed apps entry; drop it so there is only one
  if CurStep = ssPostInstall then
    RegDeleteKeyIncludingSubkeys(HKCU, 'Software\Microsoft\Windows\CurrentVersion\Uninstall\MouseProfiles');
end;
