class MyDateFormat {
  static String dateFrmt(DateTime date) {
    return '${date.year}${date.month < 10 ? '0${date.month}' : date.month}${date.day < 10 ? '0${date.day}' : date.day}';
  }
}
