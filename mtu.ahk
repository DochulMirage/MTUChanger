Run, *RunAs %A_ComSpec% /k netsh interface ip set global minmtu=352,,Hide
Run, *RunAs %A_ComSpec% /k netsh interface ipv4 show interfaces > ipconfig.txt,,Hide

FileRead, ipconfig, ipconfig.txt
sText := " Ethernet"
Loop, parse, ipconfig, `n,
{
    IfInString, A_LoopField, %sText%
    {
        fText := A_LoopField
        fLine := A_Index
        mtuId := SubStr(%fText%, 2, 2)
    }else{

    }
}

Gui, Show, w185 h190, MTU Edit
Gui, Add, Edit, x21 y20 w44 h19 vMtuEdit, 500
Gui, Add, Button, x65 y20 w100 h20 gBtnMtuSet, MTU Set
Gui, Add, Button, x20 y45 w145 h20 gBtnMtuReset, MTU Reset to 1500
Gui, Add, Button, x20 y100 w145 h20 gBtnTerminal, Check with CMD
Gui, Add, Button, x20 y150 w145 h20 gGuiClose, Close (with Reset to 1500)
mtuValue = %MtuEdit%
Return

mtuSetEdit:
    mtuScript = netsh interface ipv4 set subinterface "%mtuId%" mtu=%mtuValue% store=persistent
    ; Run, *RunAs %A_ComSpec% /k %mtuScript% ,,Hide
    MsgBox, %A_ComSpec% /k %mtuScript%
Return

BtnMtuSet:
    GUI, Submit, Nohide
    mtuValue = %MtuEdit%
    Gosub, mtuSetEdit
Return

BtnMtuReset:
    mtuValue = 1500
    Gosub, mtuSetEdit
Return

BtnTerminal:
    WinClose, ahk_exe cmd.exe
    Run, %ComSpec% /k netsh interface ipv4 show interfaces
Return

GuiClose:
    GoSub, BtnMtuReset
    FileDelete, ipconfig.txt
    ExitApp