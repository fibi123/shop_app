import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout:
            const Duration(milliseconds: ApiConstants.connectTimeoutMs),
        receiveTimeout:
            const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (o) => print('[DioClient] $o'),
      ),
      _ErrorInterceptor(),
    ]);
  }

  Dio get dio => _dio;
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException(message: 'Connection timed out. Please retry.');
      case DioExceptionType.connectionError:
        throw const NetworkException();
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final message = _extractMessage(err.response);
        if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
          throw AuthException(message: message);
        }
        throw ServerException(message: message, statusCode: statusCode);
      default:
        throw ServerException(
          message: err.message ?? 'An unexpected error occurred.',
        );
    }
  }

  String _extractMessage(Response? response) {
    try {
      if (response?.data is Map) {
        return response!.data['message'] as String? ?? 'Server error occurred.';
      }
    } catch (_) {}
    return 'Server error occurred.';
  }
}
