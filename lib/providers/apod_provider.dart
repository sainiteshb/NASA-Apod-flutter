import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../api_key.dart';

class ApodProvider extends ChangeNotifier {
  DateTime date;

  ApodProvider({@required this.date});

  void changeDate(DateTime newDate) {
    date = newDate;
    notifyListeners();
  }

  get year => date.year;
  get month => date.month;
  get day => date.day;

  Future<Response> getApodData() {
    String dateString = date.year.toString() +
        "-" +
        date.month.toString() +
        "-" +
        date.day.toString();
    String url = Uri.encodeFull(
        "https://api.nasa.gov/planetary/apod?date=$dateString&hd=true&api_key=$apiKey");
    Future<Response> response = get(url);
    return response;
  }
}
