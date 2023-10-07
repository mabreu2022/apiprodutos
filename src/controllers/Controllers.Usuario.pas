unit Controllers.Usuario;

interface

procedure Registry;

implementation

uses
  Horse, Services.Usuario, System.JSON, DataSet.Serialize, Data.DB;

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
     raise EHorseException.New.Error('Usu�rio n�o cadastrado');
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
      raise EHorseException.New.Error('Usu�rio n�o cadastrado');
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
      raise EHorseException.New.Error('Usu�rio n�o cadastrado');
    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);
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
end;

end.
