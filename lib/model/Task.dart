import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task {
  String id;
  bool isAllDay;
  TimeOfDay windowStart;
  TimeOfDay windowEnd;
  int duration;
  String address;
  String city;
  String province;
  double lat;
  double lng;
  String notes;
  String status;

  Task({
    this.id,
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
    this.isAllDay: false,
  });

  Task copyWith({
    id,
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
  }) {
    return Task(
      id: id ?? this.id,
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
      isAllDay: isAllDay ?? this.isAllDay,
    );
  }

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        windowStart = json['windowStart'],
        windowEnd = json['windowEnd'],
        duration = json['duration'],
        address = json['address'],
        city = json['city'],
        province = json['province'],
        lat = json['lat'],
        lng = json['lng'],
        status = json['status'],
        notes = json['notes'],
        isAllDay = json['isAllDay'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'windowStart': windowStart,
        'windowEnd': windowEnd,
        'duration': duration,
        'address': address,
        'city': city,
        'province': province,
        'lat': lat,
        'lng': lng,
        'status': status,
        'notes': notes,
        'isAllDay': isAllDay,
      };

  static String timeOfDayFormat(
      TimeOfDay timeStart, TimeOfDay timeEnd, bool isAllDay) {
    // Change static date
    if (isAllDay) {
      return "today";
    } else if (timeStart == null || timeEnd == null) {
      return "";
    } else {
      DateTime date = DateTime(2018, 08, 09, timeStart.hour, timeStart.minute);
      DateTime dateEnd = DateTime(2018, 08, 09, timeEnd.hour, timeEnd.minute);

      return '${DateFormat.jm().format(date)}-${DateFormat.jm().format(dateEnd)}';
    }
  }
}

const TimeOfDay startTime = TimeOfDay(hour: 8, minute: 0);
const endTime = TimeOfDay(hour: 9, minute: 0);

var testTasks = <Task>[
  Task(
      id: '1',
      windowStart: TimeOfDay(hour: 8, minute: 0),
      windowEnd: TimeOfDay(hour: 15, minute: 0),
      duration: 30,
      address: '12 St. George St, London',
      city: 'London',
      province: 'ON',
      notes:
          'These are some notes about the first item in the list. It must be done before 3pm today.',
      status: ''),
  Task(
      id: '2',
      isAllDay: true,
      duration: 40,
      address: '124 Richmond St',
      city: 'London',
      province: 'ON',
      notes:
          'These are some notes about the second item in the list. It can be done at any point in the day.',
      status: ''),
  Task(
      id: '3',
      windowStart: TimeOfDay(hour: 5, minute: 0),
      windowEnd: TimeOfDay(hour: 17, minute: 0),
      duration: 50,
      address: '566 Sunset Ave',
      city: 'London',
      province: 'ON',
      notes:
          'These are some notes about the third item in the list. It must be done before 5pm today.',
      status: ''),
  Task(
      id: '4',
      windowStart: TimeOfDay(hour: 12, minute: 0),
      windowEnd: TimeOfDay(hour: 15, minute: 0),
      duration: 50,
      address: '133 Pall Mall St',
      city: 'London',
      province: 'ON',
      notes:
          'These are some notes about the fourth item in the list. It must be done before 3pm today.',
      status: ''),
];
