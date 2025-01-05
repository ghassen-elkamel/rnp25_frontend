import 'dart:developer';

extension ParseEnumNotNull on String {
  T parseEnum<T>({ required EnumValues<T> byName, required T onNull}) {
    {
      try {
        return byName(toString());
      } catch (e) {
        log("error on parse enum");
      }
      return onNull;
    }
  }

  T? tryParseEnum<T>({required EnumValues<T> byName, T? onNull}) {
    {
      try {
        return byName(toString());
      } catch (_) {
        log("error on parse enum");
      }
      return onNull;
    }
  }
}

typedef EnumValues<T> = T Function(String value);


