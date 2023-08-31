// This file is "main.dart"
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop.freezed.dart';
part 'shop.g.dart';
// flutter pub run build_runner watch --delete-conflicting-outputs
@freezed
class Shop with _$Shop {
  const factory Shop({
    @Default(0) @JsonKey(name: 'id') int postID,
    @Default('') @JsonKey(name: 'name') String postName,
    @Default('') @JsonKey(name: 'address') String postAddress,
    required DateTime? created_at,
    required DateTime? updated_at,
  }) = _Shop;

  factory Shop.fromJson(Map<String, Object?> json) => _$ShopFromJson(json);
}