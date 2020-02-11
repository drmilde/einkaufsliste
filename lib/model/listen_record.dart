import 'dart:convert';

ListenRecord eintragFromJson(String str) {
  final jsonData = json.decode(str);
  return ListenRecord.fromMap(jsonData);
}

String clientToJson(ListenRecord data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class ListenRecord {
  int id;
  String listenName;

  ListenRecord({
    this.id,
    this.listenName,
  });

  factory ListenRecord.fromMap(Map<String, dynamic> json) => new ListenRecord(
    id: json["id"],
    listenName: json["listen_name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "listen_name": listenName,
  };
}
