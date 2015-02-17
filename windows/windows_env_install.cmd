powershell -Command "(New-Object Net.WebClient).DownloadFile('https://www.dropbox.com/s/ytmixuqcywysidu/Git-1.9.4-preview20140929.exe?dl=1', 'Git-1.9.4-preview20140929.exe')"
start /wait Git-1.9.4-preview20140929.exe /SILENT /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://www.dropbox.com/s/f52rao07jusoaob/common.cab?dl=1', 'common.cab')"
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://www.dropbox.com/s/r1urnt4mklcc1kl/VirtualBox-4.3.18-r96516-MultiArch_amd64.msi?dl=1', 'VirtualBox-4.3.18-r96516-MultiArch_amd64.msi')"
start /wait VirtualBox-4.3.18-r96516-MultiArch_amd64.msi /Passive /NoRestart
set VBOX_MSI_INSTALL_PATH=C:\Program Files\Oracle\VirtualBox\
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://www.dropbox.com/s/ki34gj5rk9w72fx/vagrant_1.6.5.msi?dl=1', 'vagrant_1.6.5.msi')"
start /wait vagrant_1.6.5.msi /qb /passive /norestart
set PATH=%PATH%;C:\HashiCorp\Vagrant\bin
C:
cd %USERPROFILE%\Desktop
"C:\Program Files (x86)\Git\bin\sh.exe" --login -i -c 'git clone https://github.com/VT-ESM-CrowdDynamics/model.git'
cd model
vagrant up
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://www.dropbox.com/s/2n3yr6mawbtz363/sh.cmd?dl=1', 'sh.cmd')"
sh.cmd

