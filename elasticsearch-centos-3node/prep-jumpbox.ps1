# remove the IE security
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
Stop-Process -Name Explorer -Force
Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green


# download putty to desktop
$puttysource = "http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe"
$puttydest = "$env:Public\Desktop\putty.exe"
Invoke-WebRequest $puttysource -OutFile $puttydest

#download shakespeare test data 
$datasource = "https://www.elastic.co/guide/en/kibana/3.0/snippets/shakespeare.json"
$datadest = "$env:Public\Desktop\shakespeare.json"
Invoke-WebRequest $datasource -OutFile $datadest


#put shortcut to first node HQ on desktop
New-Item "$env:Public\Desktop\elasticHQ.url" -type file -force -value "[InternetShortcut]`nURL=http://10.0.2.10:9200/_plugin/HQ/"

#put shortcut to Kibana (first Node) on desktop
New-Item "$env:Public\Desktop\Kibana.url" -type file -force -value "[InternetShortcut]`nURL=http://10.0.2.10:5601/"

#put shortcut to Marvel (first node) on desktop
New-Item "$env:Public\Desktop\Marvel.url" -type file -force -value "[InternetShortcut]`nURL=http://10.0.2.10:5601/app/marvel/"

#associate ps1 with powershell_ise
Invoke-Expression -Command:"cmd.exe /C Ftype Microsoft.PowerShellScript.1=C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe %1"

#copy to desktop for easy access
copy "get-started.ps1" "$env:Public\Desktop\get-started.ps1"

#Add System.IO.Compression.FileSystem Type
Add-Type -AssemblyName System.IO.Compression.FileSystem

#Install IIS
add-windowsfeature web-server -includeallsubfeature

#Install WebDeploy
$WebPi = "WebPi.zip"
$WebPiTargetDir = "D:\WebPi"
[System.IO.Compression.ZipFile]::ExtractToDirectory($WebPi, $WebPiTargetDir)
Start-Process -FilePath "D:\WebPi\WebpiCmd.exe" -Argumentlist @("/Install","/AcceptEula","/Products:WDeploy") -WorkingDirectory $WebPiTargetDir" -Wait

#Install DemoSite
$DemoSiteZip = "Demosite.zip"
$DemoSiteTargetDir = "D:\Demosite"
[System.IO.Compression.ZipFile]::ExtractToDirectory($DemoSiteZip, $DemoSiteTargetDir)
Start-Process -FilePath "D:\DemoSite\WebTestForElk.deploy.cmd" -Argumentlist @("/Y") -WorkingDirectory $DemoSiteTargetDir" -Wait

#Install Java
$jreUrl = "http://download.oracle.com/otn-pub/java/jdk/8u91-b15/jdk-8u91-windows-x64.exe"
$jreTarget = "d:\jdk-8u91-windows-x64.exe"
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$cookie = New-Object System.Net.Cookie 
$cookie.Name = "oraclelicense"
$cookie.Value = "accept-securebackup-cookie"
$cookie.Domain = ".oracle.com"
$session.Cookies.Add($cookie);
Invoke-WebRequest $jreUrl -WebSession $session -TimeoutSec 900 -OutFile $jreTarget
Start-Process -FilePath $jreTarget -PassThru -Wait -Argumentlist "/s"
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jdk1.8.0_91", "Machine")
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jdk1.8.0_91", "User")
$env:JAVA_HOME = "C:\Program Files\Java\jdk1.8.0_91"

#Install LogStash
$lsBaseDir = "${Env:ProgramFiles(x86)}\Logstash"
New-Item -Path $lsBaseDir -Type Directory -Force
$lsZip = "https://download.elastic.co/logstash/logstash/logstash-all-plugins-2.3.1.zip"
$lsTarget = "${$lsBaseDir}\Logstash.zip"
Invoke-WebRequest $lsZip -OutFile $lsTarget
[System.IO.Compression.ZipFile]::ExtractToDirectory("${$lsBaseDir}\Logstash.zip", $lsBaseDir)



