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
    WinGetPos(&winX, &winY, &winW, &winH, "A")
    centerX := winX + winW / 2
    centerY := winY + winH / 2

	MonitorCount := SysGet(80)
	Loop MonitorCount {
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
			WinMove(newX, newY, winW, winH, "A")
			return
		}
	}
}


