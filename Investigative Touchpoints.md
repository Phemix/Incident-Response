 ## Check surrounding events, before and after
	• TIMESTAMPS BUDDY!
	• Browser History
	• Dowloads
	• Extensions
	• Files
	• DNS Queries 
	• Registry
	• ShellBags
	-   UserAssist
Can confluence help?
Autrouns
Staging Folder? Navigate into it
Powershell Console History
DOS Key History
Memdump?
Timelines (find pivot point)

Scan with PeCMD if executable (the pf)
Redsight
Lateral Movement
  *  XSV
  * MountPoints2
  * Check different methods in my PS page
Any email reference
Ex-fil
	• Check sig
	• Check bro
	• Check conn
Windows Details?
	• Check WIN-WS (46s &47s)
	- 51-s when looking fir shares ish
	• MountPoints2 for share details
	• Win WIN-AD
Check SANS page for useful tools

## Case Strategy

* Initial gathering
* Ask Questions
* Do Case Work
* Add more Questions
* Re-ask all questions
* Be more collaborative

## MAC OS

MAC OS

* Check IP/domain name 
* Browser History
* Downloads (quarantine)
* Extensions
* Files
* Applications (grep in root folder)
* DNS Queries
* Connections.csv/network.csv
* Check surrounding events, before and after
	• Use XSV for parsing
* Focus on Trace Folder
* Installation Evidence (plists), mounts
* Trace Folders (network, file, processes)
* ProcInfo (connections)
* Redsight
* activateSettings -newKeyboardContext (check for keyboard attach)
* KeyboardSetupAssistant/KeyboardServiceAddedCallback (to search for Rubber Ducky)
* Timelines (find pivot point)
* Lateral Movement - 
	• SSH
	• ProcInfo (connections)
	• Network (Trace)
	• AppleScript (osaScript) - Regex (osascript\s.*kjhhxlhlkyga)
		○ https://attack.mitre.org/techniques/T1155/
	• SCP, RSYNC, and SFTP, FTP
* Network (Trace)
* LaunchDaemons
* USB?
* LaunchAgents
* Cron/at jobs (crontab -l)
* StartupItems
* Parse FSD events ( for file like ish)
* Exfil
	• Check sig
	• Check bro
	• Check conn
* Firewall Logs (systemProfile.spx and fw_opts.json)
* ATMEL AVR (Manufacturer of Rubber Ducky)
* Getting stumped? Do dynamic searches

* Icloud Accounts
raw_artifacts/libraryPrefs/Users/z0019w1/Library/Preferences/MobileMeAccounts.plist.json
raw_artifacts/socialAccounts/z0019w1/Accounts4.sqlite db: 
select * from zaccount;


http://nicoleibrahim.com/


## Docker Investigation 

* Docker ps -a (show all containers)
* Docker Inspect (show all docker config)
* docker history bb2bb32a82b3 --no-trunc  (shows how image was built)
* Docker container top container-id uid, pid, cmd (shows all processes in a running container)




