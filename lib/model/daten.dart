import 'package:flutter/cupertino.dart';

import 'liste.dart';

class Daten {
  Map<String, Liste> daten;

  Daten() {
    daten = new Map<String, Liste>();
  }

  void add(String name, Liste liste) {
    daten[name] = liste;
  }

  Liste get(String name) {
    if (daten.containsKey(name)) {
      return daten[name];
    }
    return null;
  }


}
