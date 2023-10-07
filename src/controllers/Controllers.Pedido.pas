unit Controllers.Pedido;

interface

procedure Registry;

implementation

uses Horse, System.JSON, Services.Pedido, DataSet.Serialize, Data.DB;

procedure ListarPedidos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LRetorno : TJSONObject;
  LService: TServicePedido;
begin
  LService := TServicePedido.Create;
  try
    LRetorno := TJSONOBJect.Create;
    LRetorno.AddPair('data', LService.ListAll(Req.Query.Dictionary).ToJSONArray());
    LRetorno.AddPair('records', TJSONNumber.Create(LService.GetRecordCount));
    Res.Send(LRetorno);
  finally
    LService.Free;
  end;
end;

procedure ObterPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdPedido: string;
  LService: TServicePedido;
begin
  LService := TServicePEdido.Create;
  try
     LIdPedido := Req.Params.Items['id'];
     if LService.GetById(LIdPedido).IsEmpty then
        raise EHorseException.New.Error('Pedido não encontrado!');
     Res.Send(LService.qryCadastro.ToJSONObject());
  finally
     LService.Free;
  end;
end;

procedure CadastrarPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LPedido: TJSONOBject;
  LService: TServicePEdido;
begin
  LService := TServicePEdido.Create;
  try
     LPedido:= Req.Body<TJSONOBject>;
     if LService.Append(LPedido) then
       Res.Send(LService.qryCadastro.ToJSONObject()).Status(THTTPStatus.Created);
  finally
     LService.Free;
  end;

end;

procedure AlterarPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
 LIdPedido: string;
 LService: TServicePEdido;
 LPedido: TJSONObject;
begin
  LService := TServicePEdido.Create;
  try
    LIdPedido := Req.Params.Items['id'];
    if LService.GetById(LIdPedido).IsEmpty then
      raise EHorseException.New.Error('Pedido não cadastrado!');
     LPedido := Req.Body<TJSONObject>;
     if LService.Update(LPedido) then
       Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;

end;

procedure DeletarPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
 LIdPedido: string;
 LService: TServicePEdido;
begin
  LService := TServicePEdido.Create;
  try
     LIdPedido := req.Params.Items['id'];
     if LService.GetById(LIdPedido).IsEmpty then
       raise EHorseException.New.Error('Pedido não cadastrado!');
     if LService.Delete then
       Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;

end;

procedure Registry;
begin
  Thorse.Get('/pedidos' , ListarPedidos);
  Thorse.Get('/pedidos/:id' , ObterPedido);
  Thorse.Post('/pedidos' , CadastrarPedido);
  Thorse.Put('/pedidos/:id' , AlterarPedido);
  Thorse.Get('/pedidos/:id' , DeletarPedido);
end;

end.
