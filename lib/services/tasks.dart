import 'dart:async';
import 'dart:convert';
import 'package:cerf_mobile/model/Task.dart';
import 'package:cerf_mobile/services/graphql.dart';
import './queries/task_queries.dart' as queries;
import 'package:http/http.dart' as http;

Future<List<Task>> fetchTasks() async {
  String cookie = await getMobileCookie();
  final http.Response response =
      await runQuery(queries.currentUserTasks, cookie);
  Map<String, dynamic> jsonResponse = json.decode(response.body)['data'];

  if (jsonResponse['error'] != null) {
    print("error with graphQL query");
    return null;
  }
  
  var list = jsonResponse['myTasks'] as List;

  if (list != null) {
    return list.map((t) => Task.fromJson(t)).toList();
  } else {
    return null;
  }
}
