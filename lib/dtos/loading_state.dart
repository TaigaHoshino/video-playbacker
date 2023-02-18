import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'loading_state.freezed.dart';

@freezed
class LoadingState<T> with _$LoadingState<T> {
  // progressにはロードの進捗を格納する. 0~100までの範囲で格納すること
  const factory LoadingState.loading(T? content, int? progress) = _Loading<T>;
  const factory LoadingState.completed(T content) = _Completed<T>;
  const factory LoadingState.error(Exception exception) = _Error<T>;
}