import 'failure.dart';

/// Minimal result type: either a [Success] with a value or a [Error] with a
/// typed [Failure]. Use pattern matching (`switch`) to consume it.
sealed class Result<T> {
  const Result();

  const factory Result.success(T value) = Success<T>;

  const factory Result.failure(Failure failure) = Error<T>;

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Error<T>;

  /// Value on success, `null` on failure.
  T? get valueOrNull => switch (this) {
    Success<T>(:final value) => value,
    Error<T>() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    Error<T>(:final failure) => failure,
  };

  R fold<R>(R Function(T value) onSuccess, R Function(Failure f) onFailure) =>
      switch (this) {
        Success<T>(:final value) => onSuccess(value),
        Error<T>(:final failure) => onFailure(failure),
      };

  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Success<T>(:final value) => Success(transform(value)),
    Error<T>(:final failure) => Error(failure),
  };
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  bool operator ==(Object other) => other is Success<T> && other.value == value;

  @override
  int get hashCode => Object.hash(Success, value);

  @override
  String toString() => 'Success($value)';
}

final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;

  @override
  bool operator ==(Object other) =>
      other is Error<T> && other.failure == failure;

  @override
  int get hashCode => Object.hash(Error, failure);

  @override
  String toString() => 'Error($failure)';
}

/// Runs [body] and converts thrown exceptions into a [StorageFailure].
/// Use only at the data-layer boundary.
Future<Result<T>> guardStorage<T>(
  Future<T> Function() body, {
  String context = 'storage',
}) async {
  try {
    return Success(await body());
  } on Object catch (e) {
    return Error(StorageFailure('$context failed', e));
  }
}
