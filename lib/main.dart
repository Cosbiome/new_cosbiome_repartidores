import 'package:cosbiome_repartidores/src/pages/datellePedidos_page.dart';
import 'package:cosbiome_repartidores/src/pages/login_page.dart';
import 'package:cosbiome_repartidores/src/pages/mapapedido_page.dart';
import 'package:cosbiome_repartidores/src/pages/pedidos_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cosbiome_repartidores/src/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:cosbiome_repartidores/src/bloc/mapa/mapa_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MiUbicacionBloc()),
        BlocProvider(create: (_) => MapaBloc()),
      ],
      child: MaterialApp(
        title: 'SOAL NATURA REPARTIDORES',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'listapedidos': (BuildContext context) => PedidosPage(),
          'detallepedido': (BuildContext context) => DetallePedido(),
          'mapaEntrega': (BuildContext context) => MapaPedido(),
        },
      ),
    );
  }
}
