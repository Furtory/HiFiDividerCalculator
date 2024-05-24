Process, Priority, , Realtime
#MenuMaskKey vkE8
#WinActivateForce
#InstallKeybdHook
#InstallMouseHook
#Persistent
#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 2000
#KeyHistory 2000
SendMode Input
SetBatchLines -1
SetKeyDelay -1, 50
SetWorkingDir %A_ScriptDir%

Menu, Tray, NoStandard ;不显示默认的AHK右键菜单
Menu, Tray, Add, 自定义电感列表, 自定义电感列表 ;添加新的右键菜单
Menu, Tray, Add,
Menu, Tray, Add, 重启软件, 重启软件 ;添加新的右键菜单
Menu, Tray, Add, 退出软件, 退出软件 ;添加新的右键菜单

输入:=0

ifExist, %A_ScriptDir%\电感列表.ini ;如果配置文件存在则读取
{
  IniRead, 电感列表, 电感列表.ini, 设置, 电感列表
}
else
{
  电感列表:="6.2,4.1,4,3.7,3.4,3.3,2.9,2.6,2.3,2.55,2.1,1.8,1.65,1.5,1.2,1,0.8,0.68,0.65,0.5,0.47,0.33,0.3,0.25,0.24,0.22,0.1,0.068,0.047,0.033,0.027,0.022,0.01"
  IniWrite, %电感列表%, 电感列表.ini, 设置, 电感列表
}

列表:=StrSplit(电感列表, ",")
长度:=列表.Count()

输出:="黑钨重工出品 免费开源`n请勿商用 侵权必究`n输入你需要生成的目标mh电感(无需单位)`n计算结果会自动复制到剪贴板`n当前电感列表个数：" . 长度 . "`n当前电感列表内容：`n"

Gui +AlwaysOnTop
Gui Font, s13, Segoe UI
Gui Add, Button, Default x234 y6 w80 h30 g输出, 确认
Gui Add, Edit, x8 y7 w225 h28 v输入 g更新, 1
Gui Add, Edit, x8 y37 w305 h635 v输出, %输出%

loop %长度%
{
  输出.=列表[A_Index] . "mh`n"
}
GuiControl, , 输出, %输出%

Gui Show, w320 h676, 双电感串联计算器
Return

自定义电感列表:
Gui -AlwaysOnTop
InputBox, 电感列表, 自定义电感列表,请按从大到小顺序`n以半角逗号为分隔`n输入自定义电感(无需单位), , 600, , , , Locale, ,%电感列表%
IniWrite, %电感列表%, 电感列表.ini, 设置, 电感列表
Gui +AlwaysOnTop
Return

更新:
Gui, Submit , NoHide
Return

输出:
Gui, Submit , NoHide
if (输入<=0)
{
  警告:="输入无效"
  GuiControl, , 输入, %警告%
  Return
}
输出:="目标" . 输入 . "mh电感`n`n"
次数:=0
loop %长度%
{
  次数:=次数+1
  第一:=列表[次数]
  if (第一=输入)
  {
    输出.=第一 . "mh已存在于电感列表中！`n`n"
    continue
  }
  else if (第一>=输入)
  {
    continue
  }
  旧误差:=1000
  loop %长度%
  {
    等效值:=第一+列表[A_Index]
    误差:=-(输入-等效值)/输入*100
    ; ToolTip 输入%输入% 等效值%等效值% 误差%误差% 旧误差%旧误差%
    ; Sleep 100
    if (Abs(误差)<旧误差)
    {
      旧误差:=Abs(误差)
      第二:=列表[A_Index]
      ; MsgBox, 第二%第二%
      最低误差:=Round(误差, 2)
      最低等效值:=Round(等效值, 5)
    }
  }
  
  if (第一>=第二) and (第二>0)
  {
    输出.=第一 . "mh + " . 第二 . "mh   串联`n等效值" . 最低等效值 . "mh   误差" . 最低误差 . "%`n`n"
  }
}
GuiControl, , 输出, %输出%
Clipboard:=输出
Return

Home::
重启软件:
Reload

退出软件:
GuiEscape:
GuiClose:
    ExitApp