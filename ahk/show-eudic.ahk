#Requires AutoHotkey v2.0
Hotkey("^!e", ShowOrRunEudic)  ; Ctrl+Alt+E 触发

ShowOrRunEudic(*) {
    exeName := "eudic.exe"
    exePath := "C:\Program Files\Eudic\eudic.exe"  ; ⚠️ 修改为你自己的路径

    hwnd := FindEudicWindow()
    if hwnd {
        WinRestore(hwnd)
        WinActivate(hwnd)
    } else if ProcessExist(exeName) {
        ; 尝试通过发送热键唤出 Eudic，例如 Ctrl+Shift+E（你可在 Eudic 设置中确认）
        Send("{F9}")
    } else {
        Run('"' exePath '"')
    }
}

FindEudicWindow() {
    winList := WinGetList()
    for hwnd in winList {
        if WinGetProcessName(hwnd) = "eudic.exe" {
            return hwnd
        }
    }
    return 0
}

ProcessExist(name) {
    for proc in ComObject("WbemScripting.SWbemLocator")
        .ConnectServer().ExecQuery("SELECT * FROM Win32_Process WHERE Name='" name "'")
    {
        return true
    }
    return false
}

