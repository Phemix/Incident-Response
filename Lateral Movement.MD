### Lateral Movement Notes
- 4624, check different logon types, check Winlog.event_data.IP_address for upstream devices
- Event 1- Sysmon or 4688 (New Process)
- Event ID 3 - Network Connection (Sysmon)
- SMB - Event ID 5145
- Powershell (Winlog.provider_name:"*Powershell*" (Event ID 4104)
- RDP - (EVent ID 21 and 1158), Message (LOCAL or not LOCAL), dstport:3389
- BITS (Events 3, 59/60/61)
- SCHTASKS (EVents 106,129 and 4698)
