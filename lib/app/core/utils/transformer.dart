import 'dart:developer';

class Transformer<T> {
  final T Function(Map<String, dynamic> json) fromJson;
  final Map<String, dynamic>? data;

  Transformer({required this.fromJson, required this.data});

  T? tryTransformation() {
    T? result;
    try {
      if (data != null) {
        result = fromJson(data!);
      }
    } catch (e) {
      log('***error while Transformation');
      log(e.toString());
    }
    return result;
  }
}
