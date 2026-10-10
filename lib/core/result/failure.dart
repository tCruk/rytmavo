/// Typed failure used by the domain and data layers instead of raw
/// exceptions crossing layer boundaries.
sealed class Failure {
  const Failure(this.message);

  /// Developer-facing message. Never shown verbatim to users; the
  /// presentation layer maps failure types to localized text.
  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

/// Input violated a documented invariant (empty name, invalid pattern …).
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.field});

  final String? field;
}

/// Requested entity does not exist.
final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Local storage could not be read or written.
final class StorageFailure extends Failure {
  const StorageFailure(super.message, [this.cause]);

  final Object? cause;
}

/// A platform feature (notifications, file access …) is unavailable or
/// permission was denied.
final class PlatformFailure extends Failure {
  const PlatformFailure(super.message, [this.cause]);

  final Object? cause;
}
