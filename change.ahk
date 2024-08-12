#Include "quick-input.ahk"

; ctrl+alt+r reload script
^!r::{
	Reload
	Sleep 1000 ; 如果成功, 则 reload 会在 Sleep 期间关闭这个实例, 所以下面这行语句永远不会执行.
	Result := MsgBox("The script could not be reloaded. Would you like to open it for editing?",, 4)
	if Result = "Yes"
	    Edit
	return
}

; change CapsLock to Control
{{ahk_caps_lock}}CapsLock::Control


; change to english in wezterm or code when push esc key if current im is not english
$Esc::{
	if WinActive("ahk_exe alacritty.exe") {
		ChangeToEnglish
		return
	}
	if WinActive("ahk_exe wezterm-gui.exe") {
		ChangeToEnglish
		return
	}

	if WinActive("ahk_exe code.exe")  {
		ChangeToEnglish
		return
	}
	if WinActive("ahk_exe Obsidian.exe") {
		ChangeToEnglish
		return
	}

	Send "{Esc}"
}

ChangeToEnglish() {
	winTitle:=WinGetTitle("A")
	PostMessage(0x50, 0, 0x0409, , WinTitle) ;切换为英文0x4090409=67699721
	PostMessage(0x50, 0, 0x0804, , WinTitle) ;切换为中文，可以在搜狗输入法中设置默认为英文输入
	Send "{Esc}"
}

; alt+q close current window
!q::{
	try {
		winTitle := WinGetTitle("A")
		if WinExist(WinTitle) {
			WinClose(WinTitle)
		}
	} catch Error {
		MsgBox "can not find active window"
	}
}

; Ctrl+Alt+T start a wezterm
^!t::
{
	Run "C:\Users\\{{ username }}\scoop\apps\wezterm\current\wezterm-gui.exe start"
}

; 打开词典
^!i::{
	if WinExist("ahk_exe eudic.exe") {
		WinActivate
	} else {
		Run "C:\Program Files\eudic\eudic.exe"
		if WinExist("ahk_exe eudic.exe") {
			WinActivate
		}
	}
}

; shift+ esc output ~
+Esc::Send "~"

; By SKAN for ahk/ah2 on D35D/D495 @ tiny.cc/desktopicons
DesktopIcons( Show:=-1 )
{
	Local hProgman := WinExist("ahk_class WorkerW", "FolderView") ? WinExist() : WinExist("ahk_class Progman", "FolderView")

	Local hShellDefView := DllCall("user32.dll\GetWindow", "ptr",hProgman,      "int",5, "ptr")
	Local hSysListView  := DllCall("user32.dll\GetWindow", "ptr",hShellDefView, "int",5, "ptr")

	If ( DllCall("user32.dll\IsWindowVisible", "ptr",hSysListView) != Show ) {
		DllCall("user32.dll\SendMessage", "ptr",hShellDefView, "ptr",0x111, "ptr",0x7402, "ptr",0)
	}
}

; ctrl+shift+enter to toggle desktop icons
^+Enter::{
	DesktopIcons()
}




