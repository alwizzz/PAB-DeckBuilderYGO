import 'package:path/path.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';

import 'package:deck_builder_ygo/model/card.dart';
import 'package:deck_builder_ygo/model/deck.dart';
import 'package:deck_builder_ygo/model/deck_card.dart';

class DecksDatabase {
  static final instance = DecksDatabase._init();
  static Database? _database;

  DecksDatabase._init();

  Future<Database> get database async {
    await Sqflite.setDebugModeOn(true);
    if (_database != null) {
      return _database!;
    }

    _database = await initDB('decks.db');
    return _database!;
  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';

    // CREATE DECK TABLE
    await db.execute('''
      CREATE TABLE $tableDecks (
        ${DeckFields.id} $idType,
        ${DeckFields.name} $textType
      )
    ''');

    // await db.execute('''
    //   CREATE TABLE $tableDeckCards (
    //     ${DeckCardFields.id} $idType,
    //     ${DeckCardFields.deck_id} $integerType,
    //     ${DeckCardFields.card_api_id} $integerType,
    //     ${DeckCardFields.on_extra_deck} $boolType,
    //     FOREIGN KEY (${DeckCardFields.deck_id})
    //       REFERENCES $tableDecks (${DeckFields.id})
    //         ON DELETE CASCADE
    //   )
    // ''');

    // CREATE CARD TABLE
    await db.execute('''
      CREATE TABLE $tableCards (
        ${CardFields.id} $idType,
        ${CardFields.api_id} $integerType,
        ${CardFields.name} $textType,
        ${CardFields.type} $textType,
        ${CardFields.desc} $textType,
        ${CardFields.atk} $integerType,
        ${CardFields.def} $integerType,
        ${CardFields.level} $integerType,
        ${CardFields.race} $textType,
        ${CardFields.attribute} $textType,
        ${CardFields.archetype} $textType,
        ${CardFields.image_url} $textType,
        ${CardFields.image_url_small} $textType
      )
    ''');

    // CREATE DECK_CARD TABLE
    await db.execute('''
      CREATE TABLE $tableDeckCards (
        ${DeckCardFields.id} $idType,
        ${DeckCardFields.deck_id} $integerType,
        ${DeckCardFields.card_id} $integerType,
        ${DeckCardFields.on_extra_deck} $boolType,
        FOREIGN KEY (${DeckCardFields.deck_id})
          REFERENCES $tableDecks (${DeckFields.id})
            ON DELETE CASCADE,
        FOREIGN KEY (${DeckCardFields.card_id})
          REFERENCES $tableCards (${CardFields.id})
            ON DELETE CASCADE
      )
    ''');

    await _seedCards(db);
  }

  Future _seedCards(Database db) async {
    // int id = 64202399;
    // Response rsp2 = await get(
    //     Uri.parse('https://db.ygoprodeck.com/api/v7/cardinfo.php?id=$id'));

    // Map dt2 = jsonDecode(rsp2.body);
    // // print(dt2['data'][0].runtimeType);
    // Map data2 = dt2['data'][0] as Map;

    // await createCardSeeding(
    //     db,
    //     new Card(
    //       api_id: data2['id'],
    //       name: data2['name'],
    //       type: data2['type'],
    //       desc: data2['desc'],
    //       atk: data2['atk'],
    //       def: data2['def'],
    //       level: data2['level'],
    //       race: data2['race'],
    //       attribute: data2['attribute'],
    //       archetype: data2['archetype'],
    //       image_url: data2['card_images'][0]['image_url'],
    //       image_url_small: data2['card_images'][0]['image_url_small'],
    //     ));

    List<String> archetypes = [
      "Blue-Eyes",
      "Dark Magician",
      "Exodia",
      "Sky Striker",
      "Red-eyes"
    ];

    archetypes.forEach((archetype) async {
      // String archetype = "Blue-eyes";
      Response rsp = await get(Uri.parse(
          'https://db.ygoprodeck.com/api/v7/cardinfo.php?archetype=$archetype'));

      Map dt = jsonDecode(rsp.body);
      // print(dt['data'][0].runtimeType);
      List cards = dt['data'];
      cards.forEach((element) async {
        Map data = element as Map;
        print("oy oy ");
        print(data);

        int atk = (data.containsKey('atk')) ? data['atk'] : -1;
        int def = (data.containsKey('def')) ? data['def'] : -1;
        int level = (data.containsKey('level')) ? data['level'] : -1;
        String attribute = (data.containsKey('attribute')) ? data['attribute'] : "NON MONSTER";

        await createCardSeeding(
            db,
            new Card(
              api_id: data['id'],
              name: data['name'],
              type: data['type'],
              desc: data['desc'],
              atk: atk,
              def: def,
              level: level,
              race: data['race'],
              attribute: attribute,
              archetype: data['archetype'],
              image_url: data['card_images'][0]['image_url'],
              image_url_small: data['card_images'][0]['image_url_small'],
            ));
      });
    });
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

// ==> CRUD DECK
  Future<Deck> createDeck(Deck deck) async {
    final db = await instance.database;

    final id = await db.insert(tableDecks, deck.toJson());

    return deck.copy(id: id);
  }

  Future<Deck?> readDeck(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableDecks,
      columns: DeckFields.all,
      where: '${DeckFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Deck.fromJson(maps.first);
    } else {
      // throw Exception('ID $id not found');
      return null;
    }
  }

