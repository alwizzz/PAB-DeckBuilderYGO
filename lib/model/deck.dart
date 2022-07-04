final String tableDecks = "decks";

class DeckFields {
  static final List<String> all = [
    id, 
    name,
    main_count,
    extra_count
  ];

  static final String id = "_id";
  static final String name = "name";
  static final String main_count = "main_count";
  static final String extra_count = "extra_count";
}

class Deck {
  final int? id;
  final String name;
  final int main_count;
  final int extra_count;

  const Deck({
    this.id, 
    required this.name,
    required this.main_count,
    required this.extra_count,
  });

  Map<String, Object?> toJson() => {
    DeckFields.id: id, DeckFields.name: name
  };

  Deck copy({
    int? id, 
    String? name,
    int? main_count,
    int? extra_count
  }) => Deck(
    id: id ?? this.id, 
    name: name ?? this.name,
    main_count: main_count ?? this.main_count,
    extra_count: extra_count ?? this.extra_count
  );

  static Deck fromJson(Map<String, Object?> json) => Deck(
    id: json[DeckFields.id] as int?, 
    name: json[DeckFields.name] as String,
    main_count: json[DeckFields.main_count] as int,
    extra_count: json[DeckFields.extra_count] as int,
  );
}
