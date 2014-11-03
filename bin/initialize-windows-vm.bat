@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))"
SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

choco install 7zip.install
choco install Console2
choco install curl
choco install DotNet4.5
choco install f.lux
choco install fiddler
choco install google-chrome-x64
choco install googledrive
choco install itunes
choco install javaruntime
choco install mongodb
choco install msysgit
choco install nmap
choco install pidgin
choco install pip
choco install putty.portable
choco install python2
choco install ruby
choco install SourceCodePro
choco install SublimeText3
choco install svn
choco install sysinternals
choco install vcredist2008
choco install vim
choco install VisualStudio2013Professional
choco install vlc
choco install wget
choco install windbg
choco install windows-8-1-sdk
