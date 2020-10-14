import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:hive/hive.dart';
import '../api_key.dart';

class ApodProvider extends ChangeNotifier {
  DateTime date;
  final Box box = Hive.box("cachedResponses");
  String cachedData;

  ApodProvider({@required this.date});

  void changeDate(DateTime newDate) {
    date = newDate;
    getCached();
    notifyListeners();
  }

  void getCached() => cachedData = box.get(getUrl());

  get year => date.year;
  get month => date.month;
  get day => date.day;

  String getUrl() {
    String dateString = date.year.toString() +
        "-" +
        date.month.toString() +
        "-" +
        date.day.toString();
    return Uri.encodeFull("https://api.nasa.gov/planetary/apod?date=$dateString&hd=true&api_key=$apiKey");
  }

  Future<String> getApodData() async {
    String url = getUrl();
    Response response = await get(url);
    box.put(url, response.body);
    return response.body;
  }
}
