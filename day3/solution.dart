import 'dart:io';

bool isSymbol(String char) {
  return char != '.' && int.tryParse(char) == null;
}

bool isGear(String char) {
  return char == '*';
}

(bool, bool, (int, int)) containsSymbol(String str, int row, int left) {
  var contains = false;
  var containsGear = false;
  var gearCoordinates = (-1, -1);

  for (final (col, char) in str.split('').indexed) {
    if (isSymbol(char)) {
      contains = true;

      if (isGear(char)) {
        containsGear = true;
        gearCoordinates = (row, col + left);
      }
    }
  }

  return (contains, containsGear, gearCoordinates);
}

void main(List<String> args) {
  final input = File(args[0]).readAsLinesSync();
  var gears = Map<(int, int), List<int>>();

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
        //print('Found number: $num');

        if (left != 0) {
          if (isSymbol(line[left - 1])) {
            if (isGear(line[left - 1])) {
              final gear = (lineIdx, left - 1);
              if (gears.containsKey(gear))
                gears[gear]?.add(num);
              else
                gears[gear] = [num];
            }
          }
        }

        if (right != line.length - 1) {
          if (isSymbol(line[right + 1])) {
            if (isGear(line[right + 1])) {
              final gear = (lineIdx, right + 1);
              if (gears.containsKey(gear))
                gears[gear]?.add(num);
              else
                gears[gear] = [num];
            }
          }
        }

        if (left != 0) left -= 1;
        if (right != line.length - 1) right += 1;

        if (lineIdx != 0) {
          var (contains, containsGear, gearCoordinates) = containsSymbol(
              input[lineIdx - 1].substring(left, right + 1), lineIdx - 1, left);

          if (contains) {
            if (containsGear) {
              if (gears.containsKey(gearCoordinates))
                gears[gearCoordinates]?.add(num);
              else
                gears[gearCoordinates] = [num];
            }
          }
        }

        if (lineIdx != input.length - 1) {
          var (contains, containsGear, gearCoordinates) = containsSymbol(
              input[lineIdx + 1].substring(left, right + 1), lineIdx + 1, left);

          if (contains) {
            if (containsGear) {
              if (gears.containsKey(gearCoordinates))
                gears[gearCoordinates]?.add(num);
              else
                gears[gearCoordinates] = [num];
            }
          }
        }

        //print('Number: $num; Is a part number: $isPart');

        left = -1;
        right = -1;
      }
    }
  }

  gears.forEach((gear, nums) {
    if (nums.length == 2) {
      print('Found a gear: $gear');
      res += nums[0] * nums[1];
    }
  });

  print('\nResult: $res');
}
