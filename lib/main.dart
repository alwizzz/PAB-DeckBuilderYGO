import 'package:deck_builder_ygo/db/DecksDatabase.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';

import 'pages/home.dart';
import 'pages/loading.dart';
import 'pages/detail.dart';
import 'pages/deck_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // List<Deck> dummy = await DecksDatabase.instance.readAllDeck();
  var db = await DecksDatabase.instance.initDB('decks.db');

  return runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'YuGiOh Caps'
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
      '/detail': (context) => Detail(),
      '/deck_list': (context) => DeckList(),
    },
  ));
}
