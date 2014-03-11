What you and I need to know/remember about this project
================================================================================

Ordnerstruktur:
--------------------------------------------------------------------------------

Ordner | Inhalt 
------------- | -------------
Data | Datensätze, die dringend für das Projekt benötigt werden
libLinux | Paket-Verzeichnis für Linux
libWin | Paket-Verzeichnis für Windows
package | alle Dateien, die zum R-Paket gehören
R_Code | zusätzliche R-Dateien

Class-System:
--------------------------------------------------------------------------------

Class | Parent | Methods
------------- | ------------- | -------------
smstp | VIRTUAL | -
smstp_ | smstp | sim_generate
smstp_fe | smstp_ | sim_generate
sim_rs | data.frame | add
 |  | as.data.frame
sim_rs_fe | sim_rs | add
sim_base | list | sim


Name conventions for files
--------------------------------------------------------------------------------

Prefix | Meaning
------------- | -------------
00 | setClass
01 | setGeneric, setMethod
02 | -
03 | functions - no generics/methods
