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
    return down!.getLastDown();
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

  SquareNode<T> copyNextFor(int count) {
    assert(count >= 0);
    if (next == null || count == 0)
      return SquareNode<T>(value: value, down: down);
    return SquareNode<T>(
        value: value, next: next!.copyNextFor(--count), down: down);
  }

  SquareNode<T> copyDownFor(int count) {
    assert(count >= 0);
    if (down == null || count == 0)
      return SquareNode<T>(value: value, next: next);
    return SquareNode(
        value: value, down: down!.copyDownFor(--count), next: next);
  }
}
