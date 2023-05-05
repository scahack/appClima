import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherAPI {
  static const apiKey = 'KDrDidT9Sa1fPce9KUxS9OxWfqAPScCK'; // clave de API

  static Future<Map<String, dynamic>> getClima(String city) async {
    final url =
        'http://dataservice.accuweather.com/locations/v1/cities/search?apikey=$apiKey&q=$city&language=es-es';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final locationKey = body[0]['Key'];

      final currentUrl =
          'http://dataservice.accuweather.com/currentconditions/v1/$locationKey?apikey=$apiKey&language=es-es';
      final currentResponse = await http.get(Uri.parse(currentUrl));

      if (currentResponse.statusCode == 200) {
        final currentBody = json.decode(currentResponse.body);
        return {
          'temperatura': currentBody[0]['Temperature']['Metric']['Value'],
          'descripcion': currentBody[0]['WeatherText'],
        };
      } else {
        throw Exception('Error al cargar el clima');
      }
    } else {
      throw Exception('Error al cargar la ciudad');
    }
  }

  static Future<double> getTemperatura(String city) async {
    final apiKey = 'KDrDidT9Sa1fPce9KUxS9OxWfqAPScCK';
    final queryParameters = {'apikey': apiKey, 'q': city, 'language': 'es-es'};
    final uri = Uri.https(
        'dataservice.accuweather.com', '/locations/v1/search', queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final locationKey =
          (jsonDecode(response.body) as List<dynamic>).first['Key'];
      final temperatureUri = Uri.https(
          'dataservice.accuweather.com',
          '/currentconditions/v1/$locationKey',
          {'apikey': apiKey, 'language': 'es-es'});

      final temperatureResponse = await http.get(temperatureUri);

      if (temperatureResponse.statusCode == 200) {
        final temperatureJson =
            jsonDecode(temperatureResponse.body) as List<dynamic>;
        final temperatura =
            temperatureJson.first['Temperature']['Metric']['Value'] as double;
        return temperatura;
      } else {
        throw Exception('No se pudo cargar la temperatura');
      }
    } else {
      throw Exception('No se pudo cargar la temperatura');
    }
  }
}
