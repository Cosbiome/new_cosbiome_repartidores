import 'dart:convert';

import 'package:cosbiome_repartidores/src/models/pedidos_model.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';

class PedidosProvider {

  Future<List<Pedidos>> getPedidos () async {
    SharedPreferences perfs = await SharedPreferences.getInstance();
    List<Pedidos> arrPedidos = [];
    
    String fecha = Moment.now().format("yyyy-MM-dd");
    String nombre  = perfs.getString('usuario');
    var pedidos = await http.get('https://cosbiome.online/pedidos-rutas/?fechaEntrega=$fecha&repartidor=$nombre');
    Iterable pedidosDecode = json.decode(pedidos.body);
    
    pedidosDecode.forEach((element) {
      arrPedidos.add(new Pedidos.fromJson(element));
    });

    return arrPedidos;
  }

  Future<List<Pedidos>> getPedidosWithDate (String date) async {
    SharedPreferences perfs = await SharedPreferences.getInstance();
    List<Pedidos> arrPedidos = [];
    
    String fecha = date;
    String nombre  = perfs.getString('usuario');
    var pedidos = await http.get('https://cosbiome.online/pedidos-rutas/?fechaEntrega=$fecha&repartidor=$nombre');
    Iterable pedidosDecode = json.decode(pedidos.body);
    
    pedidosDecode.forEach((element) {
      arrPedidos.add(new Pedidos.fromJson(element));
    });

    return arrPedidos;
  }

}

