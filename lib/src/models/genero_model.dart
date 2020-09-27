class Generos {
  List<Genero> items = new List();

  Generos.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((element) {
      final genero = Genero.fromJsonMap(element);
      items.add(genero);
    });
  }
}

class Genero {
  int id;
  String name;

  Genero({
    this.id,
    this.name,
  });

  Genero.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  
}
