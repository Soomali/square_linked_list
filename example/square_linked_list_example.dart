import 'package:square_linked_list/square_linked_list.dart';

void main() {
  var x = SquareNodeList<int>.arrange(4, 9,
      arrangeFunction: (x, y) => x * y != 0 ? x * y : x + y);
  _print(x);
  print(x.hasDuplicateInAnyLine());
  print(x.hasDuplicateInAnyVertical());
  x = x.cropPiece(startNext: 1, endNext: 3, startdown: 1, endDown: 4);
  print(x.length);
  _print(x);
  _print(15);
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
