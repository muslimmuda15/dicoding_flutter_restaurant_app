import 'package:test/test.dart';

void main() {
  test('Ekspektasi variabel result bernilai 0', () {
    var result = Result(0);
    expect(result, isA<Result>());
  });
}

class Result {
  final int value;

  Result(this.value);

  @override
  bool operator ==(covariant Result other) {
    if (identical(this, other)) return true;
    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
