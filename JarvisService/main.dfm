object JarvisService: TJarvisService
  OldCreateOrder = False
  AllowPause = False
  DisplayName = 'JarvisService'
  OnExecute = ServiceExecute
  OnStop = ServiceStop
  Height = 150
  Width = 215
  object tcpserverserver: TIdTCPServer
    Bindings = <>
    DefaultPort = 27030
    OnExecute = tcpserverserverExecute
    Left = 40
    Top = 24
  end
  object client: TIdTCPClient
    ConnectTimeout = 100
    IPVersion = Id_IPv4
    Port = 27033
    ReadTimeout = 300
    Left = 120
    Top = 24
  end
  object Timer1: TTimer
    Interval = 10000
    OnTimer = Timer1Timer
    Left = 88
    Top = 80
  end
end
