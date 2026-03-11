import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/products/products_bloc.dart';
import '../../widgets/common/app_widgets.dart';
import '../../widgets/product_card.dart';
import '../../../core/theme/app_theme.dart';
import 'product_detail_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProductsBloc>().add(const ProductsLoadMoreEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    return current >= maxScroll - 200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () => context
                .read<ProductsBloc>()
                .add(const ProductsFetchEvent()),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoadingState || state is ProductsInitialState) {
            return const SkeletonListWidget(count: 6, cardHeight: 82);
          }

          if (state is ProductsErrorState) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () =>
                  context.read<ProductsBloc>().add(const ProductsRetryEvent()),
            );
          }

          if (state is ProductsEmptyState) {
            return const AppEmptyWidget(
              title: 'No Products Found',
              subtitle: 'There are no products available at the moment.',
              icon: Icons.shopping_bag_outlined,
            );
          }

          if (state is ProductsLoadedState) {
            return _ProductsList(
              state: state,
              scrollController: _scrollController,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProductsList extends StatelessWidget {
  final ProductsLoadedState state;
  final ScrollController scrollController;

  const _ProductsList({required this.state, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final itemCount = state.products.length +
        (state.isPaginating ? 1 : 0) +
        (state.paginationError != null ? 1 : 0) +
        (state.hasReachedMax && !state.isPaginating ? 1 : 0);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductsBloc>().add(const ProductsFetchEvent());
      },
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: itemCount,
        separatorBuilder: (_, index) {
          if (index >= state.products.length - 1) return const SizedBox.shrink();
          return const SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          if (index < state.products.length) {
            final product = state.products[index];
            return ProductCard(
              product: product,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductDetailPage(product: product),
                  ),
                );
              },
            );
          }

          if (state.paginationError != null) {
            return PaginationErrorWidget(
              message: state.paginationError!,
              onRetry: () => context
                  .read<ProductsBloc>()
                  .add(const ProductsLoadMoreEvent()),
            );
          }

          if (state.hasReachedMax) {
            return _EndOfListWidget();
          }

          return const PaginationLoaderWidget();
        },
      ),
    );
  }
}

class _EndOfListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Divider(color: appColors.border)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'All products loaded',
              style: TextStyle(fontSize: 11, color: appColors.textSecondary),
            ),
          ),
          Expanded(child: Divider(color: appColors.border)),
        ],
      ),
    );
  }
}
