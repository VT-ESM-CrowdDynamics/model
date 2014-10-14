start /wait Git-1.9.4-preview20140929.exe /SILENT /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"
start /wait VirtualBox\VirtualBox-4.3.18-r96516-MultiArch_amd64.msi /Passive /NoRestart
set VBOX_MSI_INSTALL_PATH=C:\Program Files\Oracle\VirtualBox\
start /wait vagrant_1.6.5.msi /qb /passive /norestart
set PATH=%PATH%;C:\HashiCorp\Vagrant\bin
C:
cd %USERPROFILE%\Desktop
"C:\Program Files (x86)\Git\bin\sh.exe" --login -i -c 'git clone https://github.com/automaticgiant/2014-VTESM-Crowd_Model.git'
cd 2014-VTESM-Crowd_Model
vagrant up
sh.cmd