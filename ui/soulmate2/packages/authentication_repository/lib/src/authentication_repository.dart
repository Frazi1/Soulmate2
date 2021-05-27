import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import 'package:equatable/equatable.dart';

class AuthenticationResult extends Equatable {
  AuthenticationResult(this.status, {this.description});

  final AuthenticationStatus status;
  final String? description;

  @override
  List<Object?> get props => [status, description];
}
enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  // static const serverUrl = "http://localhost:5000/api/auth";
  // static const serverUrl = "http://10.0.2.2:5000/api/";
  static const serverUrl = "http://192.168.0.25:5000/api/";

  final _controller = StreamController<AuthenticationResult>.broadcast();

  Stream<AuthenticationResult> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationResult(AuthenticationStatus.unauthenticated);
    yield* _controller.stream;
  }

  Future<void> logIn(String username, String password) async {
    String body = json.jsonEncode({'username': username, 'password': password});
    try {
      var response = await http.post(Uri.parse(serverUrl+'auth/login'),
          headers: {'content-type':"application/json"},
          body: body);
      if (response.statusCode == 200) {
        // var jsonBody = json.jsonDecode(response.body);
        _controller.add(AuthenticationResult(AuthenticationStatus.authenticated));
      } else {
        _controller.add(AuthenticationResult(AuthenticationStatus.unauthenticated, description: "Non-success code: ${response.statusCode}"));
      }
    } catch(e) {
      print(e);
      _controller.add(AuthenticationResult(AuthenticationStatus.unauthenticated, description: e.toString()));
    }
  }

  void logOut() {
    _controller.add(AuthenticationResult(AuthenticationStatus.unauthenticated));
  }

  void dispose() => _controller.close();
}
