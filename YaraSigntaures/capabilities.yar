/*
    This Yara ruleset is under the GNU-GPLv2 license (http://www.gnu.org/licenses/gpl-2.0.html) and open to any user or organization, as    long as you use it under this license.
*/


rule inject_thread {
    meta:
        author = "x0r, updated by Femi"
        description = "Code injection with CreateRemoteThread in a remote process"
        classifications = "Code Injection"
        vti_default_score = 5
        vti_documents_score = 5
        vti_scripts_score = 5
        vti_browser_score = 5
        vti_msi_score = 5
        vti_static_score = 5
	version = "0.1"
    strings:
        $c1 = "OpenProcess"
        $c2 = "VirtualAllocEx"
        $c3 = "NtWriteVirtualMemory"
        $c4 = "WriteProcessMemory"
        $c5 = "CreateRemoteThread"
        $c6 = "CreateThread"
        $c7 = "OpenProcess"
    condition:
        $c1 and $c2 and ( $c3 or $c4 ) and ( $c5 or $c6 or $c7 )
}

rule hijack_network {
    meta:
        author = "x0r, updated by Femi"
        description = "Hijack network configuration"
        classifications = "Network Config Hijack"
        vti_default_score = 5
        vti_documents_score = 5
        vti_scripts_score = 5
        vti_browser_score = 5
        vti_msi_score = 5
        vti_static_score = 5
	version = "0.1"
    strings:
        $p1 = "SOFTWARE\\Classes\\PROTOCOLS\\Handler" nocase
        $p2 = "SOFTWARE\\Classes\\PROTOCOLS\\Filter" nocase
        $p3 = "Microsoft\\Windows\\CurrentVersion\\Internet Settings\\ProxyServer" nocase
        $p4 = "software\\microsoft\\windows\\currentversion\\internet settings\\proxyenable" nocase
        $f1 = "drivers\\etc\\hosts" nocase
    condition:
        any of them
}

rule create_service {
    meta:
        author = "x0r, updated by Femi"
        description = "Create a windows service"
        classifications = "Windows Service Manipulation"
        vti_default_score = 5
        vti_documents_score = 5
        vti_scripts_score = 5
        vti_browser_score = 5
        vti_msi_score = 5
        vti_static_score = 5
	version = "0.2"
    strings:
	$f1 = "Advapi32.dll" nocase
        $c1 = "CreateService"
        $c2 = "ControlService"
        $c3 = "StartService"
        $c4 = "QueryServiceStatus"
    condition:
        all of them
}


rule network_udp_sock {
    meta:
        author = "x0r, updated by Femi"
        description = "Communications over UDP network"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
        $f1 = "Ws2_32.dll" nocase
	$f2 = "System.Net" nocase
        $f3 = "wsock32.dll" nocase
        $c0 = "WSAStartup"
        $c1 = "sendto"
        $c2 = "recvfrom"
        $c3 = "WSASendTo"
        $c4 = "WSARecvFrom"
        $c5 = "UdpClient"
    condition:
        (($f1 or $f3) and 2 of ($c*)) or ($f2 and $c5)
}

rule network_tcp_listen {
    meta:
        author = "x0r"
        description = "Listen for incoming communication"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
        $f1 = "Ws2_32.dll" nocase
        $f2 = "Mswsock.dll" nocase
	    $f3 = "System.Net" nocase
        $f4 = "wsock32.dll" nocase
        $c1 = "bind"
        $c2 = "accept"
        $c3 = "GetAcceptExSockaddrs"
        $c4 = "AcceptEx"
        $c5 = "WSAStartup"
        $c6 = "WSAAccept"
        $c7 = "WSASocket"
        $c8 = "TcpListener"
        $c9 = "AcceptTcpClient"
        $c10 = "listen"
    condition:
        1 of ($f*) and 2 of ($c*)
}

