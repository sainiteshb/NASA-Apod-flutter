import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:hive/hive.dart';
import '../api_key.dart';

class ApodProvider extends ChangeNotifier {
  final DateTime date;
  String responseData;
  final Box box = Hive.box("cachedResponses");

  ApodProvider({@required this.date});

  get year => date.year.toString();
  get month => date.month.toString();
  get day => date.day.toString();

  String getDateString() => "$year-$month-$day";

  String getUrl() {
    String dateString = getDateString();
    return Uri.encodeFull("https://api.nasa.gov/planetary/apod?date=$dateString&hd=true&api_key=$apiKey");
  }

  void getApodData() async {
    String url = getUrl();
    responseData = box.get(url);
    if (responseData != null) notifyListeners();
    try {
      Response response = await get(url);
      responseData = response.body;
      box.put(url, responseData);
      if (responseData != null || responseData.isNotEmpty) notifyListeners();
    } catch(e) {
      print(e);
    }
  }
}
