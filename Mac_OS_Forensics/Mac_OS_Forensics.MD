# MAC OS ARTIFACTS
- Install History - /Library/Receipts/InstallHistory.plist
- SIP (/System/Library/Sandbox/rootless.conf) shows directories covered by SIP
-FS Events (FileSystem Events)
 - lsof to list all network connections | grep -i listen/establish/TCP/UDP
 - Recnt MS Office activity (~/Library/Containers/com.microsoft.Excel|Word|PowerPoint.plist OR
     ~/Library/Containers/com.microsoft.Excel|Word|PowerPoint. securebookmarksplist
 - Startup Items (/Library/StartupItems) - grep "/Library/StartupItems" root.csv | grep -v cmd_output | sort
 - Event Monitor Daemon (etc/emon.d/edomnd.plist and /etc/emon.d/rules
 - Periodic Scripts (/etc/periodic/)
 - RC Scripts (Usually in /etc)
 - Authorization Plugins like 2FA or DUO (/Library/Security/SecurityAgetPlugins
 - Shell Startup Scripts (grep -E "/Users/[0-9a-z]+/\.[^/*]*," root.csv | grep -v Containers | less
 - LoginItems via Service Management Framework (used by applications)
  * find /Applications -name *LoginItems*
  * ls /Applications/OneDrive.app/Contents/Library/LoginItems/
 - Cron/AT jobs
 - Kernel/System Extensions (/Library/StagedExtensions | /System/Library/Extensions/)
 
 * LaunchAgents/Daemons  
 - ~/Library/LaunchAgents - user owned
 - /Library/LaunchAgents - root owned
 - /Library/LaunchDaemons - root owned
 - /System/Library/LaunchAgents
 - /System/Library/LaunchDaemons
 
 - Cron jobs


# Logs
 - log show -predicate 'eventMessage contains "/Volumes"'