rule network_dyndns {
    meta:
        author = "x0r, updated by Femi"
        description = "Communications - dynamic dns network"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
	$s1 =".no-ip.org"
        $s2 =".publicvm.com"
        $s3 =".linkpc.net"
        $s4 =".dynu.com"
        $s5 =".dynu.net"
        $s6 =".afraid.org"
        $s7 =".chickenkiller.com"
        $s8 =".crabdance.com"
        $s9 =".ignorelist.com"
        $s10 =".jumpingcrab.com"
        $s11 =".moo.com"
        $s12 =".strangled.com"
        $s13 =".twillightparadox.com"
        $s14 =".us.to"
        $s15 =".strangled.net"
        $s16 =".info.tm"
        $s17 =".homenet.org"
        $s18 =".biz.tm"
        $s19 =".continent.kz"
        $s20 =".ax.lt"
        $s21 =".system-ns.com"
        $s22 =".adultdns.com"
        $s23 =".craftx.biz"
        $s24 =".ddns01.com"
        $s25 =".dns53.biz"
        $s26 =".dnsapi.info"
        $s27 =".dnsd.info"
        $s28 =".dnsdynamic.com"
        $s29 =".dnsdynamic.net"
        $s30 =".dnsget.org"
        $s31 =".fe100.net"
        $s32 =".flashserv.net"
        $s33 =".ftp21.net"
    condition:
        any of them
}

rule network_toredo {
    meta:
        author = "x0r, updated by Femi"
        description = "Communications over Toredo network"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
	$f1 = "FirewallAPI.dll" nocase
        $p1 = "\\CurrentControlSet\\Services\\Tcpip6\\Parameters\\Interfaces\\" nocase
    condition:
        all of them
}

rule network_smtp_dotNet {
    meta:
        author = "x0r, updated by Femi"
        description = "Communications smtp"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
	$f1 = "System.Net.Mail" nocase
        $p1 = "SmtpClient" nocase
    condition:
        all of them
}

rule network_smtp_raw {
    meta:
        author = "x0r, updated by Femi"
        description = "Communications smtp"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
	$s1 = "MAIL FROM:" nocase
        $s2 = "RCPT TO:" nocase
    condition:
        all of them
}

rule network_smtp_vb {
    meta:
        author = "x0r, updated by Femi"
        description = "Communications smtp"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
	$c1 = "CDO.Message" nocase
        $c2 = "cdoSMTPServer" nocase
        $c3 = "cdoSendUsingMethod" nocase
        $c4 = "cdoex.dll" nocase
        $c5 = "/cdo/configuration/smtpserver" nocase
    condition:
        any of them
}

rule network_p2p_win {
    meta:
        author = "x0r, updated by Femi"
        description = "Communications over P2P network"
        vti_default_score = 4
        vti_documents_score = 4
        vti_scripts_score = 4
        vti_browser_score = 4
        vti_msi_score = 4
        vti_static_score = 4
	version = "0.1"
    strings:
     	$c1 = "PeerCollabExportContact"
     	$c2 = "PeerCollabGetApplicationRegistrationInfo"
     	$c3 = "PeerCollabGetEndpointName"
     	$c4 = "PeerCollabGetEventData"
     	$c5 = "PeerCollabGetInvitationResponse"
     	$c6 = "PeerCollabGetPresenceInfo"
     	$c7 = "PeerCollabGetSigninOptions"
     	$c8 = "PeerCollabInviteContact"
     	$c9 = "PeerCollabInviteEndpoint"
     	$c10 = "PeerCollabParseContact"
     	$c11 = "PeerCollabQueryContactData"
     	$c12 = "PeerCollabRefreshEndpointData"
     	$c13 = "PeerCollabRegisterApplication"
     	$c14 = "PeerCollabRegisterEvent"
     	$c15 = "PeerCollabSetEndpointName"
     	$c16 = "PeerCollabSetObject"
     	$c17 = "PeerCollabSetPresenceInfo"
     	$c18 = "PeerCollabSignout"
     	$c19 = "PeerCollabUnregisterApplication"
     	$c20 = "PeerCollabUpdateContact"
    condition:
        5 of them
}

rule network_tor {
    meta:
        author = "x0r, updated by Femi"
        description = "Communications over TOR network"
        classifications = "Anonymity"
        vti_default_score = 4
        vti_documents_score = 4
        vti_scripts_score = 4
        vti_browser_score = 4
        vti_msi_score = 4
        vti_static_score = 4
	version = "0.1"
    strings:
        $p1 = "tor\\hidden_service\\private_key" nocase
        $p2 = "tor\\hidden_service\\hostname" nocase
        $p3 = "tor\\lock" nocase
        $p4 = "tor\\state" nocase
    condition:
        any of them
}


