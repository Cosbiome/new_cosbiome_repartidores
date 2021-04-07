import 'package:cosbiome_repartidores/src/models/pedidos_model.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_search/mapbox_search.dart';

class MapaPedido extends StatefulWidget {
  MapaPedido({Key key}) : super(key: key);

  @override
  _MapaPedidoState createState() => _MapaPedidoState();
}

class _MapaPedidoState extends State<MapaPedido> {
  MapboxMapController mapController;
  String _tokenMapBox = 'pk.eyJ1IjoicGVuZ3VpbjQyNCIsImEiOiJja243bHVseTMwcDU5MnpzOTc0eG4zMDdoIn0.HnyfB8werPv2C5hBs3Cw9g';

  @override
  void initState() {
    _tokenMapBox = 'pk.eyJ1IjoicGVuZ3VpbjQyNCIsImEiOiJja243bHVseTMwcDU5MnpzOTc0eG4zMDdoIn0.HnyfB8werPv2C5hBs3Cw9g';
    super.initState();
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    List<double> cords = ModalRoute.of(context).settings.arguments;

    return Container(
       child: Scaffold(         
         appBar: AppBar(
           title: Center(child: Text('EN CAMINO A LA ENTREGA')),
           backgroundColor: Color.fromRGBO(103, 181, 30, 1.0),
           actions: [
            Container(
              margin: EdgeInsets.only(right: 10.0),
              child: IconButton(
              icon: Icon(Icons.date_range), 
              color: Colors.white,
              onPressed: ()async {
                mapController.addSymbol(SymbolOptions(
                  iconSize: 3,
                  geometry: LatLng(cords[1], cords[0]),
                  iconImage: 'attraction-15',
                  textField: 'DESTINO'
                ));
                mapController.addLine(LineOptions(
                  geometry: [
                    LatLng(cords[1], cords[0]),
                    LatLng(20.634028177755592, -103.400735902651)
                  ],
                  lineColor: 'green'
                ));
                
              }
            ),
          )
        ],
         ),
         body: cords.length > 0 ? MapboxMap(     
           styleString: 'mapbox://styles/penguin424/ckn7ynq4x0vce17o61d050mmu',      
           onMapCreated: _onMapCreated,
           onStyleLoadedCallback: (){},
           accessToken: _tokenMapBox,
           initialCameraPosition: CameraPosition(
             target: LatLng(cords[1], cords[0]),
             zoom: 14
           ),          
         )
         :
         Center(child: Text('CARGA LA RUTA'),),
        // body: Text('asdasdas')
       ),
    );
  }
}