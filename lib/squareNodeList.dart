import 'squareNode.dart';

class SquareNodeList<T> {
  SquareNode<T>? start;
  int? length;
  int? height;
  SquareNodeList({required this.start, this.length, this.height}) {
    if (length == null) {
      var node = start!.next;
      length = 1;
      while (node != null) {
        length = length! + 1;
        node = node.next;
      }
    }
    if (height == null) {
      var node = start!.down;
      height = 1;
      while (node != null) {
        height = height! + 1;
        node = node.down;
      }
    }
  }

  SquareNodeList.arrange(this.length, this.height,
      {T? initialValue,
      List<List<T>>? values,
      T Function(int, int)? arrangeFunction}) {
    // ignore: unrelated_type_equality_checks
    assert(arrangeFunction != initialValue ||
        initialValue != values &&
            (initialValue == null ||
                values == null ||
                arrangeFunction == null));
    if (initialValue != null) {
      start = _createLine(value: initialValue, length: length!);
      for (var i = 1; i < height!; i++) {
        var node = _createLine(value: initialValue, length: length!);
        _addLine(node);
      }
    } else if (arrangeFunction != null) {
      start = _createLine(
          creator: (index) => arrangeFunction(0, index), length: length!);
      for (var i = 1; i < height!; i++) {
        var node = _createLine(
            creator: (index) => arrangeFunction(i, index), length: length!);
        _addLine(node);
      }
    } else {
      start = _createLine(values: values!.first, length: length!);
      for (var i = 1; i < height!; i++) {
        var node = _createLine(values: values[i], length: length!);
        _addLine(node);
      }
    }
  }
  void _addLine(SquareNode<T> node) {
    start!.addDown(node);
    for (var i = 1; i < length!; i++) {
      var lineNode = start!.getNextAt(i);
      lineNode.addDown(node.getNextAt(i));
    }
  }

  SquareNodeList<T> cropPiece(
      {required int startNext,
      required int endNext,
      required int startdown,
      required int endDown}) {
    assert(startNext < endNext);
    assert(startdown < endDown);
    assert(endNext < this.length!);
    assert(endDown < this.height!);
    var newStart = start!.getNextAt(startNext).getDownAt(startdown);
    var length = endNext - startNext;
    var height = endDown - startdown;
    var next =
        newStart.next != null ? newStart.next!.copyNextFor(length - 1) : null;
    var down =
        newStart.down != null ? newStart.down!.copyDownFor(height - 1) : null;
    newStart.down = down;
    newStart.next = next;
    var copiedDown = down;
    while (copiedDown != null) {
      copiedDown = copiedDown.copyNextFor(height - 1);
      for (var i = 0; i < length - 1; i++) {
        next!.getNextAt(i).down = copiedDown.getNextAt(i);
      }
      next = copiedDown;
      copiedDown = copiedDown.down;
    }
    return SquareNodeList(start: newStart, length: ++length, height: ++height);
  }

  List<SquareNode<T>> getEveryDuplicateLine() {
    var nodes = <SquareNode<T>>[];
    for (var i = 0; i < height!; i++) {
      if (_hasDuplicateInLine(line: i)) nodes.add(start!.getDownAt(i));
    }
    return nodes;
  }

  List<SquareNode<T>> getEveryDuplicateVertical() {
    var nodes = <SquareNode<T>>[];
    for (var i = 0; i < length!; i++) {
      if (_hasDuplicateInVertical(line: i)) nodes.add(start!.getNextAt(i));
    }
    return nodes;
  }

  void applyDuplicateLines({required T Function(T) changer}) {
    var lineStarts = getEveryDuplicateLine();
    for (var i in lineStarts) {
      SquareNode<T>? node = i;
      while (node != null) {
        node.value = changer(node.value);
        node = node.next;
      }
    }
  }

  void applyDuplicateVerticals({required T Function(T) changer}) {
    var verticalStarts = getEveryDuplicateVertical();
    for (var i in verticalStarts) {
      SquareNode<T>? node = i;
      while (node != null) {
        node.value = changer(node.value);
        node = node.down;
      }
    }
  }

  SquareNode<T> _createLine(
      {T? value, List<T>? values, T Function(int)? creator, int length = 1}) {
    assert((value == null || values == null || creator == null) &&
            value != values ||
        // ignore: unrelated_type_equality_checks
        value != creator);
    assert(length <= this.length!);
    if (values != null) assert(values.length == length);
    late SquareNode<T> node;
    if (value != null) {
      node = SquareNode<T>(value: value);
      for (var i = 1; i < length; i++) {
        node.addNext(SquareNode<T>(value: value));
      }
    } else if (values != null) {
      node = SquareNode<T>(value: values.first);
      for (var i = 1; i < length; i++) {
        node.addNext(SquareNode(value: values[i]));
      }
    } else {
      node = SquareNode(value: creator!(0));
      for (var i = 1; i < length; i++) {
        node.addNext(SquareNode<T>(value: creator(i)));
      }
    }
    return node;
  }

  bool hasDuplicateInAnyLine() {
    for (var i = 0; i < height!; i++) {
      if (_hasDuplicateInLine(line: i)) return true;
    }
    return false;
  }

  bool hasDuplicateInAnyVertical() {
    for (var i = 0; i < length!; i++) {
      if (_hasDuplicateInVertical(line: i)) return true;
    }
    return false;
  }

  bool _hasDuplicateInLine({int line = 0}) {
    assert(line < height!);
    var node = start;
    while (line > 0) {
      node = node!.down;
      line--;
    }

    return node!.hasDuplicateInLine();
  }

  bool _hasDuplicateInVertical({int line = 0}) {
    assert(line < length!);
    var node = start;
    while (line > 0) {
      node = node!.next;
      line--;
    }
    return node!.hasDuplicateVertical();
  }

  bool any(T value) {
    var node = start;
    var down = start;
    while (down != null) {
      if (node!.checkLine(value)) return true;
      node = down;
      down = down.down;
    }
    return false;
  }

  SquareNode<T>? where(bool Function(T) where) {
    var node = start;
    var down = start;
    while (down != null) {
      if (where(node!.value)) return node;
      node = down;
      down = down.down;
    }
  }

  void setAt(T value, int length, int height) {
    getAt(length, height).value = value;
  }

  SquareNode<T> getAt(int length, int height) {
    return start!.getDownAt(height).getNextAt(length);
  }

  void setLine({T? value, List<T>? values, int line = 0}) {
    assert(value == null || values == null);
    assert(line <= height!);
    assert(values != null && values.length == length);
    var node = start!;
    while (line > 0) {
      node = node.down!;
    }
    if (value == null) {
      while (node.next != null) {
        node.value = value!;
        node = node.next!;
      }
    } else {
      for (var value in values!) {
        node.value = value;
        node = node.next!;
      }
    }
  }

  void setVertical({T? value, List<T>? values, int line = 0}) {
    assert(value == null || values == null);
    assert(line <= length!);
    assert(values != null && values.length == length);
    var node = start!;
    while (line > 0) {
      node = node.next!;
    }
    if (value == null) {
      while (node.down != null) {
        node.value = value!;
        node = node.down!;
      }
    } else {
      for (var value in values!) {
        node.value = value;
        node = node.down!;
      }
    }
  }
}
