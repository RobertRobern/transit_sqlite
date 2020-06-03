import 'package:intl/intl.dart';

class Validations {
  // Field validations
  static String validateFname(String value) {
    return (value != null && value != "") ? null : "Please provide first name";
  }

  static String validateLname(String value) {
    return (value != null && value != "") ? null : "Please provide last name";
  }

  static String validateIdNumber(int value) {
    return (value != 10 && value < 0) ? null : "Please provide id number";
  }

  static String validatePhoneNumber(int value) {
    return (value != 10 && value < 0) ? null : "Please provide id number";
  }

  static String validateDestination(String value) {
    return (value != null && value != "") ? null : "Please provide destination";
  }

  static String validateVehiclePlate(String value) {
    return (value != null && value != "")
        ? null
        : "Please provide vehicle plate";
  }

  static String validateResidential(String value) {
    return (value != null && value != "") ? null : "Please provide residence";
  }
}

class DateUtils {
  static DateTime convertToDate(String date) {
    try {
      var convertedDate = new DateFormat("dd/MM/yyyy").parseStrict(date);
      return convertedDate;
    } catch (e) {
      return null;
    }
  }

  static String convertDateToStr(DateTime date) {
    var result = (date.day.toString() +
        "/" +
        date.month.toString() +
        "/" +
        date.year.toString());
    return result;
  }

  static bool isDate(String date) {
    try {
      DateFormat("dd/MM/yyyy").parseStrict(date);
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isCurrent(DateTime date) {
    var now = DateTime.now();
    if (date.day != now.day && date.month != now.month && date.year != now.year)
      return false;
    return true;
  }

  static bool isValidDate(String date) {
    if (date.isEmpty || !date.contains("/") || date.length < 10) return false;

    List<String> dateItems = date.split("/");
    var d = DateTime(int.parse(dateItems[0]), int.parse(dateItems[1]),
        int.parse(dateItems[2]));
    return d != null && isDate(date) && isCurrent(d);
  }
}
