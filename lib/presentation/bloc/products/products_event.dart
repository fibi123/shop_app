part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();
  @override
  List<Object?> get props => [];
}

class ProductsFetchEvent extends ProductsEvent {
  const ProductsFetchEvent();
}

class ProductsLoadMoreEvent extends ProductsEvent {
  const ProductsLoadMoreEvent();
}

class ProductsRetryEvent extends ProductsEvent {
  const ProductsRetryEvent();
}
