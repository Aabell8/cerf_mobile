import 'dart:async';
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

  Future<String> loginWithEmailAndPassword(
      String email, String password) async {
    String url = "http://localhost:5000/graphql";
    final Client client = Client(
      endPoint: url,
      cache: InMemoryCache(),
    );

    Map<String, dynamic> variables = {
      'email': email,
      'password': password,
    };

    Map<String, dynamic> result;
    try {
      result =
          await client.query(query: mutations.login, variables: variables);
          print(result);
      result = result['login'];
    } catch (e) {
      print("Error in logging in: $e");
      return "invalid login";
    }
    if (result != null) {
      return result['id'];
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
}
