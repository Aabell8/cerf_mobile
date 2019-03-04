import 'dart:async';
import 'dart:convert';
import 'package:cerf_mobile/model/Task.dart';
import 'package:cerf_mobile/services/graphql.dart';
import './queries/task_queries.dart' as queries;
import './mutations/task_mutations.dart' as mutations;
import 'package:http/http.dart' as http;

Future<List<Task>> fetchTasks() async {
  String cookie = await getMobileCookie();

  int timeZone = new DateTime.now().timeZoneOffset.inHours;

  Map<String, dynamic> variables = {
    'timeZone': timeZone,
  };

  final http.Response response =
      await runQuery(queries.currentUserTasks, cookie, variables: variables);
  Map<String, dynamic> jsonResponse = json.decode(response.body)['data'];

  if (jsonResponse['errors'] != null || jsonResponse['error'] != null) {
    throw Exception("error with graphQL query");
  }
  var list = jsonResponse['myTasks'] as List;

  if (list != null) {
    return list.map((t) => Task.fromJson(t)).toList();
  } else {
    return [];
  }
}

Future<Task> createTask(Task task) async {
  String cookie = await getMobileCookie();

  Map<String, dynamic> taskMap = task.toJson();

  final http.Response response =
      await runQuery(mutations.createTask, cookie, variables: taskMap);

  Map<String, dynamic> jsonResponse = json.decode(response.body)['data'];
  if (jsonResponse['errors'] != null || jsonResponse['error'] != null) {
    throw Exception("Error with graphQL query::: ${jsonResponse['errors']}");
  }

  jsonResponse = jsonResponse['createTask'];

  if (jsonResponse != null) {
    return Task.fromJson(jsonResponse);
  } else {
    return null;
  }
}

Future<Task> updateTaskStatus(Task task) async {
  String cookie = await getMobileCookie();

  Map<String, dynamic> taskMap = task.toJson();

  final http.Response response =
      await runQuery(mutations.updateTaskStatus, cookie, variables: taskMap);

  Map<String, dynamic> jsonResponse = json.decode(response.body)['data'];
  if (jsonResponse['errors'] != null || jsonResponse['error'] != null) {
    throw Exception("Error with graphQL query::: ${jsonResponse['errors']}");
  }

  jsonResponse = jsonResponse['updateTask'];

  if (jsonResponse != null) {
    return Task.fromJson(jsonResponse);
  } else {
    return null;
  }
}
