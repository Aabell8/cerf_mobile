import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './mutations/auth_mutations.dart' as mutations;
import './queries/auth_queries.dart' as queries;
import 'package:cerf_mobile/model/User.dart';

abstract class BaseAuth {
  Future<String> loginWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  Auth({
    String cookie,
  }) {
    this.cookie = cookie; //TODO: get cookie from storage or pass into here
    this.client = http.Client();
  }

  String cookie;
  http.Client client;
  String url = "http://localhost:5000/graphql";

  Future<String> loginWithEmailAndPassword(
      String email, String password) async {
    Map<String, dynamic> variables = {
      'email': email,
      'password': password,
    };
    User user;
    try {
      final http.Response response =
          await _runQuery(mutations.login, variables: variables);
      final Map<String, dynamic> parsedRes = _parseGQLResponse(response);

      user = User.fromJson(parsedRes['login']);
    } catch (e) {
      print(e);
    }

    return user?.id;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    return "user?.uid";
  }

  Future<String> currentUser() async {
    User user;
    try {
      final http.Response response = await _runQuery(queries.current_user);
      final Map<String, dynamic> parsedRes = _parseGQLResponse(response);

      user = User.fromJson(parsedRes['me']);
      return user.id;
    } catch (e) {
      print(e);
    }
    return user?.id;
  }

  Future<void> signOut() async {
    cookie = null;
    // TODO: clear cookie from storage
    try {
      final http.Response response = await _runQuery(mutations.logout);
      if (response.statusCode != 200) {
        // TODO: Change exception to custom and handle response
        throw Exception("error in logging out");
      }
      // final Map<String, dynamic> parsedRes = _parseGQLResponse(response);
      // print(parsedRes);
      return;
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> _parseGQLResponse(http.Response response) {
    final int statusCode = response.statusCode;
    final String reasonPhrase = response.reasonPhrase;

    try {
      String cookieString = response.headers['set-cookie'];
      if (cookieString != null) {
        cookie = cookieString.split(';')[0];
        // TODO: Store cookie in storage
      }
    } catch (e) {
      print("error in setting cookie $e");
    }

    if (statusCode < 200 || statusCode >= 400) {
      throw http.ClientException(
        'Network Error: $statusCode $reasonPhrase',
      );
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (jsonResponse['errors'] != null && jsonResponse['errors'].length > 0) {
      throw Exception(
        'Error returned by the GQL server in the query: ${jsonResponse['errors'][0]}',
      );
    }

    return jsonResponse['data'];
  }

  Future<http.Response> _runQuery(String query,
      {Map<String, dynamic> variables}) {
    final String body = json.encode({
      'query': query,
      'variables': variables,
    });

    Map<String, String> headers = {
      'Cookie': '$cookie',
      'Content-Type': 'application/json',
    };

    return client.post(
      url,
      headers: headers,
      body: body,
    );
  }
}
