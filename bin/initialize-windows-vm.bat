@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))"
SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

choco install SublimeText3 msysgit javaruntime 7zip.install vlc sysinternals ruby python2 pip DotNet4.5 vim Console2 putty.portable fiddler wget curl svn itunes googledrive vcredist2008 SourceCodePro mongodb nmap pidgin f.lux VisualStudio2013Professional
