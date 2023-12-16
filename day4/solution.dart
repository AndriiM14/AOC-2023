import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main(List<String> args) async {
  final input = File(args[0]);
  Stream<String> lines =
      input.openRead().transform(utf8.decoder).transform(LineSplitter());

  var pile = Map<int, int>();
  num result = 0;

  try {
    await for (var line in lines) {
      final cardNumber =
          int.parse(line.split(':')[0].trim().split('d')[1].trim());

      if (pile.containsKey(cardNumber) && pile[cardNumber] != null)
        pile[cardNumber] = pile[cardNumber]! + 1;
      else
        pile[cardNumber] = 1;

      final numbersStr = line.split(':')[1].trim();

      final winningNumbers = numbersStr
          .split("|")[0]
          .trim()
          .split(" ")
          .where((element) => int.tryParse(element) != null)
          .map((sNum) => int.parse(sNum));

      final yourNumbers = numbersStr
          .split("|")[1]
          .trim()
          .split(" ")
          .where((element) => int.tryParse(element) != null)
          .map((sNum) => int.parse(sNum));

      var numOfMatches = 0;

      yourNumbers.forEach((num) {
        if (winningNumbers.contains(num)) ++numOfMatches;
      });

      final copiesCount = pile[cardNumber]!;
      final summand = 1 * copiesCount;

      for (int i = 1; i <= numOfMatches; ++i) {
        final card = cardNumber + i;

        if (pile.containsKey(card) && pile[card] != null)
          pile[card] = pile[card]! + summand;
        else
          pile[card] = summand;
      }
    }

    result = pile.values.reduce((value, element) => value + element);
    print("Result: $result");
  } catch (e) {
    print('Oops: $e');
  }
}
