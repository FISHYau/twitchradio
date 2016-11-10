#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

; GUI MENU

Gui, Add, Text, x22 y19 w110 h20 , Enter streamer's name:
Gui, Add, Text, x22 y49 w50 h20 +Left, twitch.tv/
Gui, Add, Edit, x67 y47 w70 h16 vStream, 
Gui, Add, CheckBox, x22 y79 w50 h20 Checked vChat, Chat?
Gui, Add, Button, x22 y119 w50 h30 default, Go
Gui, Add, Button, x92 y119 w70 h30 , Cancel
Gui, Show, x185 y138 h167 w190, Twitch Radio
Return

;WHAT DO

ButtonGo:
	Gui, submit
	url=--app=https://www.twitch.tv/%stream%/chat?popout=
	Run %comspec% /c livestreamer twitch.tv/%stream% audio,,Hide
	WinWait, ahk_exe vlc.exe, , 10
	
	if ErrorLevel {
		MsgBox, 5, Error, 404: Stream not found.
		IfMsgBox Retry
			Reload
		IfMsgBox Cancel
			ExitApp
	}
	else {
		WinMinimize, ahk_exe vlc.exe
	}
	
	if chat = 1
		goto, fOpenChat
	else
		goto, fCloseApp
	
	
	fRetry:
		Reload
	fExit:
		ExitApp
	fOpenChat:
		run % "chrome.exe" ( winExist("ahk_class Chrome_WidgetWin_1") ? " --new-window " : " " ) url
		WinWait, Twitch
		WinRestore, Twitch
		WinMove, Twitch,, -10, 0, 400, 1030
		goto, fCloseApp
	fCloseApp:
		WinWaitClose ahk_exe vlc.exe
		WinClose, Twitch
		ExitApp


ButtonCancel:
GuiClose:
ExitApp