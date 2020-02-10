import 'package:einkaufsliste/model/Database.dart';
import 'package:einkaufsliste/model/eintrag.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class MainScreen extends StatefulWidget {
  String listeName;

  MainScreen(this.listeName);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // data for testing
  List<Eintrag> testClients = [
    Eintrag(
        listenName: "Meine Einkaufsliste",
        produktName: "Brot",
        selected: false),
    Eintrag(
        listenName: "Meine Einkaufsliste",
        produktName: "Eier",
        selected: false),
    Eintrag(
        listenName: "Meine Einkaufsliste",
        produktName: "Milch",
        selected: false),
    Eintrag(
        listenName: "Meine Einkaufsliste",
        produktName: "Salat",
        selected: false),
    Eintrag(
        listenName: "Meine Einkaufsliste",
        produktName: "Flirt",
        selected: false),
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
        title: Text(widget.listeName),
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
                builder: (BuildContext context,
                    AsyncSnapshot<List<Eintrag>> snapshot) {
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
      drawer: Drawer(
        child: SafeArea(
          child: Drawer(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    child: Text(
                      'Einkaufslisten',
                      style: Theme.of(context).textTheme.title,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                          image: AssetImage("assets/images/tomaten.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  buildListTile(context, "Meine Einkaufsliste"),
                  Divider(
                    thickness: 2,
                  ),
                  buildListTile(context, "iot/ESP32"),
                  Divider(
                    thickness: 2,
                  ),
                  buildListTile(context, "Karneval"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildListTile(BuildContext context, String listenName) {
    return ListTile(
      title: Text(listenName),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        //Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(listenName),
          ),
        );
        //Navigator.of(context).pop();
      },
    );
  }
}
