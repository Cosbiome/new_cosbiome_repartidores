import 'package:cosbiome_repartidores/src/models/driving_response_model.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrafficService {
  // singleton

  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService() {
    return _instance;
  }

  final _dio = new Dio();
  String _token =
      'pk.eyJ1IjoicGVuZ3VpbjQyNCIsImEiOiJja243bHVseTMwcDU5MnpzOTc0eG4zMDdoIn0.HnyfB8werPv2C5hBs3Cw9g';
  String _baseUrl = 'https://api.mapbox.com/directions/v5';

  Future<DrivingResponse> getCoordsIncioFin(LatLng inicio, LatLng destino) async {
    print(inicio);
    print(destino);

    final coordString =
        '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
    final url = '$_baseUrl/mapbox/driving/$coordString';

    print(url);

    final resp = await this._dio.get(url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'true',
      'access_token': this._token,
      'language': 'es',
    });

    final data = DrivingResponse.fromJson(resp.data);

    return data;
  }
}
