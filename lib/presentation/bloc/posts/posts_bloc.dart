import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constants/api_constants.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/usecases/get_posts_usecase.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPostsUseCase getPostsUseCase;

  PostsBloc({required this.getPostsUseCase}) : super(const PostsInitialState()) {
    on<PostsFetchEvent>(_onFetch);
    on<PostsLoadMoreEvent>(_onLoadMore);
    on<PostsRetryEvent>(_onRetry);
  }

  Future<void> _onFetch(PostsFetchEvent event, Emitter<PostsState> emit) async {
    emit(const PostsLoadingState());
    final result = await getPostsUseCase(skip: 0);
    result.fold(
      (failure) => emit(PostsErrorState(message: failure.message)),
      (posts) {
        if (posts.isEmpty) {
          emit(const PostsEmptyState());
        } else {
          emit(PostsLoadedState(
            posts: posts,
            hasReachedMax: posts.length < ApiConstants.pageLimit,
          ));
        }
      },
    );
  }

  Future<void> _onLoadMore(
    PostsLoadMoreEvent event,
    Emitter<PostsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PostsLoadedState) return;
    if (currentState.hasReachedMax) return;

    emit(currentState.copyWith(isPaginating: true));
    final result = await getPostsUseCase(skip: currentState.posts.length);
    result.fold(
      (failure) => emit(
        currentState.copyWith(isPaginating: false, paginationError: failure.message),
      ),
      (newPosts) {
        if (newPosts.isEmpty) {
          emit(currentState.copyWith(isPaginating: false, hasReachedMax: true));
        } else {
          emit(PostsLoadedState(
            posts: [...currentState.posts, ...newPosts],
            hasReachedMax: newPosts.length < ApiConstants.pageLimit,
            isPaginating: false,
          ));
        }
      },
    );
  }

  Future<void> _onRetry(PostsRetryEvent event, Emitter<PostsState> emit) async {
    add(const PostsFetchEvent());
  }
}
