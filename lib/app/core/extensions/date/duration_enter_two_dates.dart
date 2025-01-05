extension DurationEnterTwoDates on DateTime {
  double getDuration({required DateTime endDate}) {
    int hours = endDate.hour - hour;
    int minutes = endDate.minute - minute;
    double duration = hours + minutes / 60;
    if(duration < 0.1){
      return 0.75;
    }
    return duration;
  }
}