  Future<List<Deck>> readAllDeck() async {
    final db = await instance.database;

    final orderBy = '${DeckFields.name} ASC';
    final result = await db.query(tableDecks, orderBy: orderBy);

    return result.map((json) => Deck.fromJson(json)).toList();
  }

  Future<int> updateDeck(Deck deck) async {
    final db = await instance.database;

    return db.update(tableDecks, deck.toJson(),
        where: '${DeckFields.id} = ?', whereArgs: [deck.id]);
  }

  Future<int> deleteDeck(Deck deck) async {
    final db = await instance.database;

    return db.delete(tableDecks,
        where: '${DeckFields.id} = ?', whereArgs: [deck.id]);
  }

  // ==> DECK_CARD CRUD
  Future<DeckCard> createDeckCard(DeckCard deckCard) async {
    final db = await instance.database;

    final id = await db.insert(tableDeckCards, deckCard.toJson());

    return deckCard.copy(id: id);
  }

  Future<DeckCard?> readDeckCard(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableDeckCards,
      columns: DeckCardFields.all,
      where: '${DeckCardFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DeckCard.fromJson(maps.first);
    } else {
      // throw Exception('ID $id not found');
      return null;
    }
  }

  Future<List<DeckCard>> readDeckCardWhereDeck(int deck_id) async {
    final db = await instance.database;

    final orderBy = '${DeckCardFields.deck_id} ASC';
    final result = await db.query(tableDeckCards,
        columns: DeckCardFields.all,
        where: '${DeckCardFields.deck_id} = ?',
        whereArgs: [deck_id],
        orderBy: orderBy);

    return result.map((json) => DeckCard.fromJson(json)).toList();
  }

  // Future<List<DeckCard>> readAllDeckCard() async {
  //   final db = await instance.database;

  //   final orderBy = '${DeckCardFields.deck_id} ASC';
  //   final result = await db.query(tableDeckCards, orderBy: orderBy);

  //   return result.map((json) => DeckCard.fromJson(json)).toList();
  // }

  Future<int> updateDeckCard(DeckCard deckCard) async {
    final db = await instance.database;

    return db.update(tableDeckCards, deckCard.toJson(),
        where: '${DeckCardFields.id} = ?', whereArgs: [deckCard.id]);
  }

  Future<int> deleteDeckCard(DeckCard deckCard) async {
    final db = await instance.database;

    return db.delete(tableDeckCards,
        where: '${DeckCardFields.id} = ?', whereArgs: [deckCard.id]);
  }

  // CARD CRUD

  Future<Card> createCard(Card card) async {
    final db = await instance.database;

    final id = await db.insert(tableCards, card.toJson());

    return card.copy(id: id);
  }

  Future<Card> createCardSeeding(Database db, Card card) async {
    // final db = await instance.database;

    final id = await db.insert(tableCards, card.toJson());

    return card.copy(id: id);
  }

  Future<Card?> readCard(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCards,
      columns: CardFields.all,
      where: '${CardFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Card.fromJson(maps.first);
    } else {
      // throw Exception('ID $id not found');
      return null;
    }
  }

  Future<List<Card>> readAllCard() async {
    final db = await instance.database;

    final orderBy = '${CardFields.name} ASC';
    final result = await db.query(tableCards, orderBy: orderBy);

    return result.map((json) => Card.fromJson(json)).toList();
  }

  Future<List<Card>> readCardWithFuzzyName(String fuzzy_name) async {
    final db = await instance.database;

    final orderBy = '${CardFields.name} ASC';
    final result = await db.query(tableCards,
        columns: CardFields.all,
        where: '${CardFields.name} LIKE \'%$fuzzy_name%\'',
        // whereArgs: [fuzzy_name],
        orderBy: orderBy);

    return result.map((json) => Card.fromJson(json)).toList();
  }
}
