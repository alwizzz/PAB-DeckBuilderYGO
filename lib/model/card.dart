import 'package:flutter/material.dart';

final String tableCards = 'cards';

class CardFields {
  static final List<String> all = [
    id,
    api_id,
    name,
    type,
    desc,
    atk,
    def,
    level,
    race,
    attribute,
    archetype,
    image_url,
    image_url_small
  ];

  static final String id = '_id';
  static final String api_id = 'api_id';
  static final String name = 'name';
  static final String type = 'type';
  static final String desc = 'desc';
  static final String atk = 'atk';
  static final String def = 'def';
  static final String level = 'level';
  static final String race = 'race';
  static final String attribute = 'attribute';
  static final String archetype = 'archetype';
  static final String image_url = 'image_url';
  static final String image_url_small = 'image_url_small';
}

class Card {
  final int? id;
  final int api_id;
  final String name;
  final String type;
  final String desc;
  final int atk;
  final int def;
  final int level;
  final String race;
  final String attribute;
  final String archetype;
  final String image_url;
  final String image_url_small;

  const Card({
    this.id,
    required this.api_id,
    required this.name,
    required this.type,
    required this.desc,
    required this.atk,
    required this.def,
    required this.level,
    required this.race,
    required this.attribute,
    required this.archetype,
    required this.image_url,
    required this.image_url_small,
  });

  Map<String, Object?> toJson() => {
        CardFields.id: id,
        CardFields.api_id: api_id,
        CardFields.name: name,
        CardFields.type: type,
        CardFields.desc: desc,
        CardFields.atk: atk,
        CardFields.def: def,
        CardFields.level: level,
        CardFields.race: race,
        CardFields.attribute: attribute,
        CardFields.archetype: archetype,
        CardFields.image_url: image_url,
        CardFields.image_url_small: image_url_small,
      };

  Card copy(
          {int? id,
          int? api_id,
          String? name,
          String? type,
          String? desc,
          int? atk,
          int? def,
          int? level,
          String? race,
          String? attribute,
          String? archetype,
          String? image_url,
          String? image_url_small}) =>
      Card(
        id: id ?? this.id,
        api_id: api_id ?? this.api_id,
        name: name ?? this.name,
        type: type ?? this.type,
        desc: desc ?? this.desc,
        atk: atk ?? this.atk,
        def: def ?? this.def,
        level: level ?? this.level,
        race: race ?? this.race,
        attribute: attribute ?? this.attribute,
        archetype: archetype ?? this.archetype,
        image_url: image_url ?? this.image_url,
        image_url_small: image_url_small ?? this.image_url_small,
      );

  static Card fromJson(Map<String, Object?> json) => Card(
        id: json[CardFields.id] as int?,
        api_id: json[CardFields.api_id] as int,
        name: json[CardFields.name] as String,
        type: json[CardFields.type] as String,
        desc: json[CardFields.desc] as String,
        atk: json[CardFields.atk] as int,
        def: json[CardFields.def] as int,
        level: json[CardFields.level] as int,
        race: json[CardFields.race] as String,
        attribute: json[CardFields.attribute] as String,
        archetype: json[CardFields.archetype] as String,
        image_url: json[CardFields.image_url] as String,
        image_url_small: json[CardFields.image_url_small] as String,
      );

  static Color getColor(String type) {
    // print(type);
    if (type == "Spell Card") {
      return Color.fromARGB(255, 73, 213, 150);
    } else if (type == "Trap Card") {
      return Color.fromARGB(255, 200, 93, 161);
    } else if (type == "Normal Monster") {
      return Color.fromARGB(255, 183, 148, 94);
    } else if (type == "Effect Monster" || type == "Flip Effect Monster" || 
        type == "Flip Tuner Effect Monster" || type == "Gemini Monster" || type == "Tuner Monster") {
      return Color.fromARGB(255, 197, 129, 40);
    } else if (type == "Fusion Monster") {
      return Color.fromARGB(255, 154, 113, 199);
    } else if (type == "Ritual Monster" || type == "Ritual Effect Monster") {
      return Color.fromARGB(255, 78, 138, 203);
    } else if (type == "Synchro Monster") {
      return Color.fromARGB(255, 192,191,192);
    } else if (type == "Link Monster") {
      return Color.fromARGB(255, 39, 129, 255);
    } else if (type == "XYZ Monster") {
      return Color.fromARGB(255, 73, 74, 73);
    } else {
      return Color.fromARGB(255, 225, 221, 217);
    }
  }
}
