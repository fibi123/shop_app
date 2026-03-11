import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int skip,
  });
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final Dio dio;

  ProductsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.productsEndpoint,
        queryParameters: {'limit': limit, 'skip': skip},
      );
      final data = response.data as Map<String, dynamic>;
      final products = data['products'] as List<dynamic>;
      return products
          .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
          .toList();
    } on NetworkException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to load products.',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
