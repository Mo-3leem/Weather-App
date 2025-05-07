// TODO Implement this library.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:string_similarity/string_similarity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق الطقس',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherMapScreen(),
    );
  }
}

class WeatherMapScreen extends StatefulWidget {
  const WeatherMapScreen({super.key});

  @override
  _WeatherMapScreenState createState() => _WeatherMapScreenState();
}

class _WeatherMapScreenState extends State<WeatherMapScreen> {
  String _selectedCity = "Cairo";
  String _temperature = "--";
  LatLng _cityLocation = LatLng(30.0444, 31.2357);
  TextEditingController _searchController = TextEditingController();

  final Map<String, LatLng> cities = {
    "Cairo": LatLng(30.0444, 31.2357),
    "Alexandria": LatLng(31.2001, 29.9187),
    "Aswan": LatLng(24.0889, 32.8998),
    "Hurghada": LatLng(27.2579, 33.8116),
  };

  @override
  void initState() {
    super.initState();
    _fetchWeather(_cityLocation.latitude, _cityLocation.longitude);
    _searchController.addListener(_updateCityFromSearch);
  }

  Future<void> _fetchWeather(double lat, double lon) async {
    try {
      String url =
          "https://api.weatherapi.com/v1/current.json?key=4e89bfeef5e74be6a3a231655253004&q=$lat,$lon";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _temperature = "${data['current']['temp_c']}°C";
        });
      } else {
        print("فشل في جلب بيانات الطقس");
      }
    } catch (e) {
      print("خطأ في استدعاء API: $e");
    }
  }

  String _findClosestCity(String query) {
    if (query.isEmpty) return _selectedCity;

    double maxSimilarity = 0.0;
    String closestCity = _selectedCity;

    for (var city in cities.keys) {
      double similarity = query.similarityTo(city);
      if (similarity > maxSimilarity) {
        maxSimilarity = similarity;
        closestCity = city;
      }
    }

    return closestCity;
  }

  void _updateCityFromSearch() {
    String query = _searchController.text.trim();
    String closestCity = _findClosestCity(query);

    if (cities.keys.contains(closestCity)) {
      setState(() {
        _selectedCity = closestCity;
        _cityLocation = cities[_selectedCity]!;
        _fetchWeather(_cityLocation.latitude, _cityLocation.longitude);
      });
    }
  }

  void _updateCitySelection(String newCity) {
    setState(() {
      _selectedCity = newCity;
      _cityLocation = cities[_selectedCity]!;
      _fetchWeather(_cityLocation.latitude, _cityLocation.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Search here ...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (query) {
                    String closestCity = _findClosestCity(query);
                    if (cities.keys.contains(closestCity)) {
                      setState(() {
                        _selectedCity = closestCity;
                        _cityLocation = cities[_selectedCity]!;
                        _fetchWeather(
                          _cityLocation.latitude,
                          _cityLocation.longitude,
                        );
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(143, 89, 160, 219),
        actions: [
          DropdownButton<String>(
            value: _selectedCity,
            items:
                cities.keys.map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
            onChanged: (newValue) {
              if (newValue != null) _updateCitySelection(newValue);
            },
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: _cityLocation,
          zoom: 5.0, // مستوى التكبير الافتراضي
          minZoom: 2.0, // يسمح بتصغير كبير لرؤية مساحة واسعة
          maxZoom: 22.0,
          interactiveFlags:
              InteractiveFlag.pinchZoom |
              InteractiveFlag.drag, // تفعيل التكبير باللمس والسحب
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _cityLocation,
                width: 80,
                height: 80,
                builder:
                    (ctx) => Column(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 40,
                        ),
                        Text(
                          _temperature,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
