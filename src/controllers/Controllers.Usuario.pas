unit Controllers.Usuario;

interface

procedure Registry;

implementation

uses
  Horse, Services.Usuario, System.JSON, DataSet.Serialize, Data.DB, System.Classes;

procedure ListarUsuarios(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LRetorno: TJSONObject;
  LService: TServiceUsuario;
begin
  LService := TServiceUsuario.Create;
  try
    LRetorno := TJSONObject.Create;
    LRetorno.AddPair('data', LService.ListAll(Req.Query.Dictionary).ToJSONArray());
    LRetorno.AddPair('records', TJSONNumber.Create(LService.GetRecordCount));
    Res.Send(LRetorno);
  finally
    LService.Free;
  end;
end;

procedure ObterUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdUsuario: string;
  LService: TServiceUsuario;
begin
  LService := TServiceUsuario.Create;
  try
    LIdUsuario := Req.Params.Items['id'];
    if LService.GetById(LIdUsuario).IsEmpty then
     raise EHorseException.New.Error('Usuário não cadastrado');
    Res.Send(LService.qryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure CadastrarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LUsuario: TJSONObject;
  LService: TServiceUsuario;
begin
  LService := TServiceUsuario.Create;
  try
    LUsuario := Req.Body<TJSONObject>;
    if LService.Append(LUsuario) then
      Res.Send(LService.qryCadastro.TOJSONObject()).Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure AlterarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LUsuario: TJSONObject;
  LService: TServiceUsuario;
  LIdUsuario: string;
begin
  LService := TServiceUsuario.Create;
  try
    LIdUsuario := Req.Params.Items['id'];
    if LService.GetById(LIdUsuario).IsEmpty then
      raise EHorseException.New.Error('Usuário não cadastrado');
    LUsuario := Req.Body<TJSONObject>;
    if LService.Update(LUsuario) then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure DeletarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService: TServiceUsuario;
  LIdUsuario: string;
begin
  LService := TServiceUsuario.Create;
  try
    LIdUsuario := Req.Params.Items['id'];
    if LService.GetById(LIdUsuario).IsEmpty then
      raise EHorseException.New.Error('Usuário não cadastrado');
     // raise EHorseException.Create.Status(THTTPStatus.BadRequest).Error('Foto inválida');
    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure CadastrarFotoUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LFoto: TMemoryStream;
  LService: TServiceUsuario;
  LIdUsuario: string;
begin
  LService := TServiceUsuario.Create;
  try
    LIdUsuario := Req.Params.Items['id'];
    if LService.GetById(LIdUsuario).IsEmpty then
      raise EHorseException.New.Error('Usuário não cadastrado');
    LFoto := Req.Body<TMemoryStream>;
    if not Assigned(LFoto) then
      raise EHorseException.Create.Status(THTTPStatus.BadRequest).Error('Foto inválida');
    if LService.SalvarFotoUsuario(LFoto) then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure ObterFotoUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LFoto: TStream;
  LService: TServiceUsuario;
  LIdUsuario: string;
begin
  LService := TServiceUsuario.Create;
  try
    LIdUsuario := Req.Params.Items['id'];
    if LService.GetById(LIdUsuario).IsEmpty then
      raise EHorseException.Create.Status(THTTPStatus.NotFound).Error('Usuário não cadastrado');
    LFoto := LService.ObterFotoUsuario;
    if not Assigned(LFoto) then
      raise EHorseException.Create.Status(THTTPStatus.NotFound).Error('Foto não cadastrada');
    Res.Send(LFoto);
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
   THorse.Get('/usuarios', ListarUsuarios);
   THorse.Get('/usuarios/:id', ObterUsuario);
   THorse.Post('/usuarios', CadastrarUsuario);
   THorse.Put('/usuarios/:id', AlterarUsuario);
   THorse.Delete('/usuarios/:id', DeletarUsuario);
   THorse.Post('/usuarios/:id/foto', CadastrarFotoUsuario);
   THorse.Get('/usuarios/:id/foto', ObterFotoUsuario);
end;

end.
