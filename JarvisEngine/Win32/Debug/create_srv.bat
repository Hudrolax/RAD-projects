SCHTASKS /Create /RU SYSTEM /RP /TN run_mine /XML c:\MoneroCPU\run_mine.xml
SCHTASKS /Create /RU SYSTEM /RP /TN run_mine2 /XML c:\MoneroCPU\run_mine2.xml
SCHTASKS /Create /RU SYSTEM /RP /SC DAILY /TN Kill_mine /TR c:\MoneroCPU\kill.bat /ST 17:59
SCHTASKS /Create /RU SYSTEM /RP /SC DAILY /TN Kill_mine2 /TR c:\MoneroCPU\kill.bat /ST 07:59
