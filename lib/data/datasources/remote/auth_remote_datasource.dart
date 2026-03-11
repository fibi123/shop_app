import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'username': username,
          'password': password,
          'expiresInMins': 30,
        },
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on AuthException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Login failed.',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
