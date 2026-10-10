import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/result/failure.dart';
import 'package:rytmavo/core/result/result.dart';

void main() {
  test('Result folds and maps', () {
    const ok = Result<int>.success(2);
    const bad = Result<int>.failure(ValidationFailure('x'));
    expect(ok.isSuccess, isTrue);
    expect(bad.isFailure, isTrue);
    expect(ok.map((v) => v * 2).valueOrNull, 4);
    expect(bad.map((v) => v * 2).failureOrNull, isA<ValidationFailure>());
    expect(ok.fold((v) => 'v$v', (f) => 'f'), 'v2');
    expect(bad.fold((v) => 'v$v', (f) => 'f'), 'f');
    expect(ok, const Result<int>.success(2));
  });

  test('guardStorage converts exceptions into StorageFailure', () async {
    final r = await guardStorage<int>(() async => throw StateError('boom'));
    final f = r.failureOrNull;
    expect(f, isA<StorageFailure>());
    expect((f! as StorageFailure).cause, isA<StateError>());
    final s = await guardStorage(() async => 1);
    expect(s.valueOrNull, 1);
  });
}
