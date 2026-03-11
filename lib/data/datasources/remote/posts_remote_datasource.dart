import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/post_model.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostModel>> getPosts({required int limit, required int skip});
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final Dio dio;

  PostsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PostModel>> getPosts({
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.postsEndpoint,
        queryParameters: {'limit': limit, 'skip': skip},
      );
      final data = response.data as Map<String, dynamic>;
      final posts = data['posts'] as List<dynamic>;
      return posts
          .map((p) => PostModel.fromJson(p as Map<String, dynamic>))
          .toList();
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to load posts.',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
