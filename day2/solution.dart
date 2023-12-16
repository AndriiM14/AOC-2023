import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main(List<String> args) async {
  //const MAX_CUBES = <String, int>{'red': 12, 'green': 13, 'blue': 14};

  final input = File(args[0]);
  Stream<String> lines =
      input.openRead().transform(utf8.decoder).transform(LineSplitter());

  int result = 0;

  try {
    await for (var line in lines) {
      // Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 gree
      var [game, sets] = line.split(':');
      sets = sets.trim();

      final gameId = int.parse(game.split(' ')[1]);

      print('Game id: $gameId');
      print(sets);

      var colorMin = <String, int>{'red': -1, 'green': -1, 'blue': -1};

      for (final set in sets.split(';')) {
        for (final cubes in set.split(',')) {
          final [count, color] = cubes.trim().split(' ');
          colorMin[color] = max(int.parse(count), colorMin[color]!);
        }
      }

      final power = colorMin['red']! * colorMin['green']! * colorMin['blue']!;
      print('Power: $power');

      result += power;
    }

    print('\nResult: $result');
  } catch (e) {
    print('Oops: $e');
  }
}
