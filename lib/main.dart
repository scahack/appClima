import 'package:flutter/material.dart';
import 'weather_api.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TemperaturaPantalla(),
    );
  }
}

class TemperaturaPantalla extends StatefulWidget {
  // final String ciudad;

  _TemperaturaEstado createState() => _TemperaturaEstado();
}

class _TemperaturaEstado extends State<TemperaturaPantalla> {
  final _ciudadControlador = TextEditingController();
  String _ciudad = '';
  Map<String, dynamic>? _datosClima;
  bool _isLoading = false;

  Future<void> _getDatosClima() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weatherData = await WeatherAPI.getClima(_ciudad);
      setState(() {
        _datosClima = weatherData;
      });
    } catch (e) {
      //  exception
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _ciudadControlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima APP'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _ciudadControlador,
                decoration: InputDecoration(
                  hintText: 'Escriba una ciudad...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _ciudad = value;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _getDatosClima,
                child: Text('Consultar clima'),
              ),
              SizedBox(height: 16.0),
              if (_isLoading)
                CircularProgressIndicator()
              else if (_datosClima != null)
                Column(
                  children: [
                    Text(
                      '${_datosClima!['temperature']} °C',
                      style: TextStyle(fontSize: 50),
                    ),
                    Text(
                      _datosClima!['description'],
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )
              else
                Text('Ingrese una ciudad para ver el clima'),
            ],
          ),
        ),
      ),
    );
  }
}
