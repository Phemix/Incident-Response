https://medium.com/@tho.le/linux-forensics-some-useful-artifacts-74497dca1ab2


Become a member
Sign in
Get started

You have 2 free stories left this month. Sign up and get an extra one for free.


Linux Forensics — Some Useful Artifacts

Tho Le
Follow
Oct 3, 2019 · 7 min read





While Windows forensics is widely covered via a number of courses and articles, there are fewer resources introducing to the Linux Forensics world. I have recently had an opportunity to handle a Linux-based case. Hence, the article aims to share some useful artifacts which can be used as a checklist to assist a Linux forensics case and as a lead to further investigation.
OS forensics is the art of finding evidence/artifacts left by systems, apps and users’ activities to answer a specific question. Windows Forensics is well researched, in which there are multiple places for evidence (some of them are event hard to wipe up completely like registry hives) as de facto standards such as registry hives, event logs, prefetches, shell items (e.g. shortcut, jumplist etc.), userassist, SRUM, Shellbag, amcache.hve and shimcache etc. Linux Forensics, in the other way around, is less popular and doesn’t contain anything in common with Windows forensics. This article is organized in four sections which provide more insight into Linux forensics:
Image capture and mounting
System configuration
User activities (e.g. opened files, commands etc.)
Logfile analysis
Note:
Since there are a number of Linux distributions and the article can’t cover all of them. All artifacts below are presented for Debian. Fortunately, it is trivial to find similar artifacts in another distribution.
The article assumes the dead box situation which means that you only have a hard disk(s) from the targeted machine.
If you have any other findings/ideas, please kindly share in the comment below.

Image capture and mounting
There are multiple ways/tools for image capture. FTK Imager (a GUI tool — freeware from Accessdata) is properly one of the most famous tools for creating digital forensics images (FTK® Imager 4.2.1 is the latest version at the time of writing which can be referenced here). There is also a good user guideline on creating a forensics image — Forensics 101: Acquiring an Image with FTK Imager. However, in this article, I present a command-line utility, namely dd, which is available in most Linux distribution.
Note: for a sound image capture process, connect the investigated hard drive to a write blocker so that no change can be made to the device.
dd (a command-line tool, available in most Unix and Linux) is a tool to copy files at the bit level. Below is the command in action, in which input is the hard drive of the given Linux box (e.g. /dev/sdb) and output is where the image is stored (e.g. /home/forensics/linux_disk.img).
dd if=input of=output
For the forensic investigation, you may want to mount a copy of the original image in another Linux machine. The steps below illustrate how to mount a raw image in a Debian Linux machine:
Step 1: attach the image to a loop device:
sudo losetup /dev/loop0 <raw_image_to_mount> (if /dev/loop0 is already occupied, /dev/loopX can be used instead)
Then to verify that the image is attached using losetup -a
Step 2: Using kpartx (available to most Linux system) to map image partitions. Each partition will be mapped to /dev/mapper/loop0pX (X is a number)
sudo kpartx -a /dev/loop0
Step 3: Mount mapped loopback as read-only
sudo mount -o ro /dev/mapper/loop0pX

System Configuration
Host Name is useful to identify the computer name that the hard disk belongs to. Furthermore, it can be used to correlate with other logs and network traffic based on the host name.


Time Zone is important to build an event timeline (usually converted to UTC).


Network configuration:
/etc/network/interfaces is the configuration file for network setup (dynamic or static IP assignment as well as scripts running when the interface is “up” or “down”).


