import 'package:flutter/material.dart';
import 'package:deck_builder_ygo/model/card.dart' as DBCard;
import 'package:deck_builder_ygo/db/DecksDatabase.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<void> populated;
  late List<DBCard.Card> dbCards;

  String searchFieldString = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setupYGOCard();
    this.populate();
  }

  @override
  Widget build(BuildContext context) {
    var futures = <Future<dynamic>>[];
    futures.add(this.populated);

    return FutureBuilder<void>(
        future: Future.wait(futures),
        // var cards = await Deck
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
              backgroundColor: Colors.blue[900],
              body: SpinKitWanderingCubes(
                color: Colors.white,
                size: 50,
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Deck Builder Yu-Gi-Oh',
                  style: TextStyle(
                    fontSize: 35.0
                  ),
                ),
                centerTitle: true,
              ),
              body: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                      child: TextField(
                        onSubmitted: (text) {
                          print("za text is $text");
                          this.populate(text);
                        },
                        style: TextStyle(
                          fontSize: 20.0
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Search card by name..."),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 200.0,
                        child: ListView.builder(
                          itemCount: dbCards.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  Navigator.pushNamed(context, '/detail',
                                      arguments: {'id': dbCards[index].id});
                                  // Navigator.pushNamed(context, '/detail');
                                },
                                title: Text(
                                  dbCards[index].name,
                                  style: TextStyle(
                                    fontSize: 25.0
                                  ),
                                ),
                                leading: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.asset(
                                      'assets/images/card_small_bg.jpg'),
                                ),
                                tileColor: DBCard.Card.getColor(dbCards[index].type),
                                
                                // tileColor: Colors.green,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  void populate([String name = ""]) async {
    if (name == "") {
      this.populated = (() async {
        this.dbCards = await DecksDatabase.instance.readAllCard();
        print('dah cuy');
        print('dbCards count = ${dbCards.length}');
      })();

      setState(() {});

    } else {
      this.populated = (() async {
        this.dbCards = await DecksDatabase.instance.readCardWithFuzzyName(name);
        print('fuzzy name ni');
        print('dbCards count = ${dbCards.length}');
      })();

      setState(() {});
    }
  }
}
