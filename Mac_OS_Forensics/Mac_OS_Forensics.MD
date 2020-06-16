# MAC OS ARTIFACTS
- Install History - /Library/Receipts/InstallHistory.plist
- SIP (/System/Library/Sandbox/rootless.conf) shows directories covered by SIP
- Logon Info - (last and w)
- Proceses - Parent/Child relationship 
    * (ps and ps_start) 
    * True_tree concept (find out more)
    * Find more about IPC
-FS Events (FileSystem Events)
 - lsof to list all network connections | grep -i listen/establish/TCP/UDP
 - Recent MS Office activity (~/Library/Containers/com.microsoft.Excel|Word|PowerPoint.plist OR
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
 - Aplication FIrewall
 - Application Sandboxing- They are usually in a directory called 'Containers' (find . -name Containers)
 - AppTranslocation (Apple's mechanism to prevent damage an app can do)
 
 * LaunchAgents/Daemons  
 - ~/Library/LaunchAgents - user owned
 - /Library/LaunchAgents - root owned
 - /Library/LaunchDaemons - root owned
 - /System/Library/LaunchAgents
 - /System/Library/LaunchDaemons
 
 - Cron jobs


# Logs
 - log show -predicate 'eventMessage contains "/Volumes"' shows Volumes
 - System Logs (/var/log)
 - Apple System Logs (/var/log/asl|Diagnostics|powermanagement
 - Unified Logs (var/db/diagnostics) | 'log show' --info | --debug 
 - Audit Logs (/var/audit)
 - Application Logs (/Library/Logs|Application Support/Logs)
 - User Logs (~/Library/Logs)
 - wtmp.log - find out more later
 
 
 # Lateral Movement
  - Mostly through SSH (cand be seen with the 'w' and 'last' command
  - Check if SMB is enabled - launchctl list | grep -i com.apple.smbd
  - Show file sharing history
    * log show --info --debug --predicate 'proessImagePath CONTAINS "tccd" AND eventMessage CONTAINS "/usr/sbin/smbd" AND NOT eventMessage CONTAINS "PID"'
  - Determine if anyone connected to a SMB share hosted on MacOS
      * log show --style json --info --debug --predicate 'eventMessage CONTAINS "com.apple.smbd"' --last 7d
  - History of bluetooth devices
      * * log show --style json --info --debug --predicate 'eventMessage CONTAINS "isFirstPairing"' --last 7d
  - Files sent to OS using BT devices (count will always be 1)
     * log show --info debug -predicate 'processImagepath CONTAINS "bluetoothaudiod" AND eventMessage CONTAINS "incoming:1"' -last 2h
  - Files sent from Mac OS using BT
    * log show --info debug -predicate '(processImagepath CONTAINS "bluetoothaudiod" eventMessage CONTAINS "outgoing") OR (processImagepath CONTAINS "bluetoothaudiod" eventMessage CONTAINS "incoming:0")' -last 2h
     
