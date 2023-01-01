import 'location.dart';

class Route {
  Route(this._locations);
  int _currentLocation = 0;
  bool _isForward = true;
  final List<Location> _locations;

  Location moveNext() {
    if (_currentLocation < _locations.length - 1 && _isForward) {
      _currentLocation++;
    } else if (_currentLocation == _locations.length - 1) {
      _isForward = false;
    }
    if (_currentLocation > 0 && !_isForward) {
      _currentLocation--;
    } else if (_currentLocation == 0) {
      _isForward = true;
    }
    return _locations[_currentLocation];
  }
}
