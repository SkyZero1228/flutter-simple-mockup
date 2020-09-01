class Locations {
  int id;
  String type;
  String title;
  double lat;
  double lng;

  Locations.fromJson(Map json)
      : id = json['entity_id'],
        type = json['entity_type'],
        title = json['title'],
        lat = json['latitude'],
        lng = json['longitude'];

  @override
  setLatLng(double _lat, double _lng) {
    lat = _lat;
    lng = _lng;
  }
}
