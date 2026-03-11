part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();
  @override
  List<Object?> get props => [];
}

class ProductsInitialState extends ProductsState {
  const ProductsInitialState();
}

class ProductsLoadingState extends ProductsState {
  const ProductsLoadingState();
}

class ProductsEmptyState extends ProductsState {
  const ProductsEmptyState();
}

class ProductsErrorState extends ProductsState {
  final String message;
  const ProductsErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}

class ProductsLoadedState extends ProductsState {
  final List<ProductEntity> products;
  final bool hasReachedMax;
  final bool isPaginating;
  final String? paginationError;

  const ProductsLoadedState({
    required this.products,
    this.hasReachedMax = false,
    this.isPaginating = false,
    this.paginationError,
  });

  ProductsLoadedState copyWith({
    List<ProductEntity>? products,
    bool? hasReachedMax,
    bool? isPaginating,
    String? paginationError,
  }) {
    return ProductsLoadedState(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginating: isPaginating ?? this.isPaginating,
      paginationError: paginationError,
    );
  }

  @override
  List<Object?> get props => [
    products,
    hasReachedMax,
    isPaginating,
    paginationError,
  ];
}
