extension Compare on DateTime{

  bool isEqualDate(DateTime dateTime){
    return  year == dateTime.year && month == dateTime.month && day == dateTime.day;
  }
  bool inSameMonth(DateTime dateTime){
    return  year == dateTime.year && month == dateTime.month;
  }
}