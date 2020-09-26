import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Peliculas en cines'),
          backgroundColor: Colors.lime[700],
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                //Go to search page
              },
            )
          ],
        ),
        body: SafeArea(
            child: Column(
          children: [
            _swiperTarjetas(),
            _footer(),
          ],
        )));
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),

      //initialData: InitialData, Poner algun loading, no initial data
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
            height: 500,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }
      },
    );

    // return CardSwiper(peliculas: );
  }

  Widget _footer() {
    return Container(
      child: Column(
        children: [
          Text('Populares'),
        ],
      ),
      width: double.infinity, //todo el espacio del ancho
    );
  }
}
