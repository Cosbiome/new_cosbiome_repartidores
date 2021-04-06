// To parse this JSON data, do
//
//     final productosDb = productosDbFromJson(jsonString);

import 'dart:convert';

ProductosDb productosDbFromJson(String str) => ProductosDb.fromJson(json.decode(str));

String productosDbToJson(ProductosDb data) => json.encode(data.toJson());

class ProductosDb {
    ProductosDb({
        this.id,
        this.nombreProducto,
        this.precioVenta,
        this.cantidadProducto,
        this.codigoProducto,
        this.conteo,
        this.precioProducto,
        this.descuentoAplicado,
        this.enPromo,
        this.productoApartado,
        this.publishedAt,
        this.createdAt,
        this.updatedAt,
        this.v,
        this.productosDbId,
    });

    String id;
    String nombreProducto;
    String precioVenta;
    String cantidadProducto;
    String codigoProducto;
    Conteo conteo;
    String precioProducto;
    String descuentoAplicado;
    bool enPromo;
    String productoApartado;
    DateTime publishedAt;
    DateTime createdAt;
    DateTime updatedAt;
    int v;
    String productosDbId;

    factory ProductosDb.fromJson(Map<String, dynamic> json) => ProductosDb(
        id: json["_id"],
        nombreProducto: json["nombreProducto"],
        precioVenta: json["precioVenta"],
        cantidadProducto: json["cantidadProducto"],
        codigoProducto: json["codigoProducto"],
        conteo: Conteo.fromJson(json["conteo"]),
        precioProducto: json["precioProducto"],
        descuentoAplicado: json["descuentoAplicado"],
        enPromo: json["enPromo"],
        productoApartado: json["productoApartado"],
        publishedAt: DateTime.parse(json["published_at"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        productosDbId: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "nombreProducto": nombreProducto,
        "precioVenta": precioVenta,
        "cantidadProducto": cantidadProducto,
        "codigoProducto": codigoProducto,
        "conteo": conteo.toJson(),
        "precioProducto": precioProducto,
        "descuentoAplicado": descuentoAplicado,
        "enPromo": enPromo,
        "productoApartado": productoApartado,
        "published_at": publishedAt.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "id": productosDbId,
    };
}

class Conteo {
    Conteo({
        this.promos,
        this.promocion,
        this.promocionDos,
        this.promocionTres,
    });

    int promos;
    int promocion;
    int promocionDos;
    int promocionTres;

    factory Conteo.fromJson(Map<String, dynamic> json) => Conteo(
        promos: json["promos"],
        promocion: json["promocion"],
        promocionDos: json["promocionDos"],
        promocionTres: json["promocionTres"],
    );

    Map<String, dynamic> toJson() => {
        "promos": promos,
        "promocion": promocion,
        "promocionDos": promocionDos,
        "promocionTres": promocionTres,
    };
}
