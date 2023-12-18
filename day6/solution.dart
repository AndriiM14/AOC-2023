import 'dart:io';

void main(List<String> args) {
  final input = File(args[0]).readAsLinesSync();

  final timeStr = input[0].split(':')[1].trim();
  final distanceStr = input[1].split(':')[1].trim();

  final times = timeStr
      .split(' ')
      .where((element) => int.tryParse(element) != null)
      .map((e) => int.parse(e))
      .toList();

  final distances = distanceStr
      .split(' ')
      .where((element) => int.tryParse(element) != null)
      .map((e) => int.parse(e))
      .toList();

  for (int i = 0; i < times.length; ++i) {
    final recordDistance = distances[i];
    final maxTime = times[i];

    int waysToBeat = 0;

    for (int s = 0; s <= maxTime; ++s) {
      final distance = s * (maxTime - s);

      if (distance > recordDistance) ++waysToBeat;
    }

    print('Found $waysToBeat ways to beat record of $recordDistance');
  }
}
