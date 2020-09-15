Linux Plus Notes

* Linux Boot Stages
 - Firmware Stage: Run code in BIOS or UEFI (POST - Power On Self Test)
 - Bootloaded Stage: reads the config file and executes the kernel (Full name is GRUB (Grand Unified Bootloader) )
           https://www.tutorialspoint.com/what-is-grub-in-linux
 - Kernel Stage: loads the RAMDisk into RAM
                 loads device drivers & config files from RAMDisk
				 unmounts RAMDisk and mounts filesystem
				 starts initialization stage
 - Intialization Stage: systemd is started by kernel
                        systemd starts login shells and GUI interface


* Targets
- Systemd has the concept of Targets (a specific config)
- Default Target is a graphical target
- Systmes can be booted into different targets
- systemd.unit=emergency boots into emergency mode
- rd.break mounts the root filesystem as readonly
- 'mount -o remount.rw /sysroot' remounts the root as read-write
- 'chroot /sysroot' changes root to /sysroot
- 'passwd' can be used to change root password
- SeLinux needs a re-write of all security context (do that by creating 'touch /.autorelabel)
- 'sysctl get-default' or 'sysctl set-default'


* Kernel Updating
- all installed kernels are listed in /boot
- '/boot/grub2' is where all bootloader files for bIOS based systems
- config file for BIOS based systems is 'grub.cfg', don't edit this for linux boot, edit '/etc/default/grub
- 'sudo grub2-mkconfig /etc/default/grub' to update the boot loader
- Setting is different for UEFI system

* Kernel Modules
- Linux has modules (could be file systems or drivers) that have to match the kernel version 
- '/lib/modules' for 32bit and '/lib64' for 64bit
- ls '/lib/modules/$(uname -r)/kernel
- 'lsmod' lists currently loaded modules
- 'modprobe' can be used to install linux module ('-vr' removes the modules and dependencies
- 'depmod' can be used to search for local 
- Create file in /etc/modules-load.d (to load modules automatically at boot)


* Network Config
- Manual vs Auto address assignment
- 'hostnamectl' to set hostname (sudo hostnamectl set-hostname rhhost1.localnet.com
- Static Name Resolution is done in etc/hosts and overrides DNS resolution
- 'ifup/ifdown' - interface up/down
- 'ip' for configuring stuff live (not in config file)
- '/etc/sysconfig/network scripts/ifcfg-eth0' to configure static configuration files for an interface
- 'nmcli, nmtui and nm-connection-editor' are all part of Network Manager (nmcli can edit more interfaces than nmtui)
- 'etc/resolv.conf' is used to configure static DNS entries 
- Network config files can also be used to configure interfaces and even configure DNS for specific interfaces
- Changes config files needs you to notify network manager ('nmcli c reload) 
- Bonding is a kind of interface (sudo modprobe bonding) to create a bonding driver
   https://www.interserver.net/tips/kb/network-bonding-types-network-bonding/
   nmcli con add type bond-slave ifname ens9 master bond0
   nmcli con add type bond-slave ifname ens10 master bond0
   
   
* Partitions
- cat /proc/partitions show all drives/partitions recongized by kernel
- lsblk shows a hierachical tree for all partitions/drives
- sudo fdisk -l shows all paritions in the partition table
- 'gdisk', 'sgdisk', 'cgdisk', 'parted' can be used to configure disk partitions
- 'gdisk' only shows partitions on the specifid drive, fdisk show part recognized by the kernel
- 'sudo mkfs -t ext4 /dev/sdb1' creates a filesystem in the partition
- 'mklabel msdos' can be used to create a partition table in a partition (using 'parted')
- 'mklabel primary 1 500MB' can also be used to create a partition table in a partition (using 'parted')
- 'gdisk' is GPT fdisk, can be used to backup and restore a partition
- dd can be used to back up a drive esp in MBR mode, gdisk has to be used to backup/restore paritions created wtih gdisk
- 'pvcreate' is used to cerate physical volume for use later(gotta be empty and unmounted) by Logical Volume Manager
- 'vgcreate' creates a new volume group
- 'lvcreate' creates a Logical Volume in a volume group
   https://opensource.com/business/16/9/linux-users-guide-lvm
- 'vgs' lists all volume groups, 'lvs' lisis all Logical Volume Groups
- 'fsck' is AKA FileSystem check




*Linux File Systems
- ext2, ext3, ext4 (most common), XFS (more advanced), -Btrfs (experimental)


* RAID
- 'vgcreate vgraid /dev/sdb1 /dev/sdb2' creates a RAID 
- vgraid is a Volume Group (Physical)


* User and SW mgt
- Package Managers are used to install SW; debian-dpkg, RedHat-rpm
- Some Local package managers can only install what they have on
- Repo based package managers that can find dependencies and install (Debian-APT, RedHat-Yum)
- Repos add dependencies to Local Package Managers to install
- RPM lacks repo sentric view esp remotely (installs local SW packages)
- YUM has the concept of SW package groups (SW installed together) and installs using RPM libraries and updates RPM db
- RPM can also be used to query packages
 rpm -qa;  rpm -qi bash; rpm -qdf /bin/bash to find docu file for a binary; rpm -qf /bin/bash shows the origination of a file
- rpm -q --provides/--requires bash (shows what bash provides or requires)
- rpm -p quries a pckage that has not been installed
- YUM can be used as download only an can also be used to skip broken dependencies _(--skip-broken)
- Yum leaves dependencies and config files when used to remove packages (use autoremove to remove dependencies)
- YUM can use package cleanup to remove unnneded packages
- YUM repos are stroed at /etc/yum.repos.d/ and must end in '.repo'
- 'yum repoinfo' shows all repos and the number/size of packages in them
- 'yum --disablerepo'/'--enable-repo' can be used to temporaily enable/disable a repo on the cmdline
- Debian Package, dpkg is a package manager for (Ubuntu, Debian and Linux Mint), the repo based mgt system is 'APT'
- Debian does not use repo groups but virtual packages
- 'apt search' shows all packages (installed or not)
- 'apt show' shows package details
- For installed packages, we use the app name not package name
- 'sudo apt update' updates the index of avilable software
- 'sudo apt autoremove' to remove dependencies and 'sudo apt purge' to remove config files
- Debian repos are stored in /etc/apt/sources.list
- Third party Debian repos can be added with PPAs (Personal Package Archive) or Canonical archives


* LOCAL AND USER ACCTS
- Account names/userID/GroupID are in /etc/passwd
- Encoded passwd, acct agin info in /etc/shadow
- Starting user ID/grp IDs, passwd encoding type in /etc/login.defs/
- 'sudo useradd' to add users without a password (use -p or --password to add password or sudo passwd username)
- Skeleton directory are created in all new user's home directory automatically
- '!!' after username in etc/shadow means user has not set passwd and cannot login
- 'sudo chage -l username shows password aging information
- Failed logins can be found in both 'var/log/faillog|btmp'
- 'sudo userdel -r username' (to remove user account and home directory)

* SERVER INFRASTRUCTURE AND SERVICES
- File servers can be CIFS/NFS (procol)
- Type 1 hypervisor (Hypervisor -> Physical Computer); Type 2 hypervisor (Hypervisor -> Host OS -> Physical Computer)
- Types of virtualization -> Emulation (very slow); Paravirtualization (Guest CPU -> Real CPU); Full Virtualization or HVM (requires HW virt), full virt + PV drivers is best case; PVH uses PV and is supported by Xen
- VM Installlation Automation (Kickstart on RedHat, Preseed on Debian & AutoYast on SUSE)
- Thick provisioning is providing all needed resources, Thin provisioning is providing some resouces with the ability to scale as needed
- 'libvirt'
- init is in the /etc/inittab
- System V Init has run Levels 0 - halt, 1- single user mode, 2-multi user mode, 3- multiuser mode with netowrking, 6 is reboot mode
- All init scripts are stored in etc/rc.d/init.d (the sym link usually tells the runlevel)
- All scripts in inti.d are executed in heirachical order /etc/rc.d/rc5.d/K02oddjob -> rc5.d says its at runlevel 5 and K02 means kill this and 02 is the serial number; S means get started
- Init in System V was replaced with upstart and systemd
- System V Init is now out of date and now replaced with upstart and systemd
- 'chkconfig --level 345 httpd on' creates link for and runs http service on levels 3,4and5
- 'service' can be used to manage live services -> 'service httpd start', 'service httpd stop'
- init is used to start other services (like abrtd, auditd, crond etc) on legacy linux, also had the concepts of runlevels, was slow and had no dependencies
- 'systemctl list-unit-files -at service' lists service unit files, the service they are associated and the status (for unit files not services)
- 'systemctl list-units -at service' shows the real service list and status of the service
- 'sudo systemctl stop atd' will stop the atd service; 'sudo systemctl status atd' will show the status of the atd service
- 'sudo systemctl is-active atd' checks if service is active; 'sudo systemctl status atd' shows service status; 'sudo systemctl mask atd' restricts a service from running (even when started with 'sudo systemctl start atd')
- 'at' can be used to run one time jobs
- 'sudo enable systemctl atd' will make sure AT runs at boot, 'sudo enable start atd' will start the AT service
- AT service can be used to create a batch job (which runs only when a system is quite less busy)
- Units are representations of resources that systemd knows about
- https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units

- CRON is stored in cronjobs or crontab (could be user or system)
- 'crontab -e' to edit the cron file for users
- 'sudo vi /etc/cron.d/backupdocs to edit cron files for system (specify user as root) -> 0 1 * * * root rsync -a /home/grant/Documents/ /home/grant/Documents.bak
- man 5 crontab is for files in crontab

* TIME AND DATE SETTINGS
- 'localectl' can be used to control a host of keyboard/language settings
- 'date +%h %d %Y' shows month day and year; date +%s" shows num of sec since Jan 1 1970; 'date --date=@83649861' converts date in epoch to normal date
- 'date --date '+10days' shows next 10 days; '-date --date 'next thursday sows the next Thursday


* GUI AND REMOTE ACCESS
- Graphical Interface is just apps running on OS (provided by X Window in Linux)
- X Window -> GUI toolkit -> Window Managar -> Desktop Env -> Desktop Apps
- All apps work on all Desktops (GNOME and KDE are most common)
- X-Windows can be used to access Linux remotely but must be present on both client and server
- Unix uses mostly the X-Window System (network aware by default) gor Graphical Interface
- X-server is usually on Local and takes input from keyboard and mouse but client app is remote (reverse of normla situation)
- X-Window is mostly replaced by Wayland (no network capability) and suppoerts x-server as client for backward compatibility
- SSH -L 3306:127.0.0.1:3306 user1@rhhost2.localnet.com -> maps 3306 -22 ->22 - 3306
- SSH -R 10000:127.0.0.1:22 user1@remotehost1.local.com (maps 1000 -> 22 on remhost 1)
- SSH -p 10000 remotehost1.local.com com (grabs port 10000 which is already mapped to port 22 and maps backl to calling host)


*FILES
- Tree shows a tree hierachy of the filesystem
- 'cd -' takes you back to the last directory
- 'ln' can be used to link files (Hard Links) - cannot link to dirs or other FSs
- 'ln -s' can be used to create symbolic links - can links across FSs/dirs but breaks when target is broken
- 'vi' editor in ubuntu, 'vim' in Cent OS
- In vim, 'dd' in insert mode remove the last line,
- In vim command mode, 'esc+u' undo changes while 'esc+ctrl+r' redo changes,  'yy' to copy line, 'cc' to cut line'p' to paste 
- Named Pipes are FIFO, allows one process to read from another, acts as file on disk, one proc writes to and naother reads from
- Named Pipes can be created with the command 'mkfifo <pipe name>". The pipe has to be read to close. 'mkfifo named_pipe' 'cat "hi" > named_pipe'. This can be done in two different terminals or by two different users
- 'tee' command both saves the output to a file and shows it on a screen.
- 'locate' can be used to find files. 'locate <word>' can find any word, 'locate -A bzip2 man' can find lines containing both, 'locate -i high' finds high case insenstively just like grep
- 'locate' can also be used with regex. 'locate --regexp '^/usr.*pixmaps.*jpg$'
- 'find' can be used to find files for a user or even group and a wildacrd is good to find more matches like locate. 'find / -name <name>', 'find / -user grant'
- 'sudo tar --xattrs -cpvf etc.tar /etc' to put in an archive (no compress)
- 'sudo tar --gzip --xattrs -cpvf etc.tar.gz /etc'
- 'tar -tf' can view files in an archive
-'gzip' can be used to zip while 'gunzip' is ued to unzip a file


* FILE SECURITY
- first characters in 'ls' tells the type of file, - is file, d is driectory, l is sym link, c is char dev file, b is block device file (HD or USB drive), s is socket file, p is named pipe
- Extended Atrr Types - Extended Security/System/User attributes. 'ls-Z or -RZ' shows security arrtibutes
- Extended sys attr store ACLs (file) - 'setfacl -m user:root:rwx aclfile.txt'; getfacl -t aclfile.txt
- Extended user attributes aka ext attr (append only, auto compre, immutable)- 'sudo chattr +i afile.txt'; 'lsattr afile.txt'
- File/Directory Modes, RWX is normal for file, in DIRs, R - can list contents, W - can create data in, X - Can get into and traverse
- Permissions (R-4, W-2, X-1)
- Umasks are used to set default file/dir perms (777 is dir max, 666 is file max), gotta subtract umasks value (which is different for root or normal user) from permission numbers to get actual value
- SUID allows non-users to execute with priv of user owner ('s' case tells us if execute is set or not)
- Suid is 4, SGID is 2 and sticky is 1
- SUID can also be modified with  u+s
- 'sudo find / -perm 4000/200' finds all perms above 4000 which have SUID 
set or 2000 which have SGID set 
- Sticky is used to create directories (where users can't del each other's 
files)
- 'getfacl filename' gets ACL properties; 'setfacl -m user:root:rwx aclfile' to modify acl file for that user in root group
- SGIDs send inheritance to all files and DIRs in parent DIR
- 'setfacl -d -m user:root:rwx dir1' sets this ACL as default for the 'dir1' folder; 'setfacl -R -m user:root:rwx dir1' sets this for all files in the 'dir1' folder
- 'setfacl' canm also be used to delete ACLs (setfacl -x group:root dir;' delets root group ACL); 'getfacl -k' delets default ACLs, 'getfacl -b' deletes all ACL


* MANDATORY ACCESS CONTROL
- https://www.redhat.com/en/topics/linux/what-is-selinux
- Security-Enhanced Linux (SELinux) is an example of a MAC system for Linux. 
- SeLinux is placed in format (user:role:type:level), the type is security context for the file/folder
- (id -Z) can tell the security context of user in Linux
- (ps -eZ) shows sec context for processes, (ls -Z) shows sec context for files
- (chcon -t etc_t ~/file.txt) can be used to change security context for a file; (restorecon ~/file,txt) can be used to restore the security context of a file
- 'semanage' can also be used to change security context so that it survives reboots
 - To get SeLinux function status (getsebool -a, sestatus -b, semamange boolean -l
 - 'setsebool -P' can be used to change bool value and also add it to policy so it survives a reboot
 - SELinux Solns - use permissive mode, dig audit logs, change file type using chcon/semanage, new sec policy using audit2allow
 - Carry over SE context (cp -a, mv, tar --selinux or rsync -a -X)
 - AppArmor is Path-based MAC, supports NFS and NTFS, used mostly in Suse, Debian and Ubuntu
 - AppArmor has 3 modes - Complaining (logs violateion but no enforce) - Enforcing (can be used to enforce)   
