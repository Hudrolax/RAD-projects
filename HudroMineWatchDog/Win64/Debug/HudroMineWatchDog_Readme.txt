������� ����� ��������� ������ � ���������, � ��� �� ������������� ������, ���� ��������� � ��� ����� ��������� � ������������ ����.

��������� INI:

PathForLogs=C:\eth\			- ���� � �����

MinerStartBATFile=start.bat		- ��� BAT-�����, ����� ������� ����������� ������
# ������ ���������� bat-�����:
setx GPU_FORCE_64BIT_PTR 0
setx GPU_MAX_HEAP_SIZE 100
setx GPU_USE_SYNC_OBJECTS 1
setx GPU_SINGLE_ALLOC_PERCENT 100
start /high EthDcrMiner64.exe (���� ����� ������ EthDcrMiner64.exe ��� start /high - ������ ���������� � ������� ������, ��� ����)

MinerExeFile=EthDcrMiner64.exe		- ��� EXE-����� ������� (��� ������ ����� ���������� ���������)

RigName=TestRig				- ��� ���� (��� �������� � e-mail)

StartMinerOnStartWatchDog=1		- ��������� ������ ��� ������ ��������

StartMinerLatencyInSec=5		- �������� ����� �������� ������� ����� ������ �������� (� ��������)

MinerStartFailTimer=30			- �������� ����� ������� ������ �������, ������ ��� ���������� ��������� � ���, ��� ������ �� ����� ���������� (� ��������)

CloseMinerOnCloseWatchDog=1		- ��������� ������ ������ � ���������

AlwaysCheckMinerLunched=1		- ������ �������, ����� ������ ��� ������� � ��������� ���, ���� �� �� ������ ����� ���������.


SendEmailOnNotStartMiner=1		- ���������� e-mail, ���� ������ �� �����-�� �������� �� ���������

SendEmailOnGPUFail=1			- ���������� e-mail, ���� ������� ��������� ���������� � ����

EmailSender=				- �������� ����� �����������
 
EmailReceiver=				- �������� ����� ����������

EMailHost=				- Host smtp-�������

EMailPort=465				- ���� smtp

EMailUsername=				- ����� smtp

EMailPassword=				- ������ smtp

EMailTested=1				- ���� � ���, ��� ����� ��������� ����� (�������� ����� ����, ��� �������� ������, ������������ ��� ������ �������, ������) 