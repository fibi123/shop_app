import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/post_entity.dart';

abstract class PostsRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts({
    required int limit,
    required int skip,
  });
}
