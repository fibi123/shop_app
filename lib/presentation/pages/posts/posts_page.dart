import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/posts/posts_bloc.dart';
import '../../widgets/common/app_widgets.dart';
import '../../widgets/post_card.dart';
import '../../../core/theme/app_theme.dart';
import 'post_detail_page.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
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
      context.read<PostsBloc>().add(const PostsLoadMoreEvent());
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
        title: const Text('Posts'),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<PostsBloc>().add(const PostsFetchEvent()),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is PostsLoadingState || state is PostsInitialState) {
            return const SkeletonListWidget(count: 4, cardHeight: 130);
          }

          if (state is PostsErrorState) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () =>
                  context.read<PostsBloc>().add(const PostsRetryEvent()),
            );
          }

          if (state is PostsEmptyState) {
            return const AppEmptyWidget(
              title: 'No Posts Found',
              subtitle: 'There are no posts available at the moment.',
              icon: Icons.article_outlined,
            );
          }

          if (state is PostsLoadedState) {
            return _PostsList(
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

class _PostsList extends StatelessWidget {
  final PostsLoadedState state;
  final ScrollController scrollController;

  const _PostsList({required this.state, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final itemCount = state.posts.length +
        (state.isPaginating ? 1 : 0) +
        (state.paginationError != null ? 1 : 0) +
        (state.hasReachedMax && !state.isPaginating ? 1 : 0);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PostsBloc>().add(const PostsFetchEvent());
      },
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: itemCount,
        separatorBuilder: (_, index) {
          if (index >= state.posts.length - 1) return const SizedBox.shrink();
          return const SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          if (index < state.posts.length) {
            final post = state.posts[index];
            return PostCard(
              post: post,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PostDetailPage(post: post),
                  ),
                );
              },
            );
          }

          if (state.paginationError != null) {
            return PaginationErrorWidget(
              message: state.paginationError!,
              onRetry: () =>
                  context.read<PostsBloc>().add(const PostsLoadMoreEvent()),
            );
          }

          if (state.hasReachedMax) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Divider(color: appColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'All posts loaded',
                      style: TextStyle(
                        fontSize: 11,
                        color: appColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: appColors.border)),
                ],
              ),
            );
          }

          return const PaginationLoaderWidget();
        },
      ),
    );
  }
}
