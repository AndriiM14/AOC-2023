import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main(List<String> args) async {
  final input = File(args[0]);
  Stream<String> lines =
      input.openRead().transform(utf8.decoder).transform(LineSplitter());

  num result = 0;

  try {
    await for (var line in lines) {
      final numbers_str = line.split(':')[1].trim();

      final winningNumbers = numbers_str
          .split("|")[0]
          .trim()
          .split(" ")
          .where((element) => int.tryParse(element) != null)
          .map((sNum) => int.parse(sNum));

      final yourNumbers = numbers_str
          .split("|")[1]
          .trim()
          .split(" ")
          .where((element) => int.tryParse(element) != null)
          .map((sNum) => int.parse(sNum));

      var power = 0;

      yourNumbers.forEach((num) {
        if (winningNumbers.contains(num)) ++power;
      });

      print('Winning cards count: $power');

      if (power > 0) result += pow(2, power - 1);
    }

    print('\nResult: $result');
  } catch (e) {
    print('Oops: $e');
  }
}
