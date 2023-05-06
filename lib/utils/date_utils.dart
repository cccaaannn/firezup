import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MessageDateUtils {
  static String formatForMessageDate(Timestamp? timestamp) {
    if (timestamp == null) {
      return "";
    }

    DateFormat formatterYear = DateFormat('yyyy-MM-dd');
    // DateFormat formatterMonth = DateFormat('MM-dd');
    DateFormat formatterHour = DateFormat('HH:mm');
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();

    String formattedDate = "";
    if (dateTime.day != now.day) {
      formattedDate = formatterYear.format(dateTime);
    } else {
      formattedDate = formatterHour.format(dateTime);
    }

    return formattedDate;
  }
}
