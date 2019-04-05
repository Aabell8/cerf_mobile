import 'dart:async';
import 'package:cerf_mobile/model/User.dart';
import 'package:cerf_mobile/services/graphql.dart';
import './mutations/user_mutations.dart' as mutations;
import 'package:http/http.dart' as http;

Future<User> updateUser(Map<String, dynamic> variables) async {
  String cookie = await getMobileCookie();

  final http.Response response =
      await runQuery(mutations.updateUser, cookie, variables: variables);
  Map<String, dynamic> jsonResponse = parseGQLResponse(response);

  if (jsonResponse['error'] != null) {
    throw Exception(jsonResponse['error']);
  }

  User user;
  try {
    user = User.fromJson(jsonResponse['updateUser']);
  } catch (e) {
    throw Exception("Error in parsing user response: ${e.toString()}");
  }

  return user;
}
