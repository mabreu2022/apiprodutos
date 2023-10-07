unit Controllers.Produto;

interface

uses
  Horse;

procedure Registry;

implementation

uses
  Services.Produto, System.JSON, DataSet.Serialize, Data.DB;

procedure ListarProdutos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LRetorno : TJSONObject;
  LService : TServiceProduto;
begin
  LService := TServiceProduto.Create;
  try
    LRetorno:= TJSONObject.Create;
    LRetorno.AddPair('data', LService.ListAll(Req.Query.Dictionary).ToJSONArray());
    LRetorno.AddPair('records', TJSONNumber.Create(LService.GetRecordCount));
    Res.Send(LRetorno); //Tudo que passar no Send O pr�prio Horse j� vai destruir automaticamente
  finally
    LService.Free;
  end;
end;

procedure ObterProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdProduto: string;
  LService : TServiceProduto;
begin
  LService := TServiceProduto.Create;
  try
    LIdProduto := Req.Params['id'];
    if LService.GetById(LIdProduto).IsEmpty then
      raise EHorseException.New.Error('Produto n�o encontrado!');
    Res.Send(LService.qryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure CadastrarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LProduto: TJSONOBject;
  LService : TServiceProduto;
begin
  LService := TServiceProduto.Create;
  try
    LProduto := Req.Body<TJSONObject>;
    if LService.Append(LProduto) then
      Res.Send(LService.qryCadastro.ToJSONObject()).Status(THttpStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure AlterarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdProduto : string;
  LService : TServiceProduto;
  LProduto: TJSONOBject;
begin
  LService := TServiceProduto.Create;
  try
    LIdProduto := Req.Params['id'];
    if LService.GetById(LIdProduto).IsEmpty then
      raise EHorseException.New.Error('Produto n�o Cadastrado!');
    LProduto := Req.Body<TJSONObject>;
   if LSErvice.Update(LProduto) then
     Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure DeletarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdProduto : string;
  LService : TServiceProduto;
  LProduto: TJSONOBject;
begin
  LService := TServiceProduto.Create;
  try
    LIdProduto := Req.Params['id'];
    if LService.GetById(LIdProduto).IsEmpty then
      raise EHorseException.New.Error('Produto n�o Cadastrado!');
    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/produtos', ListarProdutos);
  THorse.Get('/produtos/:id', ObterProduto);
  THorse.Post('/produtos', CadastrarProduto);
  THorse.Put('/produtos/:id', AlterarProduto);
  THorse.Delete('/produtos/:id', DeletarProduto);
end;

end.
