import 'package:square_linked_list/square_linked_list.dart';

void main() {
  var x = SquareLinkedList<int>.arrange(4, 9,
      arrangeFunction: (x, y) => x * y + x + y - y * y * y);
  _print(x);
  print(x.hasDuplicateInAnyLine());
  print(x.hasDuplicateInAnyVertical());
  //x = x.cropPiece(startNext: 1, endNext: 3, startdown: 1, endDown: 4);
  print(x.length);
  _print(x);
  print("\n\n\n\n\n");
  List<int> checkeds = [];
  var c = x.checkAreas(2, 3, (int x) {
    var val = !checkeds.contains(x);
    checkeds.add(x);
    return val;
  }, afterCheck: checkeds.clear);
  print(c);
}

void _print(x) {
  var d = x.start;
  while (d != null) {
    var n = d.next;
    var x = '$d';
    while (n != null) {
      x += ' -> $n';
      n = n.next;
    }
    d = d.down;
    print(x);
  }
}
