class SquareNode<T> {
  SquareNode<T>? next;

  SquareNode<T>? down;
  T value;
  SquareNode({required this.value, this.next, this.down});
  @override
  String toString() {
    return 'SquareNode(value:$value)';
  }

  SquareNode<T> getNextAt(int x) {
    if (x == 0) return this;
    if (next == null) {
      throw 'IndexOutOfListBounds: index is $x more than the length of the list';
    } else {
      return next!.getNextAt(--x);
    }
  }

  SquareNode<T> getDownAt(int x) {
    if (x == 0) return this;
    if (down == null) {
      throw 'IndexOutOfListBounds: index is $x more than the height of the list';
    } else {
      return down!.getDownAt(--x);
    }
  }

  SquareNode<T> getLastNext() {
    if (next == null) return this;
    return next!.getLastNext();
  }

  SquareNode<T> getLastDown() {
    if (down == null) return this;
    return down!.getLastNext();
  }

  bool hasDuplicateInLine({List<T>? values, int count = -1}) {
    values ??= [];
    if (count == 0) return values.contains(value);
    if (values.contains(value)) return true;
    values.add(value);
    if (next == null) return false;
    count--;
    return next!.hasDuplicateInLine(values: values, count: count);
  }

  bool hasDuplicateVertical({List<T>? values, int count = -1}) {
    values ??= [];

    if (count == 0) return values.contains(value);
    if (values.contains(value)) return true;
    values.add(value);
    if (down == null) return false;
    count--;
    return down!.hasDuplicateInLine(values: values, count: count);
  }

  bool checkLine(T value) {
    if (next == null) return this.value == value;
    if (this.value != value) return next!.checkLine(value);
    return false;
  }

  void addNext(SquareNode<T> node) {
    if (next == null) {
      next = node;
    } else {
      next!.addNext(node);
    }
  }

  void addDown(SquareNode<T> node) {
    if (down == null) {
      down = node;
    } else {
      down!.addDown(node);
    }
  }

  SquareNode<T> copyUntil(int height, int length) {
    if (height == 0 && length == 0) return SquareNode(value: value);
    if (next == null || length == 0) {
      return SquareNode(value: value, down: down!.copyUntil(--height, 0));
    }
    if (down == null || height == 0) {
      return SquareNode(value: value, next: next!.copyUntil(0, --length));
    } else {
      return SquareNode(
          value: value,
          down: down!.copyUntil(--height, length),
          next: next!.copyUntil(height, --length));
    }
  }
}
