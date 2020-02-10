import 'package:einkaufsliste/model/Database.dart';
import 'package:einkaufsliste/model/eintrag.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // data for testing
  List<Eintrag> testClients = [
    Eintrag(listenName: "Meine Liste", produktName: "Brot", selected: false),
    Eintrag(listenName: "Meine Liste", produktName: "Eier", selected: false),
    Eintrag(listenName: "Meine Liste", produktName: "Milch", selected: false),
    Eintrag(listenName: "Meine Liste", produktName: "Salat", selected: false),
    Eintrag(listenName: "Meine Liste", produktName: "Flirt", selected: false),
    Eintrag(
        listenName: "Meine Liste", produktName: "Schokolade", selected: false),
    Eintrag(
        listenName: "Meine Liste",
        produktName: "Veggie Würstchen",
        selected: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meine Einkaufsliste"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Eintrag rnd = testClients[math.Random().nextInt(testClients.length)];
          await DBProvider.db.newEintrag(rnd);
          setState(() {});
        },
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: FutureBuilder<List<Eintrag>>(
                future: DBProvider.db.getAllEintrag(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Eintrag>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Eintrag item = snapshot.data[index];
                        return Dismissible(
                          key: UniqueKey(),
                          background: Container(color: Colors.red),
                          onDismissed: (direction) {
                            DBProvider.db.deleteEintrag(item.id);
                          },
                          child: ListTile(
                            title: Text(item.produktName),
                            trailing: Text(item.id.toString()),
                            leading: Checkbox(
                              onChanged: (bool value) {
                                DBProvider.db.selectOrUnselect(item);
                                setState(() {});
                              },
                              value: item.selected,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Container(
              height: 50,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