rule network_http {
    meta:
        author = "x0r"
        description = "Communications over HTTP"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
        $f1 = "wininet.dll" nocase
        $c1 = "InternetConnect"
        $c2 = "InternetOpen"
        $c3 = "InternetOpenUrl"
        $c4 = "InternetReadFile"
        $c5 = "InternetWriteFile"
        $c6 = "HttpOpenRequest"
        $c7 = "HttpSendRequest"
        $c8 = "IdHTTPHeaderInfo"
    condition:
        $f1 and $c1 and ($c2 or $c3) and ($c4 or $c5 or $c6 or $c7 or $c8)
}

rule network_dropper {
    meta:
        author = "x0r"
        description = "File downloader/dropper"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
        $f1 = "urlmon.dll" nocase
        $c1 = "URLDownloadToFile"
        $c2 = "URLDownloadToCacheFile"
        $c3 = "URLOpenStream"
        $c4 = "URLOpenPullStream"
    condition:
        $f1 and 1 of ($c*)
}

rule network_ftp {
    meta:
        author = "x0r"
        description = "Communications over FTP"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
	   $f1 = "Wininet.dll" nocase
        $c1 = "FtpGetCurrentDirectory"
        $c2 = "FtpGetFile"
        $c3 = "FtpPutFile"
        $c4 = "FtpSetCurrentDirectory"
        $c5 = "FtpOpenFile"
        $c6 = "FtpGetFileSize"
        $c7 = "FtpDeleteFile"
        $c8 = "FtpCreateDirectory"
        $c9 = "FtpRemoveDirectory"
        $c10 = "FtpRenameFile"
        $c11 = "FtpDownload"
        $c12 = "FtpUpload"
        $c13 = "FtpGetDirectory"
    condition:
        $f1 and (4 of ($c*))
}

rule network_tcp_socket {
    meta:
        author = "x0r"
        description = "Communications over RAW socket"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
	$f1 = "Ws2_32.dll" nocase
        $f2 = "wsock32.dll" nocase
        $c1 = "WSASocket"
        $c2 = "socket"
        $c3 = "send"
        $c4 = "WSASend"
        $c5 = "WSAConnect"
        $c6 = "connect"
        $c7 = "WSAStartup"
        $c8 = "closesocket"
        $c9 = "WSACleanup"
    condition:
        1 of ($f*) and 2 of ($c*)
}

rule network_dns {
    meta:
        author = "x0r"
        description = "Communications use DNS"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
        $f1 = "System.Net"
        $f2 = "Ws2_32.dll" nocase
        $f3 = "Dnsapi.dll" nocase
        $f4 = "wsock32.dll" nocase
        $c2 = "GetHostEntry"
	    $c3 = "getaddrinfo"
	    $c4 = "gethostbyname"
	    $c5 = "WSAAsyncGetHostByName"
	    $c6 = "DnsQuery"
    condition:
        1 of ($f*) and  1 of ($c*)
}

rule network_ssl {
    meta:
        author = "x0r"
        description = "Communications over SSL"
        version = "0.1"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
    strings:
        $f1 = "ssleay32.dll" nocase
        $f2 = "libeay32.dll" nocase
        $f3 = "libssl32.dll" nocase
        $c1 = "IdSSLOpenSSL" nocase
    condition:
        any of them
}

rule network_dga {
    meta:
        author = "x0r"
        description = "Communication using dga"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
        $dll1 = "Advapi32.dll" nocase
        $dll2 = "wininet.dll" nocase
	    $dll3 = "Crypt32.dll" nocase
        $time1 = "SystemTimeToFileTime"
        $time2 = "GetSystemTime"
        $time3 = "GetSystemTimeAsFileTime"
        $hash1 = "CryptCreateHash"
        $hash2 = "CryptAcquireContext"
        $hash3 = "CryptHashData"
        $net1 = "InternetOpen"
        $net2 = "InternetOpenUrl"
        $net3 = "gethostbyname"
        $net4 = "getaddrinfo"
    condition:
        all of ($dll*) and 1 of ($time*) and 1 of ($hash*) and 1 of ($net*)
}


