import 'dart:convert';
import 'dart:io';

import 'package:cosbiome_repartidores/src/models/pedidos_model.dart';
import 'package:cosbiome_repartidores/src/models/producto_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_search/mapbox_search.dart';

class DetallePedido extends StatefulWidget {
  DetallePedido({Key key}) : super(key: key);

  @override
  _DetallePedidoState createState() => _DetallePedidoState();
}

class _DetallePedidoState extends State<DetallePedido> {
  final _formKey = GlobalKey<FormState>();
  String _firma = '';
  String _tokenMapBox = 'pk.eyJ1IjoicGVuZ3VpbjQyNCIsImEiOiJja243bHVseTMwcDU5MnpzOTc0eG4zMDdoIn0.HnyfB8werPv2C5hBs3Cw9g';

  @override
  Widget build(BuildContext context) {
    final Pedidos pedido = ModalRoute.of(context).settings.arguments;
    final size = MediaQuery.of(context).size;

    var placesSearch = PlacesSearch(
      apiKey: _tokenMapBox,
      limit: 1,
    );

    Future<List<MapBoxPlace>> getPlaces() async {
      String busqueda = '${pedido.domicilio} ${pedido.colonia} ${pedido.ciudad} ${pedido.estadoProv} Mexico'.replaceAll('#', '');
      final data = await placesSearch.getPlaces(busqueda);
      return data;
    }

   

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('PEDIDO ${pedido.idPedido}')),
        backgroundColor: Color.fromRGBO(103, 181, 30, 1.0),
         actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.map), 
              color: Colors.white,
              onPressed: () async {
                final direccion = await getPlaces();
                final cordenadas = direccion[0].geometry.coordinates;
                
                Navigator.pushNamed(context, 'mapaEntrega', arguments: cordenadas);
              }
            ),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [
          ListTile(tileColor: Color.fromRGBO(130, 130, 130, 0.1), title: Center(child: Text('Detalle del pedido', style: TextStyle(fontSize: 22),),),),          
          SizedBox(height: 10.0,),
          ListBody(
            children: [
              Text('Nombre del cliente: ${pedido.nombreCliente}', style: TextStyle(fontSize: 16)),
              Divider(color: Color.fromRGBO(103, 181, 30, 1.0),),
              Text('Vendedor del cleinte: ${pedido.vendedor}', style: TextStyle(fontSize: 16)),
              Divider(color: Color.fromRGBO(103, 181, 30, 1.0),),
              Text('Repartidor de entrega: ${pedido.repartidor}', style: TextStyle(fontSize: 16)),
              Divider(color: Color.fromRGBO(103, 181, 30, 1.0),),
              Text('Entrega de ${pedido.de} - ${pedido.a}', style: TextStyle(fontSize: 16)),
              Divider(color: Color.fromRGBO(103, 181, 30, 1.0),),
              Text('Metodo de pago: ${pedido.formaDePago}', style: TextStyle(fontSize: 16)),
              Divider(color: Color.fromRGBO(103, 181, 30, 1.0),),
            ],
          ),
          SizedBox(height: 20.0,),
          ListTile(tileColor: Color.fromRGBO(130, 130, 130, 0.1), title: Center(child: Text('Direccion de entrega', style: TextStyle(fontSize: 22),),),),          
          SizedBox(height: 10.0,),
          ListBody(
            children: [
              Text('Direccion: ${pedido.domicilio}', style: TextStyle(fontSize: 16)),
              Divider(color: Color.fromRGBO(103, 181, 30, 1.0),),
              Text('Cruces: ${pedido.cruces}', style: TextStyle(fontSize: 16)),
              Divider(color: Color.fromRGBO(103, 181, 30, 1.0),),
              Text('Colonia: ${pedido.colonia}', style: TextStyle(fontSize: 16)),
              Divider(color: Color.fromRGBO(103, 181, 30, 1.0),),
              Text('Ciudad: ${pedido.ciudad}', style: TextStyle(fontSize: 16)),
              Divider(color: Color.fromRGBO(103, 181, 30, 1.0),),
              Text('Estado: ${pedido.estadoProv}', style: TextStyle(fontSize: 16)),
              Divider(color: Color.fromRGBO(103, 181, 30, 1.0),),
              Text('Codigo postal: ${pedido.codigoPostal}', style: TextStyle(fontSize: 16)),
              Divider(color: Color.fromRGBO(103, 181, 30, 1.0),),
            ],            
          ),
          SizedBox(height: 20.0,),
          _createTable(pedido),
          SizedBox(height: 20.0,),
          ListTile(tileColor: Color.fromRGBO(130, 130, 130, 0.1), title: Center(child: Text('Confirmacion del cliente', style: TextStyle(fontSize: 22),),),),          
          SizedBox(height: 10.0,),
          ListBody(
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  decoration: InputDecoration(                    
                    labelText: 'Firma del cliente',                    
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(103, 181, 30, 1.0)
                      ),                      
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(103, 181, 30, 1.0)
                      ),                      
                    ),
                    labelStyle: TextStyle(color:  Color.fromRGBO(103, 181, 30, 1.0))
                    
                  ),
                  style: TextStyle(color:  Color.fromRGBO(103, 181, 30, 1.0)),
                  cursorColor: Color.fromRGBO(103, 181, 30, 1.0),
                  onChanged: (value) {
                    setState(() {                      
                      _firma = value;
                    });
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'La firma es necesaria';
                    }                    
                  },
                ),
              ),
              SizedBox(height: 20.0,),
              Row(
                children: [
                  ElevatedButton(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: size.height * .03, vertical: 15.0),
                      child: Text('ENTREGAR'),
                      
                    ),
                    style: ElevatedButton.styleFrom(   
                      primary: Color.fromRGBO(103, 181, 30, 1.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0) ),
                    ),
                    onPressed: () async {
                      try {
                        if(_formKey.currentState.validate()){
                          pedido.firmaCliente = _firma;
                          pedido.esperaRuta = false;
                          pedido.estatusPedido = 'entregado';
                          final pedidoJson = jsonEncode(pedido.toJson());
                          await http.put('https://cosbiome.online/pedidos-rutas/${pedido.id}', body: pedidoJson,
                            headers: {
                              HttpHeaders.contentTypeHeader: "application/json"
                            }
                          );
                          Navigator.pushNamed(context, 'listapedidos');                        
                        }
                      } catch (e) {
                        print(e);
                      }                      
                    },
                  ),
                  Expanded(child: SizedBox(),),
                  ElevatedButton(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: size.height * .03, vertical: 15.0),
                      child: Text('REGRESAR'),
                      
                    ),
                    style: ElevatedButton.styleFrom(   
                      primary: Color.fromRGBO(240, 52, 52, 1.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0) ),
                    ),
                    onPressed: () async {
                      try {
                        print(pedido.producto);
                        pedido.producto.forEach((e) async {
                          final productoDB = await http.get('https://cosbiome.online/productos/?nombreProducto=${e.producto}');
                          List<dynamic> productoDecode2 =  json.decode(productoDB.body);
                          ProductosDb productoDecode = new ProductosDb.fromJson(productoDecode2[0]);                          
                          int cantidadNeva = int.parse(productoDecode.cantidadProducto) + int.parse(e.cantidad);
                          productoDecode.cantidadProducto = cantidadNeva.toString();
                          String id = productoDecode.id;
                                                    
                          await http.put('https://cosbiome.online/productos/$id', body: productosDbToJson(productoDecode),
                            headers: {
                              HttpHeaders.contentTypeHeader: "application/json"
                            }
                          );                          
                        });

                        pedido.esperaRuta = false;
                        pedido.estatusPedido = 'REPROGRAMADO';
                        pedido.numTel1 = pedido.numTel;

                        await http.put('https://cosbiome.online/pedidos-rutas/${pedido.id}', body: pedidosToJson(pedido),
                          headers: {
                            HttpHeaders.contentTypeHeader: "application/json"
                          }
                        );

                        pedido.idPedido = pedido.idPedido + 'R';

                        await http.post('https://cosbiome.online/preventa-calidads', body: pedidosToJson(pedido),
                          headers: {
                            HttpHeaders.contentTypeHeader: "application/json"
                          }
                        );

                        Navigator.pushNamed(context, 'listapedidos');  

                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ],
              )
            ],            
          ),
        ],
      )
    );
  }

  Widget _createTable(Pedidos _venta) {
    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(children: <Widget>[
          Container(
            color: Color.fromRGBO(103, 181, 30, 1.0),
            height: 48,
            child: Center(
              child: Text('PRODUCTO'),
            )
          ),
          Container(
            color: Color.fromRGBO(103, 181, 30, 1.0),
            height: 48,
            child: Center(
              child: Text('CANTIDAD'),
            )
          ),       
          Container(
            color: Color.fromRGBO(103, 181, 30, 1.0),
            height: 48,
            child: Center(
              child: Text('PRECIO'),
            )
          ),          
        ]),
        ..._generadorProducto(_venta),
        TableRow(children: <Widget>[
          Container(
            color: Color.fromRGBO(103, 181, 30, 0.1),
            height: 48,
            child: Center(
              child: Text('TOTAL'),
            )
          ),
           Container(
            color: Color.fromRGBO(103, 181, 30, 0.1),
            height: 48,
            child: Center(
              child: Text(_venta.producto.map((a) => int.parse(a.cantidad)).reduce((value, element) => value + element).toString(),
            )
          )),
          Container(
            color: Color.fromRGBO(103, 181, 30, 0.1),
            height: 48,
            child: Center(
              child: Text(_venta.total + ' MXN'),
            )
          ),
        ]),
      ],
    );
  }

  List<TableRow> _generadorProducto(Pedidos _venta) {
    if (_venta == null) return [];

    final List<TableRow> productos = _venta.producto
        .map<TableRow>((a) => TableRow(
              children: [
                Container(
                  color: Color.fromRGBO(103, 181, 30, 0.1),
                  padding: EdgeInsets.all(5.0),
                  height: 48,
                  child: Center(
                    child: Text(a.producto),
                  )
                ),
                Container(
                  color: Color.fromRGBO(103, 181, 30, 0.1),
                  height: 48,
                  child: Center(
                    child: Text(a.cantidad.toString()),
                  )
                ),   
                Container(
                  color: Color.fromRGBO(103, 181, 30, 0.1),
                  height: 48,
                  child: Center(
                    child: Text(a.precio.toString() + ' MXN'),
                  )
                ),
              ],
            ))
        .toList();

    return productos;
  }
}