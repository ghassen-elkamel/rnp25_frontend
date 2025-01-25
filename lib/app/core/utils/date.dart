import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rnp_front/app/core/extensions/string/language.dart';

import 'language_helper.dart';

class UtilsDate {
  static String formatDDMMYYYY(DateTime? date) {
    if (date == null) {
      return "";
    }
    final f = DateFormat('dd/MM/yyyy');
    return f.format(date);
  }

  static DateTime resetTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static int getTimePerMinutes(DateTime? date) {
    if (date == null) {
      return 0;
    }

    return date.hour * 60 + date.minute;
  }

  static String formatDDMMYYYYHHmm(DateTime? date) {
    if (date == null) {
      return "";
    }
    final f = DateFormat('dd/MM/yyyy HH:mm');
    return f.format(date);
  }

  static String formatHHmmDDMMYYYY(DateTime? date) {
    if (date == null) {
      return "";
    }
    final f = DateFormat('HH:mm dd/MM/yyyy');
    return f.format(date);
  }

  static String formatEEEED(DateTime? date) {
    if (date == null) {
      return "";
    }
    final f = DateFormat('EEEE d');
    return f.format(date);
  }

  static String formatHHmm(DateTime? date) {
    if (date == null) {
      return "";
    }
    final f = DateFormat('HH:mm');
    return f.format(date);
  }

  static String? formatYYYYMMDD(DateTime? date) {
    if (date == null) {
      return null;
    }
    final f = DateFormat('yyyy-MM-dd');
    return f.format(date);
  }

  static String? formatMMDD(DateTime? date) {
    if (date == null) {
      return null;
    }
    final f = DateFormat(
      'MM/dd',
    );
    return f.format(date);
  }

  static String? formatEEE(DateTime? date) {
    if (date == null) {
      return null;
    }
    final f = DateFormat('EEE', LanguageHelper.language.languageCode);
    return f.format(date);
  }

  static String formatDuration(Duration duration) {
    return "${"${duration.inMinutes}".padLeft(2, "0")}:${"${duration.inSeconds.remainder(60)}".padLeft(2, "0")}";
  }

  static Future<DateTime?> getDate(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2030),
    );
  }
}
