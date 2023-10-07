object ProviderConnection: TProviderConnection
  Height = 277
  Width = 201
  PixelsPerInch = 120
  object FDConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=Curso_Pooled')
    LoginPrompt = False
    Left = 64
    Top = 32
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorHome = 'C:\Fontes\ApiEcommerce\Business\'
    Left = 64
    Top = 136
  end
end
