import 'package:app/pages/alert_screen.dart';
import 'package:app/pages/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:app/pages/models/constants.dart';
import '../widgets/weather_item.dart';

class DetailPage extends StatefulWidget {
  final List consolidatedWeatherList;
  final int selectedId;
  final String location;

  const DetailPage({
    super.key,
    required this.consolidatedWeatherList,
    required this.selectedId,
    required this.location,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();

    //Create a shader linear gradient
    final Shader linearGradient = const LinearGradient(
      colors: <Color>[
        Color.fromARGB(255, 232, 225, 245),
        Color.fromARGB(255, 240, 237, 243),
      ],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    int selectedIndex = widget.selectedId;
    var weatherStateName =
        widget
            .consolidatedWeatherList[selectedIndex]['day']['condition']['text'];

    imageUrl =
        'https:${widget.consolidatedWeatherList[selectedIndex]['day']['condition']['icon']}'
            .replaceAll('64x64', '128x128');

    return Scaffold(
      backgroundColor: myConstants.secondaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: myConstants.secondaryColor,

        // elevation: 0.0,
        title: Text(widget.location),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AlertScreen()),
                );
              },
              icon: const Icon(Icons.notifications),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: SizedBox(
              height: 130,
              width: size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.consolidatedWeatherList.length,
                itemBuilder: (BuildContext context, int index) {
                  var weatherURL =
                      'https:${widget.consolidatedWeatherList[selectedIndex]['day']['condition']['icon']}'
                          .replaceAll('64x64', '128x128');

                  var parsedDate = DateTime.parse(
                    widget.consolidatedWeatherList[index]['date'],
                  );

                  var newDate = DateFormat(
                    'EEEE',
                  ).format(parsedDate).substring(0, 3);

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    margin: const EdgeInsets.only(right: 15),
                    width: 90,
                    decoration: BoxDecoration(
                      color:
                          index == selectedIndex
                              ? Colors.white
                              : const Color.fromARGB(137, 63, 109, 153),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          blurRadius: 5,
                          color: const Color.fromARGB(
                            101,
                            132,
                            164,
                            194,
                          ).withAlpha((0.3 * 255).toInt()),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.consolidatedWeatherList[index]['day']['avgtemp_c'].round()}°C',
                          style: TextStyle(
                            fontSize: 17,
                            color:
                                index == selectedIndex
                                    ? Colors.deepPurple
                                    : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Image.network(weatherURL, width: 40),
                        Text(
                          newDate,
                          style: TextStyle(
                            fontSize: 17,
                            color:
                                index == selectedIndex
                                    ? Colors.deepPurple
                                    : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 0,
            child: Container(
              height: size.height * .57,
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -100, // the box place
                    right: 20,
                    left: 20,
                    child: Container(
                      width: size.width * .7,
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: myConstants.secondaryGradient,

                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              24,
                              149,
                              33,
                              243,
                            ).withAlpha((0.1 * 255).toInt()),
                            offset: const Offset(0, 25),
                            blurRadius: 3,
                            spreadRadius: -10,
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -30,
                            left: -30,
                            child: Image.network(imageUrl, width: 200),
                          ),
                          Positioned(
                            top: 120,
                            left: 30,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                weatherStateName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(
                              width: size.width * .8,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,

                                children: [
                                  weatherItem(
                                    text: 'Wind Speed',
                                    value:
                                        widget
                                            .consolidatedWeatherList[selectedIndex]['day']['maxwind_kph']
                                            .round(),
                                    unit: 'km/h',
                                    imageUrl: '../../assets/windspeed.png',
                                    white: true,
                                  ),
                                  weatherItem(
                                    text: 'Humidity',
                                    value:
                                        widget
                                            .consolidatedWeatherList[selectedIndex]['day']['avghumidity']
                                            .round(),
                                    unit: '',
                                    imageUrl: '../../assets/humidity.png',
                                    white: true,
                                  ),
                                  weatherItem(
                                    text: 'Max Temp',
                                    value:
                                        widget
                                            .consolidatedWeatherList[selectedIndex]['day']['maxtemp_c']
                                            .round(),
                                    unit: 'C',
                                    imageUrl: '../../assets/max-temp.png',
                                    white: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget
                                      .consolidatedWeatherList[selectedIndex]['day']['avgtemp_c']
                                      .round()
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    foreground:
                                        Paint()..shader = linearGradient,
                                  ),
                                ),
                                Text(
                                  'o',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    foreground:
                                        Paint()..shader = linearGradient,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 200,
                    left: 20,
                    child: SizedBox(
                      height: size.height * .214,
                      width: size.width * .9,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.consolidatedWeatherList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var futureImageURL =
                              'https:${widget.consolidatedWeatherList[index]['day']['condition']['icon']}'
                                  .replaceAll('64x64', '128x128');

                          var myDate = DateTime.parse(
                            widget.consolidatedWeatherList[index]['date'],
                          );

                          var currentDate = DateFormat(
                            'd MMMM, EEEE',
                          ).format(myDate);

                          return Container(
                            margin: const EdgeInsets.only(
                              left: 10,
                              top: 10,
                              right: 10,
                              bottom: 5,
                            ),
                            height: 70,
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: myConstants.secondaryColor.withAlpha(
                                    (0.1 * 255).toInt(),
                                  ),
                                  spreadRadius: 5,
                                  blurRadius: 20,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    currentDate,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 128, 102, 158),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget
                                            .consolidatedWeatherList[index]['day']['maxtemp_c']
                                            .round()
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Text(
                                        '/',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 30,
                                        ),
                                      ),
                                      Text(
                                        widget
                                            .consolidatedWeatherList[index]['day']['mintemp_c']
                                            .round()
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(futureImageURL, width: 30),
                                      Text(
                                        widget
                                            .consolidatedWeatherList[index]['day']['condition']['text'],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
