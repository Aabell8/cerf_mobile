import 'dart:async';
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
  Map<String, dynamic> jsonResponse = parseGQLResponse(response);

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

  Map<String, dynamic> jsonResponse = parseGQLResponse(response);

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

  Map<String, dynamic> jsonResponse = parseGQLResponse(response);

  jsonResponse = jsonResponse['updateTask'];

  if (jsonResponse != null) {
    return Task.fromJson(jsonResponse);
  } else {
    return null;
  }
}

Future<bool> updateTaskOrder(List<Task> tasks) async {
  String cookie = await getMobileCookie();

  List<String> ids = tasks.map((task) => task.id).toList();

  Map<String, dynamic> requestMap = {"ids": ids};

  final http.Response response =
      await runQuery(mutations.updateTaskOrder, cookie, variables: requestMap);

  Map<String, dynamic> jsonResponse = parseGQLResponse(response);

  if (jsonResponse['updateTaskOrder'].toString() == "true") {
    return true;
  }
  return false;
}

Future<List<Task>> optimizeTasks(List<Task> tasks) async {
  String cookie = await getMobileCookie();

  List<String> ids = tasks.map((task) => task.id).toList();

  Map<String, dynamic> variables = {
    'ids': ids,
  };

  final http.Response response =
      await runQuery(queries.optimizeTasks, cookie, variables: variables);
  Map<String, dynamic> jsonResponse = parseGQLResponse(response);

  var list = jsonResponse['optimizedTasks'] as List;

  if (list != null) {
    return list.map((t) => Task.fromJson(t)).toList();
  } else {
    return [];
  }
}
