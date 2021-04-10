import 'package:cosbiome_repartidores/src/models/pedidos_model.dart';
import 'package:cosbiome_repartidores/src/providers/pedidos_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';

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
  List<String> _permitDays = [
    Moment.now().add(days: -3).format("yyyy-MM-dd"),
    Moment.now().add(days: -2).format("yyyy-MM-dd"),
    Moment.now().add(days: -1).format("yyyy-MM-dd"),
    Moment.now().format("yyyy-MM-dd"),
    Moment.now().add(days: 1).format("yyyy-MM-dd"),
    Moment.now().add(days: 2).format("yyyy-MM-dd"),
    Moment.now().add(days: 3).format("yyyy-MM-dd"),
  ];
  String _daySelectMenu = '';

  @override
  void initState() {    
    _daySelectMenu = Moment.now().format("yyyy-MM-dd");
    _getLocalStorage();
    super.initState();
  }

  void _getLocalStorage() async {
    SharedPreferences perfs = await SharedPreferences.getInstance();
    PedidosProvider pedidos = new PedidosProvider();
    final pedidosF = await pedidosProvider.getPedidos();

    pedidos.getPedidos();
    setState(()  {
      _usuario = perfs.getString('usuario');
      _pedidos = pedidosF;
      
      if(pedidosF.length > 0){

        _totalPedidosEnt = pedidosF.map((e) {
          if(e.estatusPedido == 'entregado') return int.parse(e.total); 

          return 0;
        }).reduce((value, element) => value + element);
      } else {
        _totalPedidosEnt = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'PEDIDOS RUTA DE $_usuario\nDINERO RECUPERADO: $_totalPedidosEnt MXN'.toUpperCase(),
            style: TextStyle(
              fontSize: 12.0
            ),
          )
        ),
        backgroundColor: Color.fromRGBO(103, 181, 30, 1.0),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.date_range), 
              color: Colors.white,
              onPressed: () {
                _menuBottomToDate(context);
              }
            ),
          )
        ],
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
                  Text('${_pedidos[index].idPedido}', style: TextStyle(color: _pedidos[index].estatusPedido != 'REPROGRAMADO' ? Colors.black : Colors.white, fontSize: 9.0),),
                  Expanded(child: SizedBox(),),
                  Text('${_pedidos[index].nombreCliente}', style: TextStyle(color:_pedidos[index].estatusPedido != 'REPROGRAMADO' ? Colors.black : Colors.white, fontSize: 9.0),),
                  Expanded(child: SizedBox(),),
                  Text('${_pedidos[index].total} MXN', style: TextStyle(color: _pedidos[index].estatusPedido != 'REPROGRAMADO' ? Colors.black : Colors.white, fontSize: 9.0),),
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

  void _menuBottomToDate(BuildContext context) {
    showModalBottomSheet(context: context, builder: (BuildContext bc) {
      return Container(      
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40)
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,              
              blurRadius: 15.0,
              offset: Offset(0.0, 0.75)
            )
          ],
        ),
        height: MediaQuery.of(context).size.height * .60,
        child: Padding(          
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 40.0,),        
              DropdownButtonFormField (                
                icon: const Icon(Icons.arrow_downward, color: Color.fromRGBO(103, 181, 30, 1.0),),
                value: _daySelectMenu,                
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Color.fromRGBO(103, 181, 30, 1.0)),
                isExpanded: true,
                onChanged: (String newValue)async {
                  final otherPeds = await pedidosProvider.getPedidosWithDate(newValue);
                  setState(() {                  
                    _daySelectMenu = newValue;
                    _pedidos = otherPeds;
                    if(otherPeds.length > 0) {
                      _totalPedidosEnt = otherPeds.map((e) {
                        if(e.estatusPedido == 'entregado') return int.parse(e.total); 

                        return 0;
                      }).reduce((value, element) => value + element);
                    } else {
                      _totalPedidosEnt = 0;
                    }
                    
                  });
                },
                decoration: InputDecoration(
                  labelText: 'FECHA DE RUTA A SELECCIONAR',
                  labelStyle: TextStyle(color: Color.fromRGBO(103, 181, 30, 1.0)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(103, 181, 30, 1.0)
                    )
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(103, 181, 30, 1.0)
                    )
                  ),
                ),
                items: _permitDays
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(child: Text(value)),
                  );
                }).toList(),
              ),
              SizedBox(height: 60.0,),
              ElevatedButton(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                  child: Text('ACTUALIZAR RUTA DEL DIA', style: TextStyle(fontSize: 10.0),),
                  
                ),
                style: ElevatedButton.styleFrom(   
                  primary: Color.fromRGBO(103, 181, 30, 1.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0) ),
                ),
                onPressed:()async {
                  final pedidosF = await pedidosProvider.getPedidos();
                  setState(() {
                    _pedidos = pedidosF;    
                    if(pedidosF.length > 0){

                      _totalPedidosEnt = pedidosF.map((e) {
                        if(e.estatusPedido == 'entregado') return int.parse(e.total); 

                        return 0;
                      }).reduce((value, element) => value + element);
                    } else {
                      _totalPedidosEnt = 0;
                    }
                  });
                }                
              ),
            ],
          ),
        ),
      );
    });
  }
}