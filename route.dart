import 'location.dart';

class Route {
  Route(this._locations);
  int _currentLocation = 0;

  final List<Location> _locations;

  Location moveNext() {
    if (_currentLocation < _locations.length - 1) {
      _currentLocation++;
    } else if (_currentLocation == _locations.length - 1) {
      _currentLocation = 0;
    }

    return _locations[_currentLocation];
  }
}
