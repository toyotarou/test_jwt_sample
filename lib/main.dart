import 'package:flutter/material.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

///
void main() {
  runApp(const MyApp());
}

///
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: JwtExample());
}

///
class JwtExample extends StatefulWidget {
  const JwtExample({super.key});

  @override
  State<JwtExample> createState() => _JwtExampleState();
}

class _JwtExampleState extends State<JwtExample> {
  String _token = '';
  String _decodedToken = '';

  final String secretKey = 'your_secret_key';

  ///
  void createJwt() {
    final jwt = JWT(
      {
        'userId': 123,
        'username': 'example_user',
        'exp': (DateTime.now().millisecondsSinceEpoch / 1000).round() + 3600,
      },
    );

    final token =
        jwt.sign(SecretKey(secretKey), expiresIn: const Duration(hours: 1));

    setState(() => _token = token);
  }

  ///
  void verifyJwt() {
    try {
      final jwt = JWT.verify(_token, SecretKey(secretKey));

      setState(() => _decodedToken = jwt.payload.toString());
    } on JWTExpiredException {
      setState(() => _decodedToken = 'Token has expired');
    } on JWTException catch (ex) {
      setState(() => _decodedToken = 'Invalid token: $ex');
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JWT Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ///
            ElevatedButton(
                onPressed: createJwt, child: const Text('Create JWT')),
            const SizedBox(height: 8),
            Text('JWT: $_token'),

            ///
            const SizedBox(height: 16),

            ///
            ElevatedButton(
                onPressed: verifyJwt, child: const Text('Verify JWT')),
            const SizedBox(height: 8),
            Text('Decoded JWT: $_decodedToken'),

            ///
          ],
        ),
      ),
    );
  }
}
