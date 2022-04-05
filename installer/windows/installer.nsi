; DESim Windows Installer
; Copyright (c) 2020 FPGAcademy
; Please see license at https://github.com/fpgacademy/DESim

; Use the following two line to turn compression on and off. Good for testing quickly
SetCompressor /SOLID lzma
;SetCompress off

; The name/icon of the installer
Name "DESim"
Caption "DESim Setup"
; Icon "teacher.ico"
; UninstallIcon "win-uninstall.ico"

; The output file to write
OutFile "desim_setup.exe"

; Declare variables
Var INSTALL_DIR

Var SOFTWARE_NAME
Var VERSION_MAJOR
Var VERSION_MINOR
Var SOFTWARE_FULLNAME
Var SOFTWARE_SHORTCUT

Var MODELSIM_NAME
Var MODELSIM_VERSION_MAJOR
Var MODELSIM_VERSION_MINOR
Var MODELSIM_FULLNAME

; Variable for the post-installation message
Var DESIM_INSTALL_PATH_TITLE

!include "MUI.nsh"
!include "Sections.nsh"
!include "WordFunc.nsh"
!include "LogicLib.nsh"
!include "x64.nsh"

!insertmacro WordFind
!insertmacro WordReplace

;--------------------------------
; Pages
;!define MUI_ICON "teacher.ico"
;!define MUI_UNICON "win-uninstall.ico"
!define MUI_ABORTWARNING

!define MUI_HEADERIMAGE

!define MUI_COMPONENTSPAGE_SMALLDESC

!define MUI_WELCOMEPAGE_TITLE "Welcome to the $SOFTWARE_NAME setup wizard"
!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of the $SOFTWARE_FULLNAME. Please note that you must have previously installed $MODELSIM_FULLNAME and/or $QUESTA_FULLNAME to use this software."
!insertmacro MUI_PAGE_WELCOME

!insertmacro MUI_PAGE_LICENSE "..\..\LICENSE"

!define MUI_PAGE_CUSTOMFUNCTION_LEAVE CustomDirectoryPageLeave
!define MUI_DIRECTORYPAGE_VARIABLE $INSTALL_DIR
!define MUI_DIRECTORYPAGE_VERIFYONLEAVE
!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_INSTFILES

!define MUI_PAGE_CUSTOMFUNCTION_PRE CustomFinishPre
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH
;--------------------------------

;--------------------------------
;Languages
!insertmacro MUI_LANGUAGE "English"




;The stuff to install
Section "$SOFTWARE_NAME" DESIM_SECTION
  ; Set R0 to root directory for the installation
  StrCpy $R0 "$INSTALL_DIR"
  SetOutPath $R0					; installation directory

  ; Set the installation path message
  StrCpy $DESIM_INSTALL_PATH_TITLE "$R0"
  ${WordReplace} $DESIM_INSTALL_PATH_TITLE "\" "\\" "+" $DESIM_INSTALL_PATH_TITLE
  StrCpy $DESIM_INSTALL_PATH_TITLE "The $SOFTWARE_NAME executable and documentation were installed to \r\n\t$DESIM_INSTALL_PATH_TITLE."

  ; ask to place a shortcut to the program on the user's desktop
  MessageBox MB_YESNO|MB_ICONEXCLAMATION \
             "Do you want a shortcut to the $SOFTWARE_NAME placed on your Desktop?." IDNO SkipDesktopShortcut
  CreateShortCut "$DESKTOP\$SOFTWARE_FULLNAME.lnk" "$INSTALL_DIR\java\bin\javaw.exe" "-m DESim/GUI.Main"

SkipDesktopShortcut:

  ; start menu shortcuts
  CreateDirectory "$SMPROGRAMS\$SOFTWARE_FULLNAME"
  CreateDirectory "$SMPROGRAMS\$SOFTWARE_FULLNAME"
  CreateShortcut "$SMPROGRAMS\$SOFTWARE_FULLNAME\$SOFTWARE_NAME.lnk" "$INSTALL_DIR\java\bin\javaw.exe" "-m DESim/GUI.Main"

