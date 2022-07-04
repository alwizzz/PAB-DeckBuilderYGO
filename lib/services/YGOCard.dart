import 'package:http/http.dart';
import 'dart:convert';

class YGOCard {
  int id = 0;
  String name = "dummy";
  String type = "dummy";
  String desc = "dummy";
  int atk = -1;
  int def = -1;
  int level = -1;
  String race = "dummy";
  String attribute = "dummy";
  String archetype = "dummy";
  String imageURL = "dummy";
  String imageURLSmall = "dummy";

  YGOCard({required this.id});

  Future<void> getCard() async {
    try {
      Response rsp = await get(
          Uri.parse('https://db.ygoprodeck.com/api/v7/cardinfo.php?id=$id'));
      Map dt = jsonDecode(rsp.body);
      // print(dt['data'][0].runtimeType);
      Map data = dt['data'][0] as Map;

      name = data['name'];
      type = data['type'];
      desc = data['desc'];
      atk = data['atk'];
      def = data['def'];
      level = data['level'];
      race = data['race'];
      attribute = data['attribute'];
      archetype = data['archetype'];
      imageURL = data['card_images'][0]['image_url'];
      imageURLSmall = data['card_images'][0]['image_url_small'];
    } catch (e) {
      print("error caught: $e");
    }
  }

  static List<YGOCard> getCards() {
    List<YGOCard> cards = [
      YGOCard(id: 64202399),
      YGOCard(id: 43228023),
      YGOCard(id: 38517737)
    ];

    return cards;
  }
}
