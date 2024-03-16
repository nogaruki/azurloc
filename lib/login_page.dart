import 'package:flutter/material.dart';
import 'package:azurloc/register_page.dart';
import 'package:azurloc/services/auth_service.dart';
import 'package:azurloc/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  String _username = '';
  String _password = '';

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _authService.login(_username, _password).then((value) {
        if (value == 'success') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: Text(value),
          ));
        }
      });
    }
  }

  void _navigateToSignUp() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'AzurLoc',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue, // Fond de l'AppBar en bleu
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Login'),
                onSaved: (value) => _username = value!,
                validator: (value) => value!.isEmpty ? 'Entrez votre login' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) => _password = value!,
                validator: (value) => value!.isEmpty ? 'Entrez votre mot de passe' : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligner les boutons aux extrémités
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('Se connecter'),
                    ),
                    ElevatedButton(
                      onPressed: _navigateToSignUp,
                      child: const Text('Créer un compte'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
