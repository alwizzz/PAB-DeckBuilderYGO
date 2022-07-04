import 'package:flutter/material.dart';
import 'package:deck_builder_ygo/model/card.dart' as DBCard;
import 'package:deck_builder_ygo/db/DecksDatabase.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Detail extends StatefulWidget {
  const Detail({Key? key}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Map data = {};
  late Future<void> populated;
  late DBCard.Card dbCard;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // this.populate();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;

    var futures = <Future<dynamic>>[];
    this.populate();
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
                  title: new Text('Card Detail'),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          dbCard.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Image.network(dbCard.image_url),
                        SizedBox(height: 30.0),
                        Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.amber,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (() {
                                if (dbCard.attribute != "NON MONSTER") {
                                  return Text(
                                    "Attribute: " + dbCard.attribute,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return SizedBox(height: 0);
                                }
                              })(),
                              Text(
                                "Type: " + dbCard.type,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Race: " + dbCard.race,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              (() {
                                if (dbCard.level != -1) {
                                  return Text(
                                    "Level: " + dbCard.level.toString(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return SizedBox(height: 0);
                                }
                              })(),
                              (() {
                                if (dbCard.atk != -1) {
                                  return Text(
                                    "Attack: " + dbCard.atk.toString(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return SizedBox(height: 0);
                                }
                              })(),
                              (() {
                                if (dbCard.def != -1) {
                                  return Text(
                                    "Defense: " + dbCard.def.toString(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return SizedBox(height: 0);
                                }
                              })(),
                              Text(
                                "Archetype: " + dbCard.archetype,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Description: ",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "    " + dbCard.desc,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          }
        });
  }

  void populate() async {
    this.populated = (() async {
      this.dbCard = (await DecksDatabase.instance.readCard(data['id']))!;
      print('dah ke read cuy');
    })();
  }
}
