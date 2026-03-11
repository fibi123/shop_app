part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();
  @override
  List<Object?> get props => [];
}

class PostsFetchEvent extends PostsEvent {
  const PostsFetchEvent();
}

class PostsLoadMoreEvent extends PostsEvent {
  const PostsLoadMoreEvent();
}

class PostsRetryEvent extends PostsEvent {
  const PostsRetryEvent();
}
