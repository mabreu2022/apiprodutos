unit Services.Pedido.Item;

interface

uses
  System.SysUtils, System.Classes, Providers.Cadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.JSON, System.Generics.Collections;

type
  TServicePedidoItem = class(TProviderCadastro)
    qryPesquisaid: TLargeintField;
    qryPesquisaid_produto: TLargeintField;
    qryPesquisavalor: TFMTBCDField;
    qryPesquisaquantidade: TFMTBCDField;
    qryPesquisanome_produto: TWideStringField;
    qryCadastroid: TLargeintField;
    qryCadastroid_pedido: TLargeintField;
    qryCadastroid_produto: TLargeintField;
    qryCadastrovalor: TFMTBCDField;
    qryCadastroquantidade: TFMTBCDField;
    qryCadastronome_produto: TWideStringField;
  private
    { Private declarations }
  public
    { Public declarations }
    function Append(const AJson: TJSONObject) : Boolean; override;
    function ListallByPedido(const AParams: TDictionary<string, string>; const AIdPedido: string): TFDquery;
    function GetByPedido(const AIdPedido, AIdItem: string): TFDQuery;

  end;

var
  ServicePedidoItem: TServicePedidoItem;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TServicePedidoItem }

function TServicePedidoItem.Append(const AJson: TJSONObject): Boolean;
begin
  Result := inherited Append(AJSon);
  qryCadastroid_pedido.Visible:= False;
end;


function TServicePedidoItem.GetByPedido(const AIdPedido,
  AIdItem: string): TFDQuery;
begin
  qryCadastroid_pedido.Visible:= False;
  qryCadastro.SQL.Add('where i.id = :id');
  qryCadastro.SQL.Add(' and i.id_pedido = :id_pedido');
  qryCadastro.ParamByName('id').AsLargeInt := AIdItem.ToInt64;
  qryCadastro.ParamByName('id_pedido').AsLargeInt := AIdPedido.ToInt64;
  qryCadastro.Open();
  Result := qryCadastro;
end;

function TServicePedidoItem.ListallByPedido(
  const AParams: TDictionary<string, string>;
  const AIdPedido: string): TFDquery;
begin
  qryPesquisa.ParamByName('id_pedido').AsLargeInt := AIdPedido.ToInt64;
  qryRecordCount.ParamByName('id_pedido').AsLargeInt := AIdPedido.ToInt64;
  Result := ListAll(AParams);
end;

end.
