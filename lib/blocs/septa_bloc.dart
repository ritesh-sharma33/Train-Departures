import 'package:rxdart/rxdart.dart';
import 'package:train_dep/models/train.dart';
import '../services/septa_service.dart';

class SeptaBloc {
  final _trains = BehaviorSubject<List<Train>>();
  final _station = BehaviorSubject<String>();
  final _count = BehaviorSubject<int>();
  final _directions = BehaviorSubject<List<String>>();
  final _septaService = SeptaService();

  SeptaBloc() {
    loadSettings();

    // Setting up the listeners
    // Here we are just listening to station subject just because we need to fetch the data when the station is changed.

    _station.listen((station) async {
      changeTrains(await _septaService.loadStationData(station));
    });
  }

  // Getters
  Stream<List<Train>> get trains => _trains.stream.map((trainList) => trainList
      .where((train) => _directions.value.contains(train.direction))
      .take(_count.value)
      .toList());

  Stream<int> get count => _count.stream;
  Stream<String> get station => _station.stream;
  Stream<List<String>> get directions => _directions.stream;

  // Setters
  Function(List<Train>) get changeTrains => _trains.sink.add;
  Function(String) get changeStation => _station.sink.add;
  Function(int) get changeCount => _count.sink.add;
  Function(List<String>) get changeDirections => _directions.sink.add;

  dispose() {
    _trains.close();
    _count.close();
    _station.close();
    _directions.close();
  }

  void loadSettings() {
    changeCount(10);
    changeDirections(["N", "S"]);
    changeStation('Suburban Station');
  }
}