rule bitcoin {
    meta:
        author = "x0r"
        description = "Perform crypto currency mining"
        classifications = "Cryptomining"
	version = "0.1"
    strings:
        $f1 = "OpenCL.dll" nocase
        $f2 = "nvcuda.dll" nocase
        $f3 = "opengl32.dll" nocase
        $s1 = "cpuminer 2.2.2X-Mining-Extensions"
        $s2 = "cpuminer 2.2.3X-Mining-Extensions"
	    $s3 = "Ufasoft bitcoin-miner/0.20"
	    $s4 = "bitcoin" nocase
	    $s5 = "stratum" nocase
    condition:
        1 of ($f*) and 1 of ($s*)
}

rule certificate {
    meta:
        author = "x0r"
        description = "Inject certificate in store"
        classifications = "Injection"
        vti_default_score = 5
        vti_documents_score = 5
        vti_scripts_score = 5
        vti_browser_score = 5
        vti_msi_score = 5
        vti_static_score = 5
	version = "0.1"
    strings:
        $f1 = "Crypt32.dll" nocase
        $r1 = "software\\microsoft\\systemcertificates\\spc\\certificates" nocase
        $c1 = "CertOpenSystemStore"
    condition:
	all of them
}

rule escalate_priv {
    meta:
        author = "x0r, updated by Femi"
        description = "Escalade priviledges"
        classifications = "Privilege Escalation"
        vti_default_score = 5
        vti_documents_score = 5
        vti_scripts_score = 5
        vti_browser_score = 5
        vti_msi_score = 5
        vti_static_score = 5
	version = "0.1"
    strings:
        $d1 = "Advapi32.dll" nocase
        $c1 = "SeDebugPrivilege"
        $c2 = "AdjustTokenPrivileges"
    condition:
        1 of ($d*) and 1 of ($c*)
}

rule screenshot {
    meta:
        author = "x0r"
        description = "Take screenshot"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
        $d1 = "Gdi32.dll" nocase
        $d2 = "User32.dll" nocase
        $c1 = "BitBlt"
        $c2 = "GetDC"
    condition:
        1 of ($d*) and 1 of ($c*)
}






rule keylogger {
    meta:
        author = "x0r"
        description = "Run a keylogger"
        classifications = "Keylogger"
        vti_default_score = 5
        vti_documents_score = 5
        vti_scripts_score = 5
        vti_browser_score = 5
        vti_msi_score = 5
        vti_static_score = 5
	version = "0.1"
    strings:
	    $f1 = "User32.dll" nocase
        $c1 = "GetAsyncKeyState"
        $c2 = "GetKeyState"
        $c3 = "MapVirtualKey"
        $c4 = "GetKeyboardType"
    condition:
        $f1 and 1 of ($c*)
}

rule cred_local {
    meta:
        author = "x0r"
        description = "Steal credential"
        classifications = "Credentials Stealer"
        vti_default_score = 5
        vti_documents_score = 5
        vti_scripts_score = 5
        vti_browser_score = 5
        vti_msi_score = 5
        vti_static_score = 5
	version = "0.1"
    strings:
        $c1 = "LsaEnumerateLogonSessions"
        $c2 = "SamIConnect"
        $c3 = "SamIGetPrivateData"
        $c4 = "SamQueryInformationUse"
        $c5 = "CredEnumerateA"
        $c6 = "CredEnumerateW"
        $r1 = "software\\microsoft\\internet account manager" nocase
        $r2 = "software\\microsoft\\identitycrl\\creds" nocase
        $r3 = "Security\\Policy\\Secrets"
    condition:
        any of them
}



rule cred_ff {
    meta:
        author = "x0r"
        description = "Steal Firefox credential"
        classifications = "Credentials Stealer"
        vti_default_score = 5
        vti_documents_score = 5
        vti_scripts_score = 5
        vti_browser_score = 5
        vti_msi_score = 5
        vti_static_score = 5
	version = "0.1"
    strings:
        $f1 = "signons.sqlite"
        $f2 = "signons3.txt"
        $f3 = "secmod.db"
        $f4 = "cert8.db"
        $f5 = "key3.db"
    condition:
        any of them
}

