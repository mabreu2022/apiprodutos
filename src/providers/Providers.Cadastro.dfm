inherited ProviderCadastro: TProviderCadastro
  Width = 630
  PixelsPerInch = 120
  object qryPesquisa: TFDQuery
    CachedUpdates = True
    Connection = FDConnection
    Left = 464
    Top = 32
  end
  object qryRecordCount: TFDQuery
    CachedUpdates = True
    Connection = FDConnection
    Left = 344
    Top = 32
    object qryRecordCountCOUNT: TLargeintField
      FieldName = 'COUNT'
    end
  end
  object qryCadastro: TFDQuery
    CachedUpdates = True
    Connection = FDConnection
    Left = 216
    Top = 32
  end
end
