import '../models/train.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SeptaService {
  Future<List<Train>> loadStationData(String station) async {
    // Send get request
    var response =
        await http.get("http://www3.septa.org/hackathon/Arrivals/$station/10");

    if (response.statusCode == 200) {
      // Build the train list
      var trains = List<Train>();

      try {
        var json = convert.jsonDecode('{"Departures": ' +
            response.body.substring(response.body.indexOf('[')));
        var north = json['Departures'][0]['Northbound'];
        var south = json['Departures'][1]['Southbound'];

        north.forEach((train) => trains.add(Train.fromJSON(train)));
        south.forEach((train) => trains.add(Train.fromJSON(train)));
      } catch (e) {
        print(e);
      }

      // Sorting
      trains.sort((a, b) => a.departTime.compareTo(b.departTime));
      print(trains);
      // update to stream
      return trains;
    }
  }
}
