import 'package:flutter/material.dart';

class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key});

  // Replace this with your actual list of alerts
  final List<WeatherAlert> _alerts = const [
    WeatherAlert(
      title: 'Severe Thunderstorm Watch',
      description: 'A severe thunderstorm watch is in effect until 10:00 PM.',
      severity: 'High',
    ),
    WeatherAlert(
      title: 'Heat Advisory',
      description: 'A heat advisory is in effect for the area. Stay hydrated.',
      severity: 'Medium',
    ),
    // Add more alerts here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Alerts')),
      body:
          _alerts.isEmpty
              ? const Center(child: Text('No current weather alerts.'))
              : ListView.builder(
                itemCount: _alerts.length,
                itemBuilder: (context, index) {
                  final alert = _alerts[index];
                  Color severityColor;
                  switch (alert.severity.toLowerCase()) {
                    case 'high':
                      severityColor = Colors.redAccent;
                      break;
                    case 'medium':
                      severityColor = Colors.orangeAccent;
                      break;
                    case 'low':
                      severityColor = Colors.yellowAccent;
                      break;
                    default:
                      severityColor = Colors.grey;
                  }
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            alert.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(alert.description),
                          const SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              const Text('Severity: '),
                              Chip(
                                label: Text(alert.severity),
                                backgroundColor: severityColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

// A simple model for a weather alert
class WeatherAlert {
  final String title;
  final String description;
  final String severity;

  const WeatherAlert({
    required this.title,
    required this.description,
    required this.severity,
  });
}
