import 'package:ayat_app/src/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

abstract class UseCase<Type, Params> {
  const UseCase();

  ResultFuture<Type> call(Params params);
}

abstract class UseCaseSync<Type> {
  const UseCaseSync();

  Type call();
}

abstract class UseCaseSyncParams<Type, Params> {
  const UseCaseSyncParams();

  Type call(Params params);
}

abstract class UseCaseAsync<Type, Params> {
  const UseCaseAsync();

  Future<Type> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
