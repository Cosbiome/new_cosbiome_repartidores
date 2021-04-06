// To parse this JSON data, do
//
//     final pedidos = pedidosFromJson(jsonString);

import 'dart:convert';

Pedidos pedidosFromJson(String str) => Pedidos.fromJson(json.decode(str));

String pedidosToJson(Pedidos data) => json.encode(data.toJson());

class Pedidos {
    Pedidos({
        this.historial,
        this.id,
        this.cruces,
        this.domicilio,
        this.tipo,
        this.a,
        this.formaDePago,
        this.de,
        this.colonia,
        this.codigoPostal,
        this.nota,
        this.fechaEntrega,
        this.idCliente,
        this.estadoProv,
        this.vendedor,
        this.numTel,
        this.ciudad,
        this.numTel1,
        this.producto,
        this.nombreCliente,
        this.repartidor,
        this.subTotal,
        this.total,
        this.idPedido,
        this.fechaDeventa,
        this.idMedio,
        this.esperaRuta,
        this.publishedAt,
        this.createdAt,
        this.updatedAt,
        this.v,
        this.estatusPedido,
        this.firmaCliente,
        this.calidadEcha,
        this.pedidosId,
    });

    String historial;
    String id;
    String cruces;
    String domicilio;
    String tipo;
    String a;
    String formaDePago;
    String de;
    String colonia;
    String codigoPostal;
    String nota;
    DateTime fechaEntrega;
    String idCliente;
    String estadoProv;
    String vendedor;
    String numTel;
    String ciudad;
    String numTel1;
    List<Producto> producto;
    String nombreCliente;
    String repartidor;
    String subTotal;
    String total;
    String idPedido;
    String fechaDeventa;
    String idMedio;
    bool esperaRuta;
    DateTime publishedAt;
    DateTime createdAt;
    DateTime updatedAt;
    int v;
    String estatusPedido;
    String firmaCliente;
    dynamic calidadEcha;
    String pedidosId;

    factory Pedidos.fromJson(Map<String, dynamic> json) => Pedidos(
        historial: json["historial"],
        id: json["_id"],
        cruces: json["cruces"],
        domicilio: json["domicilio"],
        tipo: json["tipo"],
        a: json["a"],
        formaDePago: json["formaDePago"],
        de: json["de"],
        colonia: json["colonia"],
        codigoPostal: json["codigoPostal"],
        nota: json["nota"],
        fechaEntrega: DateTime.parse(json["fechaEntrega"]),
        idCliente: json["idCliente"],
        estadoProv: json["estadoProv"],
        vendedor: json["vendedor"],
        numTel: json["numTel"],
        ciudad: json["ciudad"],
        numTel1: json["numTel1"],
        producto: List<Producto>.from(json["producto"].map((x) => Producto.fromJson(x))),
        nombreCliente: json["nombreCliente"],
        repartidor: json["repartidor"],
        subTotal: json["subTotal"],
        total: json["total"],
        idPedido: json["idPedido"],
        fechaDeventa: json["fechaDeventa"],
        idMedio: json["idMedio"],
        esperaRuta: json["esperaRuta"],
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        estatusPedido: json["estatusPedido"],
        firmaCliente: json["firmaCliente"],
        calidadEcha: json["calidadEcha"],
        pedidosId: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "historial": historial,
        "_id": id,
        "cruces": cruces,
        "domicilio": domicilio,
        "tipo": tipo,
        "a": a,
        "formaDePago": formaDePago,
        "de": de,
        "colonia": colonia,
        "codigoPostal": codigoPostal,
        "nota": nota,
        "fechaEntrega": "${fechaEntrega.year.toString().padLeft(4, '0')}-${fechaEntrega.month.toString().padLeft(2, '0')}-${fechaEntrega.day.toString().padLeft(2, '0')}",
        "idCliente": idCliente,
        "estadoProv": estadoProv,
        "vendedor": vendedor,
        "numTel": numTel,
        "ciudad": ciudad,
        "numTel1": numTel1,
        "producto": List<dynamic>.from(producto.map((x) => x.toJson())),
        "nombreCliente": nombreCliente,
        "repartidor": repartidor,
        "subTotal": subTotal,
        "total": total,
        "idPedido": idPedido,
        "fechaDeventa": fechaDeventa,
        "idMedio": idMedio,
        "esperaRuta": esperaRuta,
        "published_at": publishedAt.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "estatusPedido": estatusPedido,
        "firmaCliente": firmaCliente,
        "calidadEcha": calidadEcha,
        "id": pedidosId,
    };
}

class Producto {
    Producto({
        this.producto,
        this.precio,
        this.cantidad,
    });

    String producto;
    String precio;
    String cantidad;

    factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        producto: json["producto"],
        precio: json["precio"],
        cantidad: json["cantidad"],
    );

    Map<String, dynamic> toJson() => {
        "producto": producto,
        "precio": precio,
        "cantidad": cantidad,
    };
}
