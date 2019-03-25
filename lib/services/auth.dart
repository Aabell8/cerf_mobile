import 'dart:async';
import 'dart:convert';
import 'package:cerf_mobile/services/graphql.dart';
import 'package:http/http.dart' as http;

import './mutations/auth_mutations.dart' as mutations;
import './queries/auth_queries.dart' as queries;
import 'package:cerf_mobile/model/User.dart';

abstract class BaseAuth {
  Future<Map<String, String>> loginWithEmailAndPassword(
      String email, String password);
  Future<Map<String, String>> createUser(
      String name, String email, String password);
  Future<Map<String, String>> currentUser();
  Future<void> logout();
  String cookie;
}

class Auth implements BaseAuth {
  String cookie;
  String storageCookieKey = "graphql_cookie";

  Future<Map<String, String>> loginWithEmailAndPassword(
      String email, String password) async {
    Map<String, dynamic> variables = {
      'email': email,
      'password': password,
    };
    User user;
    try {
      final http.Response response =
          await runQuery(mutations.login, "", variables: variables);
      final Map<String, dynamic> parsedRes = _parseGQLResponse(response);

      if (parsedRes['error'] != null) {
        return {'error': parsedRes['error']};
      }

      user = User.fromJson(parsedRes['login']);
    } catch (e) {
      return {'error': e.toString()};
    }

    return {"user": user?.id};
  }

  Future<Map<String, String>> createUser(
      String name, String email, String password) async {
    Map<String, dynamic> variables = {
      'name': name,
      'email': email,
      'password': password,
    };

    User user;
    try {
      final http.Response response =
          await runQuery(mutations.signUp, cookie, variables: variables);
      final Map<String, dynamic> parsedRes = _parseGQLResponse(response);

      if (parsedRes['error'] != null) {
        return {'error': parsedRes['error']};
      }

      user = User.fromJson(parsedRes['signUp']);
    } catch (e) {
      return {'error': e.toString()};
    }

    return {"user": user?.id};
  }

  Future<Map<String, String>> currentUser() async {
    User user;
    String cookieString = await getMobileCookie();
    if (cookieString != null) {
      cookie = cookieString;
    }
    try {
      final http.Response response =
          await runQuery(queries.currentUser, cookie);
      final Map<String, dynamic> parsedRes = _parseGQLResponse(response);

      if (parsedRes['error'] != null) {
        return {'error': parsedRes['error']};
      }

      user = User.fromJson(parsedRes['me']);
    } catch (e) {
      return {"error": "Could not retrieve data: $e"};
    }
    return {"user": user?.id};
  }

  Future<void> logout() async {
    try {
      final http.Response response = await runQuery(mutations.logout, cookie);
      if (response.statusCode != 200) {
        throw http.ClientException("error in logging out");
      }
      final Map<String, dynamic> parsedRes = _parseGQLResponse(response);
      if (parsedRes['logout'] == true) {
        // Successfully logged out from graphQL
      }
      setMobileCookie(null);
      // clear cookie from header even if not successfully logged out of gQL
      cookie = null;
      return;
    } catch (e) {
      print(e);
    }
  }

  // Parse response from server
  Map<String, dynamic> _parseGQLResponse(http.Response response) {
    final int statusCode = response.statusCode;
    final String reasonPhrase = response.reasonPhrase;

    // Get cookie sent from server if exists
    try {
      String cookieString = response.headers['set-cookie'];
      if (cookieString != null) {
        cookie = cookieString.split(';')[0];
        setMobileCookie(cookie);
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
      var errorMessage = jsonResponse['errors'][0];
      if (errorMessage['message'] != null) {
        return {'error': errorMessage['message']};
      } else {
        throw Exception(
          'Error returned by the GQL server in the query: \n${jsonResponse['errors'][0]}',
        );
      }
    }

    return jsonResponse['data'];
  }
}
