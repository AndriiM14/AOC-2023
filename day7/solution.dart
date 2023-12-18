import 'dart:io';

int findType(String card) {
  var groups = Map<String, int>();

  for (var char in card.split('')) {
    if (groups.containsKey(char))
      groups[char] = groups[char]! + 1;
    else
      groups[char] = 1;
  }

  var type = groups.keys.length;

  if (type >= 4) type += 2;

  if (type == 3) {
    type = 4;

    for (final v in groups.values) {
      if (v == 2) {
        type = 5;
        break;
      }
    }
  }

  if (type == 2) {
    for (final v in groups.values) {
      if (v == 3) {
        type = 3;
        break;
      }
    }
  }

  return 8 - type;
}

void main(List<String> args) {
  const cardStrength = {
    '2': 1,
    '3': 2,
    '4': 3,
    '5': 4,
    '6': 5,
    '7': 6,
    '8': 7,
    '9': 8,
    'T': 9,
    'J': 10,
    'Q': 11,
    'K': 12,
    'A': 13
  };

  final cards = File(args[0]).readAsLinesSync().map((e) {
    return (
      hand: e.split(' ')[0].trim(),
      bid: int.parse(e.split(' ')[1].trim())
    );
  }).toList();

  cards.sort((a, b) {
    final aType = findType(a.hand);
    final bType = findType(b.hand);

    if (aType != bType) return -1 * (aType - bType);

    for (int i = 0; i < a.hand.length; ++i) {
      final aChar = a.hand[i];
      final bChar = b.hand[i];

      if (aChar != bChar)
        return -1 * (cardStrength[aChar]! - cardStrength[bChar]!);
    }

    return 0;
  });

  print(cards);

  int result = 0;

  for (final (i, card) in cards.indexed) {
    final rank = cards.length - i;

    result += card.bid * rank;
  }

  print('\nResult: $result');
}