;  CreateDirectory "$SMPROGRAMS\$SOFTWARE_FULLNAME"
;  CreateDirectory "$SMPROGRAMS\$SOFTWARE_FULLNAME"
;  CreateShortcut "$SMPROGRAMS\$SOFTWARE_FULLNAME\Uninstall $SOFTWARE_NAME.lnk" "$INSTALL_DIR\uninstall.exe"

  ; Copy the DESim files
  StrCpy $R0 "$INSTALL_DIR"

  SetOutPath "$R0\java"	            ; installation directory
  ; Get the GUI
  File /nonfatal /r ..\..\frontend\dist\*.*

  SetOutPath "$R0\demos"            ; installation directory
  ; Get the demos
  File /nonfatal /r /x *.sh ..\dist\demos\*.*

  SetOutPath $R0					; installation directory
  ; Get the backend VPI
  File /nonfatal ..\..\backend\dist\simfpga.vpi
  ; Get the support files
  File /nonfatal ..\..\frontend\scancode.csv
  File /nonfatal DESim_run.bat

SectionEnd ; end the section




Section "" COMMON_FILES_SECTION
	; Set R0 to root directory
	StrCpy $R0 "$INSTALL_DIR"

	; create the uninstaller
	;CreateDirectory $R0
	;SetOutPath $R0
	;File win-uninstall.ico
	;WriteUninstaller $R0\uninstall.exe
SectionEnd ; end the common files section




;Section "Uninstall"
;  SetShellVarContext all
;
;  ; Remove the whole installation directory
;  RMDir /r "$INSTDIR"
;
;  ; Remove desktop icons
;  Delete "$DESKTOP\$SOFTWARE_FULLNAME.lnk"
;  
;  ; delete Start Menu shortcuts
;  RMDir /r "$SMPROGRAMS\$SOFTWARE_FULLNAME"
;SectionEnd ; end the uninstall section




; This custom leave is to check that the user really wants to continue because there is no going back
Function CustomDirectoryPageLeave

  MessageBox MB_YESNO "$SOFTWARE_NAME will now be installed to $INSTALL_DIR$\nAre you sure that you would like to continue?" \
  IDYES ComponentsPageLeaveOK IDNO ComponentsPageLeaveCancel

  ComponentsPageLeaveCancel:
  abort

  ComponentsPageLeaveOK:
  return
FunctionEnd



; Disable the back button on the finish page
Function CustomFinishPre
  GetDlgItem $0 $HWNDPARENT 3 
  EnableWindow $0 0 
FunctionEnd



Function .onInit
  # the plugins dir is automatically deleted when the installer exits
  InitPluginsDir

  # StrCpy $INSTALL_DIR "$PROGRAMFILES\DESim"
  StrCpy $INSTALL_DIR "C:\DESim"

  ; Set DESim info
  StrCpy $SOFTWARE_NAME "DESim software"
  StrCpy $VERSION_MAJOR "2"
  StrCpy $VERSION_MINOR "0"
  StrCpy $SOFTWARE_FULLNAME "$SOFTWARE_NAME v$VERSION_MAJOR.$VERSION_MINOR"
  StrCpy $SOFTWARE_SHORTCUT "$SOFTWARE_FULLNAME"

  ; Set required version of the ModelSim software
  StrCpy $MODELSIM_NAME "ModelSim${U+00AE}-Intel${U+00AE} FPGA Edition"
  StrCpy $MODELSIM_VERSION_MAJOR "10"
  StrCpy $MODELSIM_VERSION_MINOR "5b"
  StrCpy $MODELSIM_FULLNAME "$MODELSIM_NAME v$MODELSIM_VERSION_MAJOR.$MODELSIM_VERSION_MINOR"

  StrCpy $QUESTA_NAME "Questa${U+00AE}-Intel${U+00AE} FPGA Edition Software"
  StrCpy $QUESTA_VERSION_MAJOR "2021"
  StrCpy $QUESTA_VERSION_MINOR "2"
  StrCpy $QUESTA_FULLNAME "$QUESTA_NAME v$QUESTA_VERSION_MAJOR.$QUESTA_VERSION_MINOR"


  ; Setup the install path info as if the components were not installed
  StrCpy $DESIM_INSTALL_PATH_TITLE "The $SOFTWARE_NAME was not installed."

  ; set the installation for all users 
  SetShellVarContext all ; (shortcuts and environment variables will work for all users)
FunctionEnd

