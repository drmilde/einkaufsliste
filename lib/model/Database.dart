import 'dart:async';
import 'dart:io';

import 'package:einkaufsliste/model/eintrag.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "einkaufsliste.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Eintrag ("
          "id INTEGER PRIMARY KEY,"
          "listen_name TEXT,"
          "produkt_name TEXT,"
          "selected BIT"
          ")");
    });
  }

  newEintrag(Eintrag newEintrag) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Eintrag");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Eintrag (id,listen_name,produkt_name,selected)"
        " VALUES (?,?,?,?)",
        [id, newEintrag.listenName, newEintrag.produktName, newEintrag.selected]);
    return raw;
  }

  selectOrUnselect(Eintrag eintrag) async {
    final db = await database;
    Eintrag selected = Eintrag(
        id: eintrag.id,
        listenName: eintrag.listenName,
        produktName: eintrag.produktName,
        selected: !eintrag.selected);
    var res = await db.update("Eintrag", selected.toMap(),
        where: "id = ?", whereArgs: [eintrag.id]);
    return res;
  }

  updateEintrag(Eintrag newEintrag) async {
    final db = await database;
    var res = await db.update("Eintrag", newEintrag.toMap(),
        where: "id = ?", whereArgs: [newEintrag.id]);
    return res;
  }

  getEintrag(int id) async {
    final db = await database;
    var res = await db.query("Eintrag", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Eintrag.fromMap(res.first) : null;
  }

  Future<List<Eintrag>> getSelectedEintrag() async {
    final db = await database;

    // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
    var res = await db.query("Eintrag", where: "selected = ? ", whereArgs: [1]);

    List<Eintrag> list =
        res.isNotEmpty ? res.map((c) => Eintrag.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Eintrag>> getAlleEintraegeListe(String listenName) async {
    final db = await database;

    // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
    var res = await db.query("Eintrag", where: "listen_name = ? ", whereArgs: [listenName]);

    List<Eintrag> list =
        res.isNotEmpty ? res.map((c) => Eintrag.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Eintrag>> getAllEintrag() async {
    final db = await database;
    var res = await db.query("Eintrag");
    List<Eintrag> list =
        res.isNotEmpty ? res.map((c) => Eintrag.fromMap(c)).toList() : [];
    return list;
  }

  deleteEintrag(int id) async {
    final db = await database;
    return db.delete("Eintrag", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Eintrag");
  }
}
