// TODO Implement this library.
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      home: const FavoriteScreen(),
    );
  }
}

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final List<Map<String, String>> favoriteCities = [];
  final TextEditingController cityController = TextEditingController();

  void addCity() {
    setState(() {
      if (cityController.text.isNotEmpty) {
        favoriteCities.add({
          'city': cityController.text,
          'temperature': getFakeTemperature(cityController.text),
          'max_temp': '35°C',
          'min_temp': '20°C',
          'weather_state': 'Sunyy',
          'weather_bg': 'images/7dbbcfb8df98338ab19c912b85d23949.jpg',
        });
        cityController.clear();
      }
    });
  }

  String getFakeTemperature(String city) {
    List<String> fakeTemps = ['25°C', '30°C', '28°C', '22°C', '33°C'];
    return fakeTemps[city.length % fakeTemps.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'images/722dba9f787dc2c8ba1c515928191db9.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 28),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: const Text(
                  'Favorite Cities',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: cityController,
                              decoration: const InputDecoration(
                                hintText: 'Enter the city name...',
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30),
                                    bottom: Radius.circular(25),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.white54,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Color.fromARGB(228, 58, 143, 192),
                              size: 36,
                            ),
                            onPressed: addCity,
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: favoriteCities.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => CityWeatherScreen(
                                          cityName:
                                              favoriteCities[index]['city']!,
                                          temperature:
                                              favoriteCities[index]['temperature']!,
                                          maxTemp:
                                              favoriteCities[index]['max_temp']!,
                                          minTemp:
                                              favoriteCities[index]['min_temp']!,
                                          weatherState:
                                              favoriteCities[index]['weather_state']!,
                                          weatherBg:
                                              favoriteCities[index]['weather_bg']!,
                                        ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 16,
                                ),
                                child: ListTile(
                                  title: Text(
                                    favoriteCities[index]['city']!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Temperature: ${favoriteCities[index]['temperature']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
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
            ],
          ),
        ],
      ),
    );
  }
}

class CityWeatherScreen extends StatelessWidget {
  final String cityName;
  final String temperature;
  final String maxTemp;
  final String minTemp;
  final String weatherState;
  final String weatherBg;

  const CityWeatherScreen({
    super.key,
    required this.cityName,
    required this.temperature,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherState,
    required this.weatherBg,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(weatherBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  cityName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      temperature,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Max: $maxTemp',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'Min: $minTemp',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                weatherState,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