rule cred_vnc {
    meta:
        author = "x0r"
        description = "Steal VNC credential"
        classifications = "Credentials Stealer"
        vti_default_score = 5
        vti_documents_score = 5
        vti_scripts_score = 5
        vti_browser_score = 5
        vti_msi_score = 5
        vti_static_score = 5
	version = "0.1"
    strings:
        $s1 = "VNCPassView"
    condition:
        all of them
}


rule sniff_lan {
    meta:
        author = "x0r"
        description = "Sniff Lan network traffic"
        classifications = "Network Sniffing"
        vti_default_score = 5
        vti_documents_score = 5
        vti_scripts_score = 5
        vti_browser_score = 5
        vti_msi_score = 5
        vti_static_score = 5
	version = "0.1"
    strings:
        $f1 = "packet.dll" nocase
        $f2 = "npf.sys" nocase
        $f3 = "wpcap.dll" nocase
        $f4 = "winpcap.dll" nocase
    condition:
        any of them
}




rule spreading_share {
    meta:
        author = "x0r"
        description = "Malware can spread east-west using share drive"
        version = "0.1"
        vti_default_score = 4
        vti_documents_score = 4
        vti_scripts_score = 4
        vti_browser_score = 4
        vti_msi_score = 4
        vti_static_score = 4
    strings:
        $f1 = "netapi32.dll" nocase
        $c1 = "NetShareGetInfo"
        $c2 = "NetShareEnum"
    condition:
        $f1 and 1 of ($c*)
}

rule rat_vnc {
    meta:
        author = "x0r"
        description = "Remote Administration toolkit VNC"
        classifications = "RAT"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
        $f1 = "ultravnc.ini" nocase
        $c2 = "StartVNC"
        $c3 = "StopVNC"
    condition:
        any of them
}

rule rat_rdp {
    meta:
        author = "x0r"
        description = "Remote Administration toolkit enable RDP"
        classifications = "RAT"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
	version = "0.1"
    strings:
        $p1 = "SYSTEM\\CurrentControlSet\\Control\\Terminal Server" nocase
        $p2 = "software\\microsoft\\windows nt\\currentversion\\terminal server" nocase
        $p3 = "SYSTEM\\CurrentControlSet\\Control\\Terminal Server\\WinStations\\RDP-Tcp" nocase
        $r1 = "EnableAdminTSRemote"
        $c1 = "net start termservice"
        $c2 = "sc config termservice start"
    condition:
        any of them
}

rule rat_telnet {
    meta:
        author = "x0r"
        description = "Remote Administration toolkit enable Telnet"
        classifications = "RAT"
        version = "0.1"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
    strings:
        $r1 = "software\\microsoft\\telnetserver" nocase
    condition:
        any of them
}


rule rat_webcam {
    meta:
        author = "x0r"
        description = "Remote Administration toolkit using webcam"
        classifications = "RAT"
        version = "0.1"
        vti_default_score = 4
        vti_documents_score = 4
        vti_scripts_score = 4
        vti_browser_score = 4
        vti_msi_score = 4
        vti_static_score = 4
    strings:
        $f1 = "avicap32.dll" nocase
        $c1 = "capCreateCaptureWindow" nocase
    condition:
        all of them
}

rule win_mutex {
    meta:
        author = "x0r"
        description = "Create or check mutex"
        vti_default_score = 5
        vti_documents_score = 5
        vti_scripts_score = 5
        vti_browser_score = 5
        vti_msi_score = 5
        vti_static_score = 5
    version = "0.1"
    strings:
        $c1 = "CreateMutex"
    condition:
        1 of ($c*)
}

rule win_registry {
    meta:
        author = "x0r"
        description = "Affects system registries"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
    version = "0.1"
    strings:
        $f1 = "advapi32.dll" nocase
        $c1 = "RegQueryValueExA"
        $c2 = "RegOpenKeyExA"
        $c3 = "RegCloseKey"
        $c4 = "RegSetValueExA"
        $c5 = "RegCreateKeyA"
        $c6 = "RegCloseKey"
    condition:
        $f1 and 1 of ($c*)
}

