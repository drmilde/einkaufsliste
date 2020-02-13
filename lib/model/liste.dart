import 'package:einkaufsliste/model/eintrag.dart';

class Liste {
  String name;
  List<Eintrag> inhalt;

  Liste(this.name, {this.inhalt = null}) {
    if (inhalt == null) {
      inhalt = new List<Eintrag>();
    }
  }

  void add(Eintrag e) {
    inhalt.add(e);
  }
}