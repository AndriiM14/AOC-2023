import 'dart:async';
import 'dart:io';

bool isSymbol(String char) {
  return char != '.' && int.tryParse(char) == null;
}

bool containsSymbol(String str) {
  for (final char in str.split('')) {
    if (isSymbol(char)) return true;
  }

  return false;
}

void main(List<String> args) {
  final input = File(args[0]).readAsLinesSync();

  var res = 0;

  for (final (lineIdx, line) in input.indexed) {
    int left = -1;
    int right = -1;

    for (var i = 0; i < line.length; ++i) {
      if (int.tryParse(line[i]) != null) {
        if (left == -1) {
          left = i;
        }

        right = i;

        if (i != line.length - 1) continue;
      }
      if (left != -1 && right != -1) {
        final num = int.parse(line.substring(left, right + 1));
        print('Found number: $num');
        var isPart = false;

        if (left != 0 && isSymbol(line[left - 1])) isPart = true;
        if (right != line.length - 1 && isSymbol(line[right + 1]))
          isPart = true;

        if (left != 0) left -= 1;
        if (right != line.length - 1) right += 1;

        if (lineIdx != 0 &&
            containsSymbol(input[lineIdx - 1].substring(left, right + 1)))
          isPart = true;
        if (lineIdx != input.length - 1 &&
            containsSymbol(input[lineIdx + 1].substring(left, right + 1)))
          isPart = true;

        print('Number: $num; Is a part number: $isPart');
        if (isPart) res += num;

        left = -1;
        right = -1;
      }
    }
  }

  print('\nResult: $res');
}
