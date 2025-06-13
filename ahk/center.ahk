#Requires AutoHotkey v2

^!c::CenterWindowOnCurrentScreen()  ; Ctrl + Alt + C 触发
^!w::SwitchWindow()  ; Ctrl + Alt + w 触发

CenterWindowOnCurrentScreen() {
	WindowTitle := "A"
    WinGetPos(&winX, &winY, &winW, &winH, WindowTitle)
    centerX := winX + winW / 2
    centerY := winY + winH / 2

    MonitorCount := SysGet(80)
    Loop MonitorCount {
		MonitorGetWorkArea(A_Index, &left, &top, &right, &bottom)
        if (centerX >= left && centerX < right && centerY >= top && centerY < bottom) {
            screenW := right - left
            screenH := bottom - top

            newX := left + (screenW - winW) / 2
            newY := top + (screenH - winH) / 2


			WinMove(newX,newY, , , WindowTitle)

            return
        }
    }
}

; Get monitor information
SwitchWindow() {
	;; 感知屏幕的不同dpi
	DllCall("SetThreadDpiAwarenessContext", "ptr", -4,"ptr")
    WinGetPos(&winX, &winY, &winW, &winH, "A")
    centerX := winX + winW / 2
    centerY := winY + winH / 2

	MonitorCount := SysGet(80)
	Loop MonitorCount {
		DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")
		MonitorGetWorkArea(A_Index, &left, &top, &right, &bottom)
		if (centerX < left || centerX > right || centerY < top || centerY > bottom ) {
			screenW := right - left
			screenH := bottom - top

			if winW > screenW {
				winW := screenW
			}
			if winH > screenH {
				winH := screenH
			}

			newX := left + (screenW - winW) / 2
			newY := top + (screenH - winH) / 2
			DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")
			WinMove(newX, newY, , , "A")
			DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")
			WinMove( , , winW, winH, "A")
			return
		}
	}
}
