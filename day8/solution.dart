import 'dart:io';

(String, String, String) parseRoutes(String route) {
  final node = route.split(" = ")[0].trim();
  final routes =
      route.split(" = ")[1].trim().replaceAll(RegExp(r"[()]"), "").split(", ");

  return (node, routes[0], routes[1]);
}

void main(List<String> args) {
  final input = File(args[0]).readAsLinesSync();

  final moves = input[0].split("").toList();
  final routes = input.sublist(2);
  final routesMapped = Map<String, (String, String)>();

  for (final route in routes) {
    final (node, left, right) = parseRoutes(route);
    routesMapped[node] = (left, right);
  }

  int count = 0;
  int currentMove = 0;

  String currentNode = "AAA";
  final targetNode = "ZZZ";

  while (true) {
    final move = moves[currentMove];

    print("Node: $currentNode\tMove: $move");

    if (move == "L") {
      currentNode = routesMapped[currentNode]!.$1;
    } else {
      currentNode = routesMapped[currentNode]!.$2;
    }

    ++count;
    currentMove = (currentMove + 1) % moves.length;

    if (currentNode == targetNode) {
      break;
    }
  }

  print("\nResult: $count");
}
