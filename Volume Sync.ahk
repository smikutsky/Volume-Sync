/*
Audio Manager by Scott Mikutsky
Copyright © 2020, 2022


This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.


Version History:

1.0 - 12/12/2020 - Initial release
1.0.1 - 2/9/2022 - Updated about page
*/

#NoEnv
#SingleInstance force
#Persistent
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include <VA>

FileInstall, VolumeSync.ico, VolumeSync.ico

Menu, Tray, NoStandard
Menu, Tray, NoMainWindow

Menu, Tray, Icon, VolumeSync.ico
Menu, Tray, Tip, Volume Sync

Menu, Tray, Add, Volume Sync, VolumeSync

Menu, Tray, Add
Menu, Tray, Add, Start With Windows, ToggleWinStartup
	if FileExist(A_Startup "\Volume Sync.lnk")
		Menu, Tray, Check, Start With Windows

Menu, Tray, Add, Exit

Loop {
	deviceEnumerator := ComObjCreate("{BCDE0395-E52F-467C-8E3D-C4579291692E}", "{A95664D2-9614-4F35-A746-DE8DB63617E6}")

	VA_IMMDeviceEnumerator_GetDefaultAudioEndpoint(deviceEnumerator, 0, 0, ddevice)
	VA_IMMDeviceEnumerator_GetDefaultAudioEndpoint(deviceEnumerator, 0, 2, cdevice)

	if(ddevice == cdevice){
		vol := VA_GetVolume("1", "", ddevice)
		VA_SetVolume(vol, "1", "", cdevice)
	}

	sleep, 100
}

VolumeSync:
	return

About:
	Gui, New, -MaximizeBox -MinimizeBox
	Gui, Add, Picture, w64 h-1, VolumeSync.ico
	Gui, Add, Text, ys, Volume Sync by Scott Mikutsky
	Gui, Add, Text, yp+16, Version 1.0.1
	Gui, Add, Text, yp+16, Copyright © 2020, 2022
	Gui, Add, Link, yp+16, <a href="https://github.com/smikutsky/Volume-Sync">https://github.com/smikutsky/Volume-Sync</a>
	Gui, Add, Link, yp+16, <a href="mailto:smikutsky@gmail.com">smikutsky@gmail.com</a>
	Gui, Add, Text, xs W300, This software uses the Vista Audio library by Lexikos 
	Gui, Add, Text, W300, This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
	Gui, Add, Text, W300, This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
	Gui, Add, Link, W300, You should have received a copy of the GNU General Public License along with this program.  If not, see <a href="https://www.gnu.org/licenses/"><https://www.gnu.org/licenses/></a>.
	Gui, Show, , About
	return

ToggleWinStartup:
	if (FileExist(A_Startup "\Volume Sync.lnk"))
		FileDelete, %A_Startup%\Volume Sync.lnk
	else
		FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\Volume Sync.lnk, %A_WorkingDir%,,, %A_ScriptFullPath%
	Menu, Tray, ToggleCheck, Start With Windows	
	return

Exit:
	ExitApp
	return