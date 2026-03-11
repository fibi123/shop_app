import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/constants/api_constants.dart';
import '../entities/product_entity.dart';
import '../repositories/products_repository.dart';

class GetProductsUseCase {
  final ProductsRepository repository;
  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call({required int skip}) {
    return repository.getProducts(
      limit: ApiConstants.pageLimit,
      skip: skip,
    );
  }
}
