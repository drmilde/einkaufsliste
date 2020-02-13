import 'daten.dart';
import 'eintrag.dart';
import 'liste.dart';

class DataModel {
  static Daten daten;

  DataModel() {
    daten = new Daten();
    initDaten();
  }

  void initDaten() {
    Liste l1 = new Liste("Meine Liste");
    l1.add(Eintrag(
      listenName: "Meine Liste",
      produktName: "Brot",
      selected: false,
      listPos: 0,
    ));

    Liste l2 = new Liste("ios/Apple");
    Liste l3 = new Liste("esp32");
  }
}
