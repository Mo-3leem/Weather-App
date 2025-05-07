import 'dart:convert';
import 'package:app/pages/alert_screen.dart';
import 'package:app/pages/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/pages/models/constants.dart';
import 'package:intl/intl.dart';
import '../widgets/weather_item.dart';
import 'package:app/pages/models/city.dart';
import 'package:app/pages/detail_page.dart';
import 'package:app/pages/favorite.dart';
import 'package:app/pages/weather_map_screen.dart'; // عدل المسار حسب مكان الملف

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Constants myConstants = Constants();
  int temperature = 0;
  int maxTemperature = 0;
  String weatherStateName = 'Loading...';
  int humidity = 0;
  int windSpeed = 0;

  String currentDate =
      'Loading...'; // Changed 'var' to 'String' for consistency
  String imageUrl = '';
  int woeid = 683802;
  String location = 'Cairo, Egypt';

  List<City> selectedCities =
      City.getSelectedCities(); // Ensure selectedCities is properly initialized
  List<String> cities = [
    'Cairo, Egypt',
    'Alexandria, Egypt',
    'Canada, Toronto',
    'London, UK',
    'Moscow, Russia',
    'Paris, France',
    'Tokyo, Japan',
    'Dubai, UAE',
    'Greenland, Denmark',
    'Burkina Faso, Africa',
  ];

  List<Map<String, dynamic>> consolidatedWeatherList =
      []; // Added type for clarity

  // Api calls

  String key = '4e89bfeef5e74be6a3a231655253004';
  String locationUrl = 'http://api.weatherapi.com/v1/search.json';
  String weatherUrl = 'http://api.weatherapi.com/v1/forecast.json';

  Future<void> fetchLocation(String location) async {
    var searchResult = await http.get(
      Uri.parse('$locationUrl?key=$key&q=$location'),
    );
    var result = jsonDecode(searchResult.body)[0];
    setState(() {
      woeid = result['id'];
    });
  }

  Future<void> fetchWeatherData() async {
    String id = woeid.toString();
    // int unixdt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    // String dt = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // print(Uri.parse('$weatherUrl?key=$key&q=id:$id&days=7'));

    var weatherResult = await http.get(
      Uri.parse('$weatherUrl?key=$key&q=id:$id&days=7'),
    );
    var result = json.decode(weatherResult.body);
    var consolidatedWeather = result['forecast']['forecastday'];
    // print(consolidatedWeather[0]);

    setState(() {
      consolidatedWeatherList.clear(); // Clear previous data

      // print(consolidatedWeather.length);
      for (int i = 0; i < consolidatedWeather.length; i++) {
        consolidatedWeatherList.add(consolidatedWeather[i]);
      }

      temperature = consolidatedWeather[0]['day']['avgtemp_c'].toInt();
      weatherStateName =
          consolidatedWeather[0]['day']['condition']['text'].toString();

      humidity = consolidatedWeather[0]['day']['avghumidity'].toInt();
      windSpeed = consolidatedWeather[0]['day']['maxwind_kph'].toInt();
      maxTemperature = consolidatedWeather[0]['day']['maxtemp_c'].toInt();

      var myDate = DateTime.parse(consolidatedWeather[0]['date']);
      currentDate = DateFormat('EEEE, d MMMM').format(myDate);

      imageUrl = 'https:${consolidatedWeather[0]['day']['condition']['icon']}'
          .replaceAll('64x64', '128x128');
    });
  }

  @override
  void initState() {
    fetchLocation(cities[0]);
    fetchWeatherData();

    for (int i = 0; i < selectedCities.length; i++) {
      cities.add(selectedCities[i].city);
    }

    super.initState();
  }

  // http://api.weatherapi.com/v1/current.json?key=$key&q=egypt,alexandria

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[
      Color.fromARGB(255, 85, 14, 250),
      Color.fromARGB(255, 54, 168, 244),
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 75, 97),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleSpacing: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  '../../assets/logo.png',
                  width: 40,
                  height: 40,
                ),
              ),
              // Location Dropdown
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('../../assets/pin.png', width: 20),
                  const SizedBox(width: 4),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      style: const TextStyle(color: Colors.white),
                      value: location,
                      focusColor: const Color.fromARGB(0, 0, 0, 0),
                      dropdownColor: const Color.fromARGB(255, 2, 127, 158),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items:
                          cities.map((String location) {
                            return DropdownMenuItem(
                              value: location,
                              child: Text(location),
                            );
                          }).toList(),
                      onChanged: (String? newValue) async {
                        setState(() {
                          location = newValue!;
                        });
                        await fetchLocation(
                          location,
                        ); // Ensure location is fetched first
                        await fetchWeatherData(); // Then fetch weather data
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoriteScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Color.fromARGB(255, 247, 16, 16),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AlertScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // ------------------------------------------------------------------
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 1, 75, 97),
              Color.fromARGB(200, 10, 100, 165),
              Color.fromARGB(123, 25, 185, 206),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
              Text(
                currentDate,
                style: const TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
              const SizedBox(height: 50),

              Container(
                width: size.width,
                height: 200,
                decoration: BoxDecoration(
                  color: myConstants.primaryColor,
                  // gradient: myConstants.primaryGradient,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: myConstants.primaryColor.withOpacity(0.5),
                      offset: const Offset(0, 25),
                      blurRadius: 10,
                      spreadRadius: -12,
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 120,
                      right: 30,
                      child: IconButton(
                        icon: const Icon(
                          Icons.location_on,
                          color: Color.fromARGB(255, 98, 214, 243),
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WeatherMapScreen(),
                            ),
                          );
                        },
                      ),
                    ),

                    Positioned(
                      top: -20,
                      left: -35,
                      child:
                          imageUrl == ''
                              ? const Text('')
                              : Image.network(
                                imageUrl, // use your actual image URL
                                width: 200,
                              ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 20,
                      child: Text(
                        weatherStateName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              temperature.toString(),
                              style: const TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            'o',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    weatherItem(
                      text: 'Wind Speed',
                      value: windSpeed,
                      unit: 'km/h',
                      imageUrl: '../../assets/windspeed.png',
                    ),
                    weatherItem(
                      text: 'Humidity',
                      value: humidity,
                      unit: '',
                      imageUrl: '../../assets/humidity.png',
                    ),
                    weatherItem(
                      text: 'Wind Speed',
                      value: maxTemperature,
                      unit: 'C',
                      imageUrl: '../../assets/max-temp.png',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Today',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color.fromARGB(255, 29, 29, 29),
                    ),
                  ),
                  Text(
                    'Next 7 Days',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: myConstants.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: consolidatedWeatherList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String today = DateTime.now().toString().substring(0, 10);
                    var selectedDay = consolidatedWeatherList[index]['date'];

                    var weatherUrl =
                        consolidatedWeatherList[index]['day']['condition']['icon']
                            .toString()
                            .replaceAll('64x64', '128x128');

                    var parsedDate = DateTime.parse(
                      consolidatedWeatherList[index]['date'],
                    );
                    var newDate = DateFormat(
                      'EEEE',
                    ).format(parsedDate).substring(0, 3); //formateed date

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DetailPage(
                                  consolidatedWeatherList:
                                      consolidatedWeatherList,
                                  selectedId: index,
                                  location: location,
                                ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        margin: const EdgeInsets.only(
                          right: 20,
                          bottom: 10,
                          top: 10,
                        ),
                        width: 80,
                        decoration: BoxDecoration(
                          color:
                              selectedDay == today
                                  ? myConstants.primaryColor
                                  : Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 1),
                              blurRadius: 5,
                              color:
                                  selectedDay == today
                                      ? myConstants.primaryColor
                                      : const Color.fromARGB(52, 0, 0, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${consolidatedWeatherList[index]['day']['avgtemp_c'].round()}°C',
                              style: TextStyle(
                                fontSize: 17,
                                color:
                                    selectedDay == today
                                        ? Colors.white
                                        : myConstants.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Image.network(weatherUrl, width: 30),
                            Text(
                              newDate,
                              style: TextStyle(
                                fontSize: 17,
                                color:
                                    selectedDay == today
                                        ? Colors.white
                                        : myConstants.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // -------------------------------------------------------------------------------
    );
  }
}
