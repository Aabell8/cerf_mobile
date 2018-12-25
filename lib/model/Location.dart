class Location {
  double lng;
  double lat;
  String time;

  Location({
    this.lng,
    this.lat,
    this.time,
  });

  Location copyWith({
    lng,
    email,
    time,
  }) {
    return Location(
      lng: lng ?? this.lng,
      lat: email ?? this.lat,
      time: time ?? this.time,
    );
  }

  Location.fromJson(Map<String, dynamic> json)
      : lng = json['lng'],
        lat = json['lat'],
        time = json['time'];

  Map<String, dynamic> toJson() => {
        'lng': lng,
        'lat': lat,
        'time': time,
      };
}
