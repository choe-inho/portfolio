import 'package:intl/intl.dart';

class DateTimeUtils {
  static String timelineToText(DateTime date) => DateFormat('yyyy.MM').format(date);
}