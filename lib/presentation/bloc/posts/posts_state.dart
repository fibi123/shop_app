part of 'posts_bloc.dart';

abstract class PostsState extends Equatable {
  const PostsState();
  @override
  List<Object?> get props => [];
}

class PostsInitialState extends PostsState {
  const PostsInitialState();
}

class PostsLoadingState extends PostsState {
  const PostsLoadingState();
}

class PostsEmptyState extends PostsState {
  const PostsEmptyState();
}

class PostsErrorState extends PostsState {
  final String message;
  const PostsErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}

class PostsLoadedState extends PostsState {
  final List<PostEntity> posts;
  final bool hasReachedMax;
  final bool isPaginating;
  final String? paginationError;

  const PostsLoadedState({
    required this.posts,
    this.hasReachedMax = false,
    this.isPaginating = false,
    this.paginationError,
  });

  PostsLoadedState copyWith({
    List<PostEntity>? posts,
    bool? hasReachedMax,
    bool? isPaginating,
    String? paginationError,
  }) {
    return PostsLoadedState(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginating: isPaginating ?? this.isPaginating,
      paginationError: paginationError,
    );
  }

  @override
  List<Object?> get props => [posts, hasReachedMax, isPaginating, paginationError];
}