A /etc/network/interfaces sample configuration
/etc/host is the configuration file for local DNS name assignment.
/etc/resolv.conf is the configuration file for DNS. However, if the resolvconf program is used, the configuration for DNS is /etc/resolvconf/run/resolv.conf.
/etc/dnsmasq.conf is the configuration file for DNS forwarder server and DHCP server if it is implemented in the investigated host.
/etc/wpa_supplicant/*.conf contains SSID configuration to which the Linux machine will automatically connect when the wifi signal is in the vicinity.
OS information determines OS release information.


Login information:
There are three places to find this information:
(1) /var/log/auth.log records connections/authentication to the Linux host. The command “grep -v cron auth.log*|grep -v sudo|grep -i user” filters out most of the unnecessary data and leaves only information regarding connection/disconnection.
(2) /var/log/wtmp maintains the status of the system, system reboot time and user logins (providing time, username and IP address if available). For more information, please refer to this Wikipedia page.
(3) /var/log/btmp records failed login attempts.


Use “last -f” to examine the content of wtmp
Account and group: may provide more inside about permission of an interested user or find out whether any suspicious account was created. Those information are stored in /etc/passwd (user account), /etc/groups (group information). Furthermore, it is recommended to check the /etc/sudoers file as well since it describes what commands a user can run with privilege permission.
Mounted Disk: provides more inside how the Linux box is setup. Noticeably, attackers may mount a particular path to RAM; hence, it will not survive upon reboot.


Persistence mechanisms: 
- Cron jobs are often used for persistence. Cron jobs can be examined in /etc/crontab (system-wide crontab) and /var/spool/cron/crontabs/<username> (user-wide crontab)
- Bash Shell initialization: when starting a shell, it will first execute ~/.bashrc and ~/.bash_profile for each user. /etc/bash.bashrc and /etc/profile are the system-wide versions of ~/.bashrc and ~/.bash_profile (If another shell is used, checked in documents of that shell for similar configuration files).
- Service start-up: System V (configuration files are in /etc/init.d/* and /etc/rd[0–6].d/*) , Upstart (configuration files are in /etc/init/*) and Systemd (configuration files are in /lib/systemd/system/* and /etc/systemd/system/*). For more information regarding service start-up, please refer to How To Configure a Linux Service to Start Automatically After a Crash or Reboot — Part 2: Reference
- RC (Run-control) is a traditional way with init to start services/programs when run level changes. Its configuration can be found at /etc/rc.local:
User activities
This section covers artifacts generated by a user’s activities
Open/Edit File
If a user uses Vim to open/edit a file, examining Vim log (~/.viminfo) would review a lot of information about opened files, search string, command lines and epoch time.


An example of ~/.viminfo
Find recently accessed/modified/changed files by a user with find:
Example find command for files accessed/modified/changed by <username> in the last 7 days:
→ find . -type f -atime -7 -printf “%AY%Am%Ad%AH%AM%AS %h/%s/%f\n” -user <username>|sort -n
→ find . -type f -mtime -7 -printf “%TY%Tm%Td%TH%TM%TS %h — %s — %f\n” -user <username>|sort -n
→ find . -type f -ctime -7 -printf “%CY%Cm%Cd%CH%CM%CS %h — %s — %f\n” -user <username>|sort -n
For more information about the find command and its option, please refer to the man page
MACB time stands for Modify — Access — Change — Birth (Creation time — only exists from EXT4). For MAC time, it can be viewed via the command “stat filename”. However, in order to view birth time or creation time, it requiresa bit more work as described in the debugfs-command-show-file-creation-time-in-linux article


“Stat test.py” command output for MAC time
Process Execution
Bash history: contains commands executed in the bash shell. it often recorded historical executions without timestamps. The bash history file for a user is located in his home folder ~/.bashrc and in /root/.bashrc for the root account. Hence, it is important to examine the bash histories of both users and root.
Execution with Sudo: is necessary when the execution requires root privilege. All executions with Sudo are recorded in auth.log


Execution with Sudo in auth.log
Find recently accessed executable files by a user. The example below finds all executable files run in the last 7 days.
find . -type f -perm /111 -user thole -atime -7 -printf “%AY%Am%Ad%AH%AM%AS %h — %s — %f\n” |sort -n
Logfile Analysis
Most Linux logs are stored under /var/log/. This article doesn’t aim to explain in detail all logs in a Linux system, but instead, it focuses more on logs that have high value for forensics. For more information about Linux logs, please refer to this article which explains some important logs to monitor.
When working with log files, it is advised that an analyst should have a lead of what to look for and search for related events in log files. A full review of logs is possible but tedious and time-consuming due to a large number of logs. For forensics purpose, I personally spend more time on the following logs:
/var/log/auth.log (/var/log/secure in RHEL/CentOS): This log contains all authentication events and Cron job session events (e.g. start, close etc.) for Debian. This may be the most important log to analyze.
/var/log/deamon.log: records events generated by background daemons. Usually, background processes/services offer invaluable logs to a user’s activities.
/var/log/syslog (/var/log/messages in RHEL/CentOS): contains general system messages. Particularly, it also contains cron job execution with its associated commands.


/var/log/syslog examination
Other application logs (if available) also provides a lot of fruitful information assisting a forensic case. Some of those logs to name are apache2, httpd, samba and mysqld etc.

10 





Forensics
Linux Forensics

10 claps






Written by
Tho Le
Follow

Write the first response
More From Medium
Build a CI/CD with Bitbucket, Angular and Firebase

Clement Fournier in Firebase Developers


Creating a Linux service with systemd

Benjamin Morel


How to Prevent Git Commit Naming Mistakes

Stephen Vinouze in Better Programming


Programming FUNdamentals — Lists, Loops, and User Input

TheCyberBasics in Python In Plain English


Top 5 Java 13 Features You Can Learn Today

Sylvain Saurel in Javarevisited


String Data Type in Go

Uday Hiwarale in RunGo


Three Decorators Commonly Used in Python Custom Classes

Yong Cui, Ph.D. in The Startup


Adding Badge Notifications with Ionic 4 and Angular

Thomas George in The Startup


Discover Medium
Welcome to a place where words matter. On Medium, smart voices and original ideas take center stage - with no ads in sight. Watch
Make Medium yours
Follow all the topics you care about, and we’ll deliver the best stories for you to your homepage and inbox. Explore
Become a member
Get unlimited access to the best stories on Medium — and support writers while you’re at it. Just $5/month. Upgrade

About
Help
Legal
