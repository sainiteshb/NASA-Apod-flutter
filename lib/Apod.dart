import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';

import 'api_key.dart';

class ApodPage extends StatefulWidget {
  @override
  _ApodPageState createState() => _ApodPageState();
}

class _ApodPageState extends State<ApodPage> {
  String imageUrl;
  String imageInfo = "loading Information";
  String imageTitle = 'loading Title';
  String mediaType = "mediaType";
  String year;
  String month;
  String day;
  DateTime dateTime;
  Future<void> datePicker(BuildContext context) async {
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1995, 6, 16, 0, 0),
        lastDate: DateTime.now(),
        cancelText: "Cancel",
        confirmText: "OK");
    if (dateTime != null) {
      setState(() {
        year = dateTime.year.toString();
        month = dateTime.month.toString();
        day = dateTime.day.toString();
      });
      getApodData(year: year, month: month, day: day)
          .then(displayApod)
          .catchError((error) => print(error));
    }
  }

  //  method to fetch the data from NASA Api
  // change the apikey
  Future<Response> getApodData({String year, String month, String day}) {
    String date = year + "-" + month + "-" + day;
    String url = Uri.encodeFull(
        "https://api.nasa.gov/planetary/apod?date=$date&hd=true&api_key=$apiKey");
    Future<Response> response = get(url);
    return response;
  }

  displayApod(Response response) {
    Map<String, dynamic> apoddetails = json.decode(response.body);

    setState(() {
      imageInfo = apoddetails['explanation'] == null
          ? "Data is not yet available , select another date "
          : apoddetails["explanation"];
      imageTitle = apoddetails['title'] == null
          ? "Data is not available"
          : apoddetails['title'];
    });
    mediaType = apoddetails['media_type'];
    if (mediaType == "image") {
      imageUrl = apoddetails['hdurl'];
    } else {
      imageUrl = null;
    }
  }

  @override
  initState() {
    super.initState();
    dateTime = DateTime.now();
    year = dateTime.year.toString();
    month = dateTime.month.toString();
    day = dateTime.day.toString();
    getApodData(year: year, month: month, day: day)
        .then((response) => displayApod(response))
        .catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: 100.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xff121212),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Text('Astronomy Picture of the Day',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(color: Colors.white, fontSize: 20.0),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                child: Text(imageTitle,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 30.0,
                      ),
                    )),
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(day + "-" + month + "-" + year),
                        ),
                        decoration:
                            BoxDecoration(border: Border.all(width: 1.5)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Text(
                        'Select Date',
                      ),
                      Icon(
                        Icons.calendar_today,
                      )
                    ],
                  ),
                ),
                onTap: () async => await datePicker(context),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                        )
                      : mediaType == "video"
                          ? Text("image is not available")
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 300.0,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      child: Container(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text(imageInfo,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
