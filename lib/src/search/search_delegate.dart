import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  final peliculasProvider = new PeliculasProvider();  

   @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro Appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del Appbar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    if (query.isEmpty) return Container();

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula) {
              return ListTile(
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text(pelicula.title),
                leading: FadeInImage(
                  fit: BoxFit.contain,
                  width: 40.0,
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  image: NetworkImage(
                    pelicula.getPosterImg(),
                  ),
                ),
                onTap: () {
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _creaElemento(Pelicula peli, BuildContext context) {
    return ListTile(
      leading: Icon(Icons.movie),
      title: Text(peli.title),
      trailing: FadeInImage(
        fit: BoxFit.contain,
        width: 50.0,
        placeholder: AssetImage('assets/img/no-image.jpg'),
        image: NetworkImage(
          peli.getPosterImg(),
        ),
      ),
      onTap: () {
        //showResults(context); //Construye los resultados
      },
    );
  }

  //  @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Crea los resultados que vamos a mostrar
  //   final listaSugerida = (query.isEmpty)
  //       ? peliculasRecientes
  //       : peliculas.where((peli) {
  //           return peli.toLowerCase().startsWith(query.toLowerCase());
  //         }).toList();

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, index) {
  //       return _creaElemento(listaSugerida[index], context);
  //     },
  //   );
  // }
}
