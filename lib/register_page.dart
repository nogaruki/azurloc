import 'package:flutter/material.dart';
import 'package:azurloc/services/auth_service.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _firstname = '';
  String _lastname = '';
  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _city = '';
  String _address = '';
  final AuthService _authService = AuthService();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Ceci appelle onSaved pour chaque TextFormField

      if(_password.length < 8) {
        const snackBar = SnackBar(content: Text('Le mot de passe doit contenir au moins 8 caractères.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      if (_password != _confirmPassword) {
        const snackBar = SnackBar(content: Text('Les mots de passe ne correspondent pas.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      String result = await _authService.register(
        firstname: _firstname,
        lastname: _lastname,
        username: _username,
        email: _email,
        password: _password,
        confirmPassword: _confirmPassword,
        city: _city,
        address: _address,
      );

      if (result == 'success') {
        const snackBar = SnackBar(content: Text('Inscription validée, veuillez vérifier votre email pour activer votre compte.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(content: Text('Erreur: $result'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Inscription',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue, // Fond de l'AppBar en bleu
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Prénom'),
                  onSaved: (value) => _firstname = value!,
                  validator: (value) => value!.isEmpty ? 'Entrez votre prénom' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nom'),
                  onSaved: (value) => _lastname = value!,
                  validator: (value) => value!.isEmpty ? 'Entrez votre nom' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
                  onSaved: (value) => _username = value!,
                  validator: (value) => value!.isEmpty ? 'Entrez votre nom d\'utilisateur' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  onSaved: (value) => _email = value!,
                  validator: (value) => value!.isEmpty ? 'Entrez votre email' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  obscureText: true, // Masque le mot de passe
                  onSaved: (value) => _password = value!,
                  validator: (value) => value!.isEmpty ? 'Entrez votre mot de passe' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Confirmer Mot de passe'),
                  obscureText: true, // Masque le mot de passe
                  onSaved: (value) => _confirmPassword = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Confirmez votre mot de passe';
                    }
                    return null; // Si tout va bien, on renvoie null
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Ville'),
                  onSaved: (value) => _city = value!,
                  validator: (value) => value!.isEmpty ? 'Entrez votre ville' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Adresse'),
                  onSaved: (value) => _address = value!,
                  validator: (value) => value!.isEmpty ? 'Entrez votre adresse' : null,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    onPressed: _register,
                    child: const Text('S\'inscrire'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
