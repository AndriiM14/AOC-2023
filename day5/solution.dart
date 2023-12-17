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
    List<int> state = [];
    List<Function> mappers = [];

    bool collectingRanges = false;
    List<({int destination, int source, int length})> ranges = [];

    await for (var line in lines) {
      if (line.contains('seeds')) {
        state.addAll(
            line.split(':')[1].trim().split(' ').map((e) => int.parse(e)));
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

    print(state);
    for (final mapper in mappers) {
      state = mapper(state);
      print(state);
    }

    print('\nResult: ${state.reduce(min)}');
  } catch (e) {
    print('Oops: $e');
  }
}
