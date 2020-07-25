Вотчдог умеет запускать майнер с задержкой, а так же перезапускать майнер, если обнаружит в его логах сообщения о некорректной шаре.

Параметры INI:

PathForLogs=C:\eth\			- Путь к логам

MinerStartBATFile=start.bat		- Имя BAT-файла, через который запускается майнер
# Оычное содержимое bat-файла:
setx GPU_FORCE_64BIT_PTR 0
setx GPU_MAX_HEAP_SIZE 100
setx GPU_USE_SYNC_OBJECTS 1
setx GPU_SINGLE_ALLOC_PERCENT 100
start /high EthDcrMiner64.exe (Если будет просто EthDcrMiner64.exe без start /high - майнер запустится в скрытом режиме, без окна)

MinerExeFile=EthDcrMiner64.exe		- имя EXE-файла майнера (для поиска среди запущенных процессов)

RigName=TestRig				- Имя риги (для указания в e-mail)

StartMinerOnStartWatchDog=1		- Запускать майнер при старте вотчдога

StartMinerLatencyInSec=5		- Задержка перед запуском майнера после старта вотчдога (в секундах)

MinerStartFailTimer=30			- Задержка после попытка старта майнера, прежде чем отправится сообщение о том, что майнер не может стартовать (в секундах)

CloseMinerOnCloseWatchDog=1		- Закрывать майнер вместе с вотчдогом

AlwaysCheckMinerLunched=1		- Всегда следить, чтобы майнер был запущен и запускать его, если он не найден среди процессов.


SendEmailOnNotStartMiner=1		- Отправлять e-mail, если майнер по каким-то причинам не стартанул

SendEmailOnGPUFail=1			- Отправлять e-mail, если вотчдог обнаружил инкорректы в логе

EmailSender=				- Почтовый адрес отправителя
 
EmailReceiver=				- Почтовый адрес получятеля

EMailHost=				- Host smtp-сервера

EMailPort=465				- Порт smtp

EMailUsername=				- Логин smtp

EMailPassword=				- Пароль smtp

EMailTested=1				- Флаг о том, что почта настроена верно (ставится после того, как тестовое письмо, отправляемое при первом запуске, пришло) 