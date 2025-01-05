import 'package:flutter/material.dart';

class PageMetaData {
  final int page;
  final int take;
  final TextEditingController searchKey;
  final int itemCount;
  final int pageCount;
  final bool hasPreviousPage;
  final bool hasNextPage;

  PageMetaData({
    required this.page,
    this.take = 20,
    this.itemCount = 0,
    this.pageCount = 0,
    TextEditingController? search,
    this.hasPreviousPage = false,
    this.hasNextPage = true,
  }) : searchKey = search ?? TextEditingController();

  factory PageMetaData.fromJson(Map<String, dynamic> json) => PageMetaData(
        page: json["page"],
        take: json["take"],
        itemCount: json["itemCount"],
        pageCount: json["pageCount"],
        hasPreviousPage: json["hasPreviousPage"],
        hasNextPage: json["hasNextPage"],
      );

  Map<String, String> toJson() => {
        "page": page.toString(),
        "take": take.toString(),
        "searchKey": searchKey.text,
      };

  PageMetaData nextPage() {
    return PageMetaData(page: page + 1, take: take, search: searchKey);
  }

  PageMetaData previousPage() {
    return PageMetaData(page: page - 1, take: take, search: searchKey);
  }

  PageMetaData reset() {
    return PageMetaData(page: 1, take: take, search: searchKey);
  }

  PageMetaData copy(PageMetaData? remote) {
    if (remote == null) {
      return this;
    }
    return PageMetaData(
      page: remote.page,
      take: remote.take,
      itemCount: remote.itemCount,
      pageCount: remote.pageCount,
      hasNextPage: remote.hasNextPage,
      hasPreviousPage: remote.hasPreviousPage,
      search: searchKey,
    );
  }
}
