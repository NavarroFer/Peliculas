import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actor_model.dart';
import 'package:peliculas/src/models/genero_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apikey = '8a82498d21040a61f865d378dda7e5f2';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _peliculasPopulares = new List();

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    //No quiero almacenar el Future
    //Quiero esperar a la solicitud
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language,
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];

    _cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString(),
    });

    final respuesta = await _procesarRespuesta(url);
    _peliculasPopulares.addAll(respuesta);
    popularesSink(_peliculasPopulares);
    _cargando = false;
    return respuesta;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key': _apikey,
      'language': _language,
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apikey,
      'query': query,      
    });

    return await _procesarRespuesta(url);
  }

  Future<List<Genero>> getGeneres() async {

    final url = Uri.https(_url, '3/genre/movie/list', {
      'api_key': _apikey,
      'language': _language,  
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final generos = new Generos.fromJsonList(decodedData['results']);

    return generos.items;
  }
}
