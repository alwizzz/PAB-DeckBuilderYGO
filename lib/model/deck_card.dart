final String tableDeckCards = "deck_cards";

class DeckCardFields {
  static final List<String> all = [
    id, 
    deck_id, 
    // card_api_id, 
    card_id, 
    on_extra_deck
  ];

  static final String id = "_id";
  static final String deck_id = "deck_id";
  static final String card_id = "card_id";
  // static final String card_api_id = "card_api_id";
  static final String on_extra_deck = "on_extra_deck";
}

class DeckCard {
  final int? id;
  final int deck_id;
  final int card_id;
  // final int card_api_id;
  final bool on_extra_deck;

  const DeckCard({
    this.id,
    required this.deck_id,
    required this.card_id,
    // required this.card_api_id,
    required this.on_extra_deck
  });

  Map<String, Object?> toJson() => {
    DeckCardFields.id: id,
    DeckCardFields.deck_id: deck_id,
    DeckCardFields.card_id: card_id,
    // DeckCardFields.card_api_id: card_api_id,
    DeckCardFields.on_extra_deck: on_extra_deck ? 1 : 0,
  };

  DeckCard copy({
    int? id, 
    int? deck_id, 
    int? card_id, 
    // int? card_api_id, 
    bool? on_extra_deck
  }) => DeckCard(
      id: id ?? this.id,
      deck_id: deck_id ?? this.deck_id,
      card_id: card_id ?? this.card_id,
      // card_api_id: card_api_id ?? this.card_api_id,
      on_extra_deck: on_extra_deck ?? this.on_extra_deck
  );

  static DeckCard fromJson(Map<String, Object?> json) => DeckCard(
    id: json[DeckCardFields.id] as int?,
    deck_id: json[DeckCardFields.deck_id] as int,
    card_id: json[DeckCardFields.card_id] as int,
    // card_api_id: json[DeckCardFields.card_api_id] as int,
    on_extra_deck: json[DeckCardFields.on_extra_deck] == 1,
  );
}
