unit Controllers.Pedido.Item;

interface

procedure Registry;

implementation

uses
  Horse, Services.Pedido.Item, System.JSON, DataSet.Serialize, Data.DB;

procedure ListarItens(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LRetorno : TJSONObject;
  LService : TServicePedidoItem;
  LIdPedido: string;
begin
  LService := TServicePedidoItem.Create;
  try
    LIdPedido := Req.Params.Items['id_pedido'];
    LRetorno :=  TJSONObject.Create;
    LRetorno.AddPair('data', LService.ListallByPedido(Req.Query.Dictionary, LIdPedido).ToJSONArray());
    LRetorno.AddPair('records', TJSONNumber.Create(LService.GetRecordCount));
    Res.Send(LRetorno);
  finally
    LService.Free;
  end;
end;

procedure ObterItens(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicePedidoItem;
  LIdPedido, LIdItem: string;
begin
  LService := TServicePedidoItem.Create;
  try
    LIdPedido := Req.Params.Items['id_pedido'];
    LIdItem   := Req.Params.Items['id_item'];
    if LService.GetByPedido(LIdPedido, LIdItem).IsEmpty then
      raise EHorseException.New.Error('Item n�o cadastrado');
    Res.Send(LService.qryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure CadastrarItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LItem : TJSONObject;
  LService : TServicePedidoItem;
  LIdPedido: string;
begin
  LService := TServicePedidoItem.Create;
  try
    LItem:= Req.Body<TJSONObject>;
    LIdPedido := Req.Params.Items['id_pedido'];
    LItem.RemovePair('idPedido').Free;
    LItem.AddPair('idPedido', TJSONNUmber.Create(LIdPedido));
    if Lservice.Append(LItem) then
      Res.Send(LService.qryCadastro.ToJSONObject()).Status(THTTPStatus.Created);

  finally
    LService.Free;
  end;
end;

procedure AlterarItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var

  LService : TServicePedidoItem;
  LIdPedido, LIdItem: string;
  LItem: TJSONObject;
begin
  LService := TServicePedidoItem.Create;
  try
     LIdItem := Req.Params.Items['id_item'];
     LIdPedido := Req.Params.Items['id_pedido'];
     if LService.GetByPedido(LIdPedido, LIdItem).IsEmpty then
      raise EHorseException.New.Error('Item n�o cadastrado');
     LItem := Req.Body<TJSONObject>;
     LItem.RemovePair('idPedido').Free;
     if LService.Update(LItem) then
       Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure DeletarItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicePedidoItem;
  LIdPedido, LIdItem: string;
begin
  LService := TServicePedidoItem.Create;
  try
     LIdItem := Req.Params.Items['id_item'];
     LIdPedido := Req.Params.Items['id_pedido'];
     if LService.GetByPedido(LIdPedido, LIdItem).IsEmpty then
      raise EHorseException.New.Error('Item n�o cadastrado');
     if LService.Delete then
       Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  Thorse.Get('/pedidos/:id_pedido/itens', ListarItens);
  Thorse.Get('/pedidos/:id_pedido/itens/:id_item', ObterItens);
  Thorse.POST('/pedidos/:id_pedido/itens', CadastrarItem);
  Thorse.Put('/pedidos/:id_pedido/itens/:id_item', AlterarItem);
  Thorse.Delete('/pedidos/:id_pedido/itens/:id_item', DeletarItem);
end;

end.
