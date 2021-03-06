import 'dart:convert';

Eintrag eintragFromJson(String str) {
  final jsonData = json.decode(str);
  return Eintrag.fromMap(jsonData);
}

String clientToJson(Eintrag data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Eintrag {
  int id;
  String listenName;
  String produktName;
  bool selected;
  int listPos;

  Eintrag({
    this.id,
    this.listenName,
    this.produktName,
    this.selected,
    this.listPos,
  });

  factory Eintrag.fromMap(Map<String, dynamic> json) => new Eintrag(
    id: json["id"],
    listenName: json["listen_name"],
    produktName: json["produkt_name"],
    selected: json["selected"] == 1,
    listPos: json["list_pos"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "listen_name": listenName,
    "produkt_name": produktName,
    "selected": selected,
    "list_pos": listPos,
  };
}
