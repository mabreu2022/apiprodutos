program Business;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Horse.HandleException,
  Horse.OctetStream,
  Providers.Connection in 'src\providers\Providers.Connection.pas' {ProviderConnection: TDataModule},
  Providers.Cadastro in 'src\providers\Providers.Cadastro.pas' {ProviderCadastro: TDataModule},
  Services.Produto in 'src\services\Services.Produto.pas' {ServiceProduto: TDataModule},
  Controllers.Produto in 'src\controllers\Controllers.Produto.pas',
  Services.Cliente in 'src\services\Services.Cliente.pas' {ServiceCliente: TDataModule},
  Controllers.Cliente in 'src\controllers\Controllers.Cliente.pas',
  Services.Pedido in 'src\services\Services.Pedido.pas' {ServicePedido: TDataModule},
  Controllers.Pedido in 'src\controllers\Controllers.Pedido.pas',
  Services.Pedido.Item in 'src\services\Services.Pedido.Item.pas' {ServicePedidoItem: TDataModule},
  Controllers.Pedido.Item in 'src\controllers\Controllers.Pedido.Item.pas',
  Services.Usuario in 'src\services\Services.Usuario.pas' {ServiceUsuario: TDataModule},
  Controllers.Usuario in 'src\controllers\Controllers.Usuario.pas';

begin
  THorse
   .Use(Jhonson())
   .Use(HandleException)
   .Use(OctetStream);

  Controllers.Produto.Registry;
  Controllers.Cliente.Registry;
  Controllers.Pedido.Registry;
  Controllers.Pedido.Item.Registry;
  Controllers.Usuario.Registry;

  THorse.Listen(9000);
end.
