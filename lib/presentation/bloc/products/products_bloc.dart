import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constants/api_constants.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/get_products_usecase.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase getProductsUseCase;

  ProductsBloc({required this.getProductsUseCase})
    : super(const ProductsInitialState()) {
    on<ProductsFetchEvent>(_onFetch);
    on<ProductsLoadMoreEvent>(_onLoadMore);
    on<ProductsRetryEvent>(_onRetry);
  }

  Future<void> _onFetch(
    ProductsFetchEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoadingState());
    final result = await getProductsUseCase(skip: 0);
    result.fold(
      (failure) => emit(ProductsErrorState(message: failure.message)),
      (products) {
        if (products.isEmpty) {
          emit(const ProductsEmptyState());
        } else {
          emit(
            ProductsLoadedState(
              products: products,
              hasReachedMax: products.length < ApiConstants.pageLimit,
            ),
          );
        }
      },
    );
  }

  Future<void> _onLoadMore(
    ProductsLoadMoreEvent event,
    Emitter<ProductsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProductsLoadedState) return;
    if (currentState.hasReachedMax) return;

    emit(currentState.copyWith(isPaginating: true));

    final result = await getProductsUseCase(
      skip: currentState.products.length,
    );
    result.fold(
      (failure) => emit(
        currentState.copyWith(
          isPaginating: false,
          paginationError: failure.message,
        ),
      ),
      (newProducts) {
        if (newProducts.isEmpty) {
          emit(currentState.copyWith(isPaginating: false, hasReachedMax: true));
        } else {
          emit(
            ProductsLoadedState(
              products: [...currentState.products, ...newProducts],
              hasReachedMax: newProducts.length < ApiConstants.pageLimit,
              isPaginating: false,
            ),
          );
        }
      },
    );
  }

  Future<void> _onRetry(
    ProductsRetryEvent event,
    Emitter<ProductsState> emit,
  ) async {
    add(const ProductsFetchEvent());
  }
}
