import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:cosbiome_repartidores/src/themes/uber_map_theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(new MapaState());

  GoogleMapController _mapController;

  // PolyLines
  Polyline _miRuta = Polyline(
      polylineId: PolylineId('mi_ruta'), width: 4, color: Colors.transparent);

  Polyline _miRutaDestino = Polyline(
      polylineId: PolylineId('mi_ruta_destino'),
      width: 4,
      color: Colors.green[700]);

  void initMapa(GoogleMapController controller) {
    if (!state.mapaListo) {
      this._mapController = controller;
      this._mapController.setMapStyle(jsonEncode(uberMapTheme));

      add(OnMapaListo());
    }
  }

  void moverCamara(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(MapaEvent event) async* {
    if (event is OnMapaListo) {
      yield state.copyWith(mapaListo: true);
    } else if (event is OnNuevaUbicacion) {
      yield* this._onNuevaUbicacion(event);
    } else if (event is OnMarcarRecorrido) {
      yield* this._onMarcarRecorrido(event);
    } else if (event is OnSeguirUbicacion) {
      yield* this._onSeguirUbicacion(event);
    } else if (event is OnMovioMapa) {
      yield* this._onMovioMapa(event);
    } else if (event is OnCrearRutaInicioDestino) {
      yield* this._onCrearRutaInicioDestino(event);
    }
  }

  Stream<MapaState> _onNuevaUbicacion(OnNuevaUbicacion event) async* {
    if (state.seguirUbicacion) {
      this.moverCamara(event.ubicacion);
    }

    final List<LatLng> points = [...this._miRuta.points, event.ubicacion];
    this._miRuta = this._miRuta.copyWith(pointsParam: points);

    final currentPolyLines = state.polylines;
    currentPolyLines['mi_ruta'] = this._miRuta;

    yield state.copyWith(polylines: currentPolyLines);
  }

  Stream<MapaState> _onMarcarRecorrido(OnMarcarRecorrido event) async* {
    if (!state.dibujarRecorrido) {
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.black87);
    } else {
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.transparent);
    }

    final currentPolyLines = state.polylines;
    currentPolyLines['mi_ruta'] = this._miRuta;
    yield state.copyWith(
        polylines: currentPolyLines, dibujarRecorrido: !state.dibujarRecorrido);
  }

  Stream<MapaState> _onSeguirUbicacion(OnSeguirUbicacion event) async* {
    if (!state.seguirUbicacion) {
      this.moverCamara(this._miRuta.points[this._miRuta.points.length - 1]);
    }

    yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);
  }

  Stream<MapaState> _onMovioMapa(OnMovioMapa event) async* {
    print(event.centroMapa);
    yield state.copyWith(ubicacionCentral: event.centroMapa);
  }

  Stream<MapaState> _onCrearRutaInicioDestino(
      OnCrearRutaInicioDestino event) async* {
    this._miRutaDestino =
        this._miRutaDestino.copyWith(pointsParam: event.rutaCordenadas);

    final currentPolyLines = state.polylines;
    currentPolyLines['mi_ruta_destino'] = this._miRutaDestino;

    yield state.copyWith(
      polylines: currentPolyLines
      // TODO: Marcadores
    );
  }
}
