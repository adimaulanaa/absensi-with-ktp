class Failure {}

class ServerFailure extends Failure {
  final String message;

  ServerFailure(this.message);

  @override
  String toString() => message;
}

class CacheFailure extends Failure {}

String mapFailureToMessage(Failure failure) {
  if (failure is ServerFailure) {
    return failure.message;
  }
  switch (failure.runtimeType) {
    case CacheFailure _:
      return 'Cache Failure';
    default:
      return 'Unexpected error';
  }
}
