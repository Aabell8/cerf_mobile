import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// const String GRAPHQL_URL = "https://viss-mobile.herokuapp.com/graphql";
const String GRAPHQL_URL = "http://10.0.2.2:5000/graphql";
const String storageCookieKey = "graphql_cookie";

Future<http.Response> runQuery(String query, String cookie,
    {Map<String, dynamic> variables}) {
  http.Client client = http.Client();
  final String body = json.encode({
    'query': query,
    'variables': variables,
  });

  Map<String, String> headers = {
    'Cookie': '$cookie',
    'Content-Type': 'application/json',
  };

  return client.post(
    GRAPHQL_URL,
    headers: headers,
    body: body,
  );
}

Future<String> getMobileCookie() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;

  String _cookieString = prefs.getString(storageCookieKey);

  return _cookieString ?? '';
}

Future<bool> setMobileCookie(String token) async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  return prefs.setString(storageCookieKey, token);
}
