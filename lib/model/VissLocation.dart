class VissLocation {
  double lng;
  double lat;
  String time;

  VissLocation({
    this.lng,
    this.lat,
    this.time,
  });

  VissLocation copyWith({
    lng,
    email,
    time,
  }) {
    return VissLocation(
      lng: lng ?? this.lng,
      lat: email ?? this.lat,
      time: time ?? this.time,
    );
  }

  VissLocation.fromJson(Map<String, dynamic> json)
      : lng = json['lng'],
        lat = json['lat'],
        time = json['time'];

  Map<String, dynamic> toJson() => {
        'lng': lng,
        'lat': lat,
        'time': time,
      };
}
