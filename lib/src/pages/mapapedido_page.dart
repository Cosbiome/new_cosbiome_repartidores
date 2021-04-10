import 'package:cosbiome_repartidores/src/services/traffic_services.dart';
import 'package:cosbiome_repartidores/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:after_layout/after_layout.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cosbiome_repartidores/src/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:cosbiome_repartidores/src/bloc/mapa/mapa_bloc.dart';
import 'package:polyline/polyline.dart' as Poly;

class MapaPedido extends StatefulWidget {
  MapaPedido({Key key}) : super(key: key);

  @override
  _MapaPedidoState createState() => _MapaPedidoState();
}

class _MapaPedidoState extends State<MapaPedido>
    with AfterLayoutMixin<MapaPedido> {
  List<double> _cordenadas = [];
  // Completer<GoogleMapController> _controller = Completer();

  @override
  void didChangeDependencies() {
    List<double> initCords = ModalRoute.of(context).settings.arguments;
    if (_cordenadas.length == 0) {
      setState(() {
        _cordenadas = initCords;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    BlocProvider.of<MiUbicacionBloc>(context).inciarSeguimiento();

    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    if (await Permission.location.request().isGranted) {
      final gpsValid = await Geolocator.Geolocator.isLocationServiceEnabled();

      if (gpsValid) {
        Future.delayed(Duration(seconds: 4), ()async {
          print('cordenadas =====> $_cordenadas');

          final trafficService = new TrafficService();
          final miubicacionbloc = BlocProvider.of<MiUbicacionBloc>(context);
          final mapaBloc = BlocProvider.of<MapaBloc>(context);

          final inicio = miubicacionbloc.state.ubicacion;

          final destino = LatLng(_cordenadas[1], _cordenadas[0]);

          final trafficReponse =
              await trafficService.getCoordsIncioFin(inicio, destino);

          final geometry = trafficReponse.routes[0].geometry;
          final duracion = trafficReponse.routes[0].duration;
          final distancia = trafficReponse.routes[0].distance;

          //Decodificar los puntos del geometry
          final points =
              Poly.Polyline.Decode(encodedString: geometry, precision: 6)
                  .decodedCoords;
          final List<LatLng> rutaCoords =
              points.map((point) => LatLng(point[0], point[1])).toList();

          mapaBloc.add(OnCrearRutaInicioDestino(rutaCoords, distancia, duracion));
        });
        
      }
    }
  }

  @override
  void dispose() {
    BlocProvider.of<MiUbicacionBloc>(context).cancelarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Center(
                child: Text(
              'EN CAMINO A LA ENTREGA',
              style: TextStyle(fontSize: 12.0),
            )),
            backgroundColor: Color.fromRGBO(103, 181, 30, 1.0),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BtnMiRuta(),
              BtnSeguirUbicacion(),
            ],
          ),
          body: Center(
            child: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
                builder: (context, state) {
              return _crearMapa(state);
            }),
          )),
    );
  }

  Widget _crearMapa(MiUbicacionState state) {
    if (!state.existeUbicacion)
      return CircularProgressIndicator(
        backgroundColor: Color.fromRGBO(103, 181, 30, 1.0),
      );

    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    mapaBloc.add(OnNuevaUbicacion(state.ubicacion));

    final cameraPosition = CameraPosition(
      target: state.ubicacion,
      zoom: 15,
      bearing: 10,
      tilt: 10,
    );

    return GoogleMap(
      initialCameraPosition: cameraPosition,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      onMapCreated: mapaBloc.initMapa,
      polylines: mapaBloc.state.polylines.values.toSet(),
      onCameraMove: (cameraPosition) {
        mapaBloc.add(OnMovioMapa(cameraPosition.target));
      },
    );
  }
}
