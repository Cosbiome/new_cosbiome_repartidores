import 'package:cosbiome_repartidores/src/models/pedidos_model.dart';
import 'package:cosbiome_repartidores/src/providers/pedidos_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PedidosPage extends StatefulWidget {
  PedidosPage({Key key}) : super(key: key);

  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {

  String _usuario;
  PedidosProvider pedidosProvider = new PedidosProvider();
  List<Pedidos> _pedidos = [];
  int _totalPedidosEnt = 0;

  @override
  void initState() {    
    super.initState();
    _getLocalStorage();
  }

  void _getLocalStorage() async {
    SharedPreferences perfs = await SharedPreferences.getInstance();
    PedidosProvider pedidos = new PedidosProvider();
    final pedidosF = await pedidosProvider.getPedidos();

    pedidos.getPedidos();
    setState(()  {
      _usuario = perfs.getString('usuario');
      _pedidos = pedidosF;
      _totalPedidosEnt = pedidosF.map((e) {
        if(e.estatusPedido == 'entregado') return int.parse(e.total); 

        return 0;
      }).reduce((value, element) => value + element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('PEDIDOS RUTA DE $_usuario\nDINERO RECUPERADO: $_totalPedidosEnt MXN'.toUpperCase())
        ),
        backgroundColor: Color.fromRGBO(103, 181, 30, 1.0),
      ),
      body: _pedidos.length > 0 ? 
        ListView.separated(
        padding: EdgeInsets.only(top: 10.0),
        itemCount: _pedidos.length,
        itemBuilder: (BuildContext context, int index) { 
          return InkWell(
            onTap: _pedidos[index].esperaRuta ? () {              
              Navigator.pushNamed(context, 'detallepedido', arguments: _pedidos[index]);
            }
            :
            null,
            child: Container(
              decoration: BoxDecoration(
                color: _pedidos[index].estatusPedido == 'REPROGRAMADO' ? Colors.red : _pedidos[index].estatusPedido == 'entregado' ? Colors.green : Colors.white
              ),
              height: 60,              
              child: Row( 
                children: [
                  SizedBox(width: 20.0,),
                  Text('${_pedidos[index].idPedido}', style: TextStyle(color: _pedidos[index].estatusPedido != 'REPROGRAMADO' ? Colors.black : Colors.white),),
                  Expanded(child: SizedBox(),),
                  Text('${_pedidos[index].nombreCliente}', style: TextStyle(color:_pedidos[index].estatusPedido != 'REPROGRAMADO' ? Colors.black : Colors.white),),
                  Expanded(child: SizedBox(),),
                  Text('${_pedidos[index].total} MXN', style: TextStyle(color: _pedidos[index].estatusPedido != 'REPROGRAMADO' ? Colors.black : Colors.white),),
                  SizedBox(width: 20.0,),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(color: Color.fromRGBO(103, 181, 30, 1.0), ),
      )
      :
      Center(child: CircularProgressIndicator()),
    );
  }
}