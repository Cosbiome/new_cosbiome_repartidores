part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

class OnMapaListo extends MapaEvent {}

class OnMarcarRecorrido extends MapaEvent {}

class OnSeguirUbicacion extends MapaEvent {}

class OnCrearRutaInicioDestino extends MapaEvent {
  final List<LatLng> rutaCordenadas;
  final double distancia;
  final double duracion;

  OnCrearRutaInicioDestino(this.rutaCordenadas, this.distancia, this.duracion);
}

class OnMovioMapa extends MapaEvent {
  final LatLng centroMapa;
  OnMovioMapa(this.centroMapa);
}

class OnNuevaUbicacion extends MapaEvent {
  final LatLng ubicacion;
  OnNuevaUbicacion(this.ubicacion);
}
