import 'dart:convert';
import 'dart:developer';

import 'package:localstorage/localstorage.dart';
import '../../core/utils/constant.dart';

class StorageHelper {
  static StorageHelper? _instance;
  late LocalStorage storage;

  factory StorageHelper() {
    _instance ??= StorageHelper._internal();
    return _instance!;
  }

  StorageHelper._internal() {
    storage = LocalStorage(storageGlobalKey);
  }

  dynamic fetchOrCreateItem({
    required String key,
    required dynamic item,
  }) async {
    dynamic data = await fetchItem(key: key);
    if (data == null) {
      await saveItem(key: key, item: item);
      data = item;
    }
    return data;
  }

  Future<void> updateItem({required String key, required dynamic item}) async {
    await saveItem(key: key, item: item);
  }

  Future<void> saveItem({required String key, required dynamic item}) async {
    await storage.ready;
    storage.setItem(key, jsonEncode(item));
  }

  dynamic fetchItem({required String key}) async {
    await storage.ready;
    try {
      String? data = storage.getItem(key);
      if (data != null) {
        return jsonDecode(data);
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<T?> fetchItemObject<T>({required String key, required T Function (Map<String, dynamic>) fromJson}) async {
    await storage.ready;
    try {
      String? data = storage.getItem(key);
      if (data != null) {
        return fromJson(jsonDecode(data));
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }


  clean() async {
    storage.clear();
  }

  Future<void> removeItem({required String key}) {
    return storage.deleteItem(key);
  }
}
