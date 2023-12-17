import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

Function mapper(List<({int destination, int source, int length})> ranges) {
  List<int> execute(List<int> state) {
    List<int> newState = [];

    for (final num in state) {
      int mappedNum = num;

      for (final r in ranges) {
        if (num >= r.source && num <= r.source + r.length) {
          mappedNum = r.destination + (num - r.source);
        }
      }

      newState.add(mappedNum);
    }

    return newState;
  }

  return execute;
}

void main(List<String> args) async {
  final input = File(args[0]);
  Stream<String> lines =
      input.openRead().transform(utf8.decoder).transform(LineSplitter());

  try {
    List<int> seeds = [];
    List<Function> mappers = [];

    bool collectingRanges = false;
    List<({int destination, int source, int length})> ranges = [];

    await for (var line in lines) {
      if (line.contains('seeds')) {
        seeds = line
            .split(':')[1]
            .trim()
            .split(' ')
            .map((e) => int.parse(e))
            .toList();
      }

      if (line.isEmpty) {
        collectingRanges = false;
        if (ranges.isNotEmpty) mappers.add(mapper(ranges));
        ranges = [];
      }

      if (line.contains('map')) {
        print('Collecting ranges for: $line');
        collectingRanges = true;
        continue;
      }

      if (collectingRanges) {
        final values = line.trim().split(' ').map((e) => int.parse(e)).toList();
        ranges.add(
            (destination: values[0], source: values[1], length: values[2] - 1));
      }
    }

    int result = -1;

    for (int i = 0; i < seeds.length - 1; i += 2) {
      final start = seeds[i];
      final length = seeds[i + 1];

      var state = [for (var seed = start; seed < start + length; ++seed) seed];

      for (final map in mappers) state = map(state);

      if (result == -1)
        result = state.reduce(min);
      else
        result = min(result, state.reduce(min));
    }

    print('\nResult: ${result}');
  } catch (e) {
    print('Oops: $e');
  }
}
