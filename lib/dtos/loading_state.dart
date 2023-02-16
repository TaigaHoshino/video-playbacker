import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'loading_state.freezed.dart';

@freezed
class LoadingState<T> with _$LoadingState<T> {
  const factory LoadingState.loading(T? content) = _Loading<T>;
  const factory LoadingState.completed(T content) = _Completed<T>;
  const factory LoadingState.error(Exception exception) = _Error<T>;
}