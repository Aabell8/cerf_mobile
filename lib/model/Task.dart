import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task {
  String id;
  String name;
  int order;
  bool isAllDay;
  DateTime windowStart;
  DateTime windowEnd;
  int duration;
  String address;
  String city;
  String province;
  double lat;
  double lng;
  String notes;
  String status;
  String email;
  String phone;

  Task({
    this.id,
    this.name,
    this.order,
    this.windowStart,
    this.windowEnd,
    this.duration: 0,
    this.address,
    this.city,
    this.province,
    this.lat,
    this.lng,
    this.status,
    this.notes,
    this.email,
    this.phone,
    this.isAllDay: false,
  });

  Task copyWith({
    id,
    name,
    order,
    windowStart,
    windowEnd,
    duration,
    address,
    city,
    province,
    lat,
    lng,
    status,
    notes,
    isAllDay,
    email,
    phone
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      windowStart: windowStart ?? this.windowStart,
      windowEnd: windowEnd ?? this.windowEnd,
      duration: duration ?? this.duration,
      address: address ?? this.address,
      city: city ?? this.city,
      province: province ?? this.province,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isAllDay: isAllDay ?? this.isAllDay,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    DateTime windowStart = DateTime.fromMillisecondsSinceEpoch(
      int.tryParse(json['windowStart']),
      // isUtc: true,
    );
    DateTime windowEnd = DateTime.fromMillisecondsSinceEpoch(
      int.tryParse(json['windowEnd']),
      // isUtc: true,
    );
    return Task(
      id: json['id'] as String,
      name: json['name'] as String,
      order: json['order'] as int,
      windowStart: windowStart,
      windowEnd: windowEnd,
      duration: json['duration'] as int,
      address: json['address'] as String,
      city: json['city'] as String,
      province: json['province'] as String,
      lat: json['lat'] as double,
      lng: json['lng'] as double,
      status: json['status'] as String,
      notes: json['notes'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      isAllDay: json['isAllDay'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'order': order,
        'windowStart': windowStart.toString(),
        'windowEnd': windowEnd.toString(),
        'duration': duration,
        'address': address,
        'city': city,
        'province': province,
        'lat': lat,
        'lng': lng,
        'status': status,
        'notes': notes,
        'email': email,
        'phone': phone,
        'isAllDay': isAllDay,
      };

  static TimeOfDay toTimeOfDay(String date) {
    DateTime parsed = DateTime.parse(date);
    return TimeOfDay(hour: parsed.hour, minute: parsed.minute);
  }

  static String timeOfDayFormat(
      DateTime timeStart, DateTime timeEnd, bool isAllDay) {
    if (isAllDay) {
      return "today";
    } else if (timeStart == null || timeEnd == null) {
      return "";
    } else {
      return '${DateFormat.jm().format(timeStart)}-${DateFormat.jm().format(timeEnd)}';
    }
  }
}
