import 'package:einkaufsliste/model/Database.dart';
import 'package:einkaufsliste/model/eintrag.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  String listenName;

  MainScreen(this.listenName);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _textProduktController = TextEditingController();
  final TextEditingController _textListeController = TextEditingController();

  List<Auswahl> settingStrings = [
    Auswahl("Listen verwalten", () {
      print("listen verwalten");
    }),
    Auswahl("Freunden empfehlen", () {
      print("freunden empfehlen");
    }),
    Auswahl("Einstellungen", () {
      print("einstellungen");
    }),
  ];

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
        listenName: "Meine Einkaufsliste",
        produktName: "Schokolade",
        selected: false),
    Eintrag(
        listenName: "Meine Einkaufsliste",
        produktName: "Veggie Würstchen",
        selected: false),
    // Karneval
    Eintrag(listenName: "Karneval", produktName: "Pappnase", selected: false),
    Eintrag(listenName: "Karneval", produktName: "Roter Hut", selected: false),
    Eintrag(listenName: "Karneval", produktName: "Spockohren", selected: false),
    // IoT
    Eintrag(
        listenName: "iot/ESP32", produktName: "esp32 Wroom", selected: false),
    Eintrag(listenName: "iot/ESP32", produktName: "i2s chip", selected: false),
    Eintrag(
        listenName: "iot/ESP32",
        produktName: "esp32 camera module",
        selected: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
      drawer: buildCustomDrawer(context),
    );
  }

  Container buildBody(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Scrollbar(
              child: FutureBuilder<List<Eintrag>>(
                //future: DBProvider.db.getAllEintrag(),
                future: DBProvider.db.getAlleEintraegeListe(widget.listenName),
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
                            title: Text(
                              item.produktName,
                              style: Theme.of(context).textTheme.title,
                            ),
                            trailing: Text(
                              item.id.toString(),
                              style: Theme.of(context).textTheme.body2,
                            ),
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      // Setting maxLines=null makes the text field auto-expand when one
                      // line is filled up.
                      maxLines: 1,
                      maxLength: 100,
                      decoration:
                          InputDecoration.collapsed(hintText: "Füge hinzu"),
                      controller: _textProduktController,
                      onSubmitted: (String text) {
                        _submitText();
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _submitText,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(widget.listenName),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.delete),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.share),
        ),
        PopupMenuButton<Auswahl>(
          onSelected: (a) {
            a.callback();
          },
          itemBuilder: (BuildContext context) {
            return settingStrings.map((Auswahl choice) {
              return PopupMenuItem<Auswahl>(
                  value: choice, child: Text(choice.title));
            }).toList();
          },
        )
      ],
    );
  }

  SafeArea buildCustomDrawer(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Neue Liste erstellen",
                        style: Theme.of(context).textTheme.title,
                      ),
                      Icon(Icons.add),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitText() async {
    String text = _textProduktController.text.trim();

    if (text.length > 0) {
      Eintrag e = Eintrag(
          listenName: widget.listenName, produktName: text, selected: false);
      //Eintrag rnd = testClients[math.Random().nextInt(testClients.length)];

      await DBProvider.db.newEintrag(e);
    }
    setState(() {
      _textProduktController.clear();
    });
  }

  void _erstelleNeueListe() async {
    String text = _textListeController.text.trim();

    if (text.length > 0) {
      // TODO Eintrag in Listennamen erzeugen
      /*
      Eintrag e = Eintrag(
          listenName: widget.listenName, produktName: text, selected: false);
      //Eintrag rnd = testClients[math.Random().nextInt(testClients.length)];

      await DBProvider.db.newEintrag(e);
       */
    }
    setState(() {
      _textListeController.clear();
    });
  }

  ListTile buildListTile(BuildContext context, String listenName) {
    return ListTile(
      title: Text(listenName),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        //Navigator.of(context).pop();
        Navigator.pushReplacement(
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

class Auswahl {
  String title;
  VoidCallback callback;

  Auswahl(this.title, this.callback);
}
