import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/constants/api_constants.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class GetPostsUseCase {
  final PostsRepository repository;
  GetPostsUseCase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call({required int skip}) {
    return repository.getPosts(
      limit: ApiConstants.pageLimit,
      skip: skip,
    );
  }
}
