import 'dart:async';
import 'dart:convert';
import 'dart:io';

void main() async {
  const String INPUT_PATH = 'input';

  final File input = File(INPUT_PATH);
  Stream<String> lines =
      input.openRead().transform(utf8.decoder).transform(LineSplitter());

  int result = 0;

  const lookupTable = <String, int>{
    '0': 0,
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    '7': 7,
    '8': 8,
    '9': 9,
    'zero': 0,
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9
  };

  try {
    await for (String line in lines) {
      int leftmost = -1;
      int rightmost = -1;

      for (int i = 0; i < line.length; ++i) {
        for (int j = 1; j <= 5; ++j) {
          if (i + j <= line.length) {
            final lookupKey = line.substring(i, i + j);

            if (lookupTable.containsKey(lookupKey)) {
              if (leftmost == -1) leftmost = lookupTable[lookupKey]!;
              rightmost = lookupTable[lookupKey]!;
            }
          }
        }
      }
      final adjustment = int.parse('${leftmost}${rightmost}');
      print(line);
      print(adjustment);

      result += adjustment;
    }

    print('\nResult: $result');
  } catch (e) {
    print('Oops: $e');
  }
}
