import 'dart:async';
import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart'
    show Client, InMemoryCache;
import 'package:http/http.dart' as http;

import './mutations/login.dart' as mutations;
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
    this.cookie = cookie;
    this.client = http.Client();
  }

  String cookie;
  http.Client client;
  String url = "http://localhost:5000/graphql";

  Future<String> loginWithEmailAndPassword(
      String email, String password) async {
    // String url = "http://localhost:5000/graphql";
    // final Client gqlclient = Client(
    //   endPoint: url,
    //   cache: InMemoryCache(),
    // );

    // http.Client client = http.Client();
    Map<String, dynamic> variables = {
      'email': email,
      'password': password,
    };

    final String body = _encodeBody(
      mutations.login,
      variables: variables,
    );

    // print(body);

    Map<String, String> headers = {
      'Cookie': '$cookie',
      'Content-Type': 'application/json',
    };

    User user;
    try {
      final http.Response response = await client.post(
        url,
        headers: headers,
        body: body,
      );

      final Map<String, dynamic> parsedRes = _parseGQLResponse(response);
      user = User.fromJson(parsedRes['login']);
      return user.id;
    } catch (e) {
      print(e);
    }

    return "invalid result from server";
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    // FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
    //     email: email, password: password);
    return "user?.uid";
  }

  Future<String> currentUser() async {
    // FirebaseUser user = await _firebaseAuth.currentUser();
    return "user?.uid";
  }

  Future<void> signOut() async {
    return "_firebaseAuth.signOut()";
  }

  Map<String, dynamic> _parseGQLResponse(http.Response response) {
    final int statusCode = response.statusCode;
    final String reasonPhrase = response.reasonPhrase;

    try {
      String cookieString = response.headers['set-cookie'];
      cookie = cookieString.split(';')[0];
    } catch (e) {
      print("could not get cookie: $e");
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

  String _encodeBody(
    String query, {
    Map<String, dynamic> variables,
  }) {
    return json.encode({'query': query, 'variables': variables});
  }
}
