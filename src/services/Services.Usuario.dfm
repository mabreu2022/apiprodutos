inherited ServiceUsuario: TServiceUsuario
  PixelsPerInch = 120
  inherited FDConnection: TFDConnection
    Connected = True
  end
  inherited qryPesquisa: TFDQuery
    SQL.Strings = (
      'select u.id, u.nome, u.login, u.status, u.sexo, u.telefone'
      '  from usuario u'
      'where 1 = 1')
    object qryPesquisaid: TLargeintField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object qryPesquisanome: TWideStringField
      FieldName = 'nome'
      Origin = 'nome'
      Size = 60
    end
    object qryPesquisalogin: TWideStringField
      FieldName = 'login'
      Origin = '"login"'
      Size = 30
    end
    object qryPesquisastatus: TSmallintField
      FieldName = 'status'
      Origin = 'status'
    end
    object qryPesquisasexo: TSmallintField
      FieldName = 'sexo'
      Origin = 'sexo'
    end
    object qryPesquisatelefone: TWideStringField
      FieldName = 'telefone'
      Origin = 'telefone'
      FixedChar = True
    end
  end
  inherited qryRecordCount: TFDQuery
    SQL.Strings = (
      'select count(u.id)'
      '  from usuario u'
      'where 1 = 1')
  end
  inherited qryCadastro: TFDQuery
    BeforePost = qryCadastroBeforePost
    SQL.Strings = (
      
        'select u.id, u.nome, u.login, u.senha, u.status, u.sexo, u.telef' +
        'one, u.foto'
      '  from usuario u')
    object qryCadastroid: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryCadastronome: TWideStringField
      FieldName = 'nome'
      Origin = 'nome'
      Size = 60
    end
    object qryCadastrologin: TWideStringField
      FieldName = 'login'
      Origin = '"login"'
      Size = 30
    end
    object qryCadastrosenha: TWideStringField
      FieldName = 'senha'
      Origin = 'senha'
      Size = 256
    end
    object qryCadastrostatus: TSmallintField
      FieldName = 'status'
      Origin = 'status'
    end
    object qryCadastrosexo: TSmallintField
      FieldName = 'sexo'
      Origin = 'sexo'
    end
    object qryCadastrotelefone: TWideStringField
      FieldName = 'telefone'
      Origin = 'telefone'
      FixedChar = True
    end
    object qryCadastrofoto: TBlobField
      FieldName = 'foto'
      Origin = 'foto'
      Visible = False
    end
  end
end