rule win_token {
    meta:
        author = "x0r"
        description = "Affect system token"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
    version = "0.1"
    strings:
        $f1 = "advapi32.dll" nocase
        $c1 = "DuplicateTokenEx"
        $c2 = "AdjustTokenPrivileges"
        $c3 = "OpenProcessToken"
        $c4 = "LookupPrivilegeValueA"
    condition:
        $f1 and 1 of ($c*)
}



rule win_files_operation {
    meta:
        author = "x0r"
        description = "Affect private profile"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3
    version = "0.1"
    strings:
        $f1 = "kernel32.dll" nocase
        $c1 = "WriteFile"
        $c2 = "SetFilePointer"
        $c3 = "WriteFile"
        $c4 = "ReadFile"
        $c5 = "DeleteFileA"
        $c6 = "CreateFileA"
        $c7 = "FindFirstFileA"
        $c8 = "MoveFileExA"
        $c9 = "FindClose"
        $c10 = "SetFileAttributesA"
        $c11 = "CopyFile"

    condition:
        $f1 and 3 of ($c*)
}


rule Str_Win32_Winsock2_Library
{
    meta:
        author = "@adricnet"
        description = "Match Winsock 2 API library declaration"
        method = "String match"
        reference = "https://github.com/dfirnotes/rules"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3

    strings:
        $ws2_lib = "Ws2_32.dll" nocase
        $wsock2_lib = "WSock32.dll" nocase

    condition:
        (any of ($ws2_lib, $wsock2_lib))
}

rule Str_Win32_Wininet_Library
{

    meta:
        author = "@adricnet"
        description = "Match Windows Inet API library declaration"
        method = "String match"
        reference = "https://github.com/dfirnotes/rules"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3

    strings:
        $wininet_lib = "WININET.dll" nocase

    condition:
        (all of ($wininet*))
}

rule Str_Win32_Internet_API
{

    meta:
        author = "@adricnet"
        description = "Match Windows Inet API call"
        method = "String match, trim the As"
        reference = "https://github.com/dfirnotes/rules"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3

    strings:
        $wininet_call_closeh = "InternetCloseHandle"
        $wininet_call_readf = "InternetReadFile"
        $wininet_call_connect = "InternetConnect"
        $wininet_call_open = "InternetOpen"

    condition:
        (any of ($wininet_call*))
}

rule Str_Win32_Http_API
{
    meta:
        author = "@adricnet"
        description = "Match Windows Http API call"
        method = "String match, trim the As"
        reference = "https://github.com/dfirnotes/rules"
        vti_default_score = 3
        vti_documents_score = 3
        vti_scripts_score = 3
        vti_browser_score = 3
        vti_msi_score = 3
        vti_static_score = 3

    strings:
        $wininet_call_httpr = "HttpSendRequest"
        $wininet_call_httpq = "HttpQueryInfo"
        $wininet_call_httpo = "HttpOpenRequest"

     condition:
        (any of ($wininet_call_http*))
}


rule ldpreload
{
        meta:
                author="xorseed"
                reference= "https://stuff.rop.io/"
	strings:
		$a = "dlopen" nocase ascii wide
		$b = "dlsym" nocase ascii wide
		$c = "fopen" nocase ascii wide
		$d = "fopen64" nocase ascii wide
		$e = "__fxstat" nocase ascii wide
		$f = "__fxstat64" nocase ascii wide
		$g = "accept" nocase ascii wide
		$h = "__lxstat" nocase ascii wide
		$i = "__lxstat64" nocase ascii wide
		$j = "open" nocase ascii wide
		$k = "rmdir" nocase ascii wide
		$l = "__xstat" nocase ascii wide
		$m = "__xstat64" nocase ascii wide
		$n = "unlink" nocase ascii wide
		$o = "unlikat" nocase ascii wide
		$p = "fdopendir" nocase ascii wide
		$q = "opendir" nocase ascii wide
		$r = "readdir" nocase ascii wide
		$s = "readdir64" nocase ascii wide
	condition:
		($a or $b) and 5 of them
}
