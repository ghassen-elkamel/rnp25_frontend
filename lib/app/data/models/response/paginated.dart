import 'package:rnp_front/app/core/utils/transformer.dart';

import 'meta_data.dart';

Paginated<T> paginatedFromJson<T>(
        dynamic str, T Function(Map<String, dynamic>) fromJson) =>
    Paginated.fromJson(str, fromJson);

class Paginated<T> {
  final List<T> items;
  final PageMetaData? meta;

  Paginated({
    required this.items,
    required this.meta,
  });

  factory Paginated.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return Paginated<T>(
      items: List<T>.from(json["items"].map((x) => fromJson(x))),
      meta: Transformer(data: json["meta"], fromJson: PageMetaData.fromJson).tryTransformation(),
    );
  }
}
