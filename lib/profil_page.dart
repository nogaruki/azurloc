import 'package:azurloc/gestion_page.dart';
import 'package:azurloc/models/history_model.dart';
import 'package:flutter/material.dart';
import 'package:azurloc/services/user_service.dart';
import 'package:azurloc/services/auth_service.dart';
import 'package:intl/intl.dart';

import 'login_page.dart';
import 'models/user_model.dart'; // Assurez-vous que le chemin vers votre modèle User est correct

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late User _user;
  late List<History> _histories = [];
  bool _isLoading = true;
  bool _isAdmin = false;
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    _user = await _userService.getInfo();
    _isAdmin = _user.roles.keys.contains('Admin') ? true : false;
    _histories = await _userService.getHistory();
    setState(() => _isLoading = false);
  }
  void _showEditProfileDialog() {
    TextEditingController lastnameController = TextEditingController(text: _user.lastname);
    TextEditingController firstnameController = TextEditingController(text: _user.firstname);
    TextEditingController emailController = TextEditingController(text: _user.email);
    TextEditingController cityController = TextEditingController(text: _user.city);
    TextEditingController addressController = TextEditingController(text: _user.address);

    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
        builder: (context) => AlertDialog(
          title: const Text("Modifier votre profile"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: lastnameController,
                    decoration: const InputDecoration(labelText: "Nom"),
                    validator: (value) => value == null || value.isEmpty ? "Ce champ est obligatoire" : null,
                  ),
                  TextFormField(
                    controller: firstnameController,
                    decoration: const InputDecoration(labelText: "Prénom"),
                    validator: (value) => value == null || value.isEmpty ? "Ce champ est obligatoire" : null,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (value) => value == null || value.isEmpty ? "Ce champ est obligatoire" : null,
                  ),
                  TextFormField(
                    controller: cityController,
                    decoration: const InputDecoration(labelText: "Ville"),
                    validator: (value) => value == null || value.isEmpty ? "Ce champ est obligatoire" : null,
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: "Adresse"),
                    validator: (value) => value == null || value.isEmpty ? "Ce champ est obligatoire" : null,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Enregistrer'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  User updatedUser = User(
                    id: _user.id,
                    lastname: lastnameController.text,
                    firstname: firstnameController.text,
                    username: _user.username,
                    email: emailController.text,
                    password: _user.password,
                    city: cityController.text,
                    address: addressController.text,
                    emailVerified: _user.emailVerified,
                    verificationToken: _user.verificationToken,
                    expireToken: _user.expireToken,
                    refreshToken: _user.refreshToken,
                    roles: _user.roles,
                    cart: _user.cart,
                    createdAt: _user.createdAt,
                    updatedAt: _user.updatedAt,
                  );

                  bool success = await _userService.edit(updatedUser);
                  if (success) {
                    setState(() {
                      _user = updatedUser;
                    });
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditProfileDialog,
          ),
        ],
        title: const Text('Profil'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfo(),
              const SizedBox(height: 20),
              _buildActions(),
              const SizedBox(height: 20),
              _buildOrderHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text('Nom:\n ${_user.lastname}', style: const TextStyle(fontSize: 16)),
            ),
            Expanded(
              child: Text('Prénom:\n ${_user.firstname}', style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text('Username:\n ${_user.username}', style: const TextStyle(fontSize: 16)),
            ),
            Expanded(
              child: Text('Email:\n ${_user.email}', style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text('Adresse:\n ${_user.address}', style: const TextStyle(fontSize: 16)),
            ),
            Expanded(
              child: Text('Ville:\n ${_user.city}', style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _authService.logout();
              // Naviguez vers la page de connexion
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Déconnexion', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 20),
          if (_isAdmin)
            ElevatedButton(
              onPressed: () {
                // Naviguez vers la page de gestion
                Navigator.push(context, MaterialPageRoute(builder: (context) => const GestionPage()));
              },
              child: const Text('Gestion'),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historique de commande',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _histories.length,
                itemBuilder: (context, index) {
                  final order = _histories[index];
                  return ListTile(
                    title: Text("Commande du ${DateFormat('dd/MM/yyyy').format(order.createdAt)}"),
                    subtitle: Text('${order.activities.length} activités - Total : ${order.total}€'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        _showOrderDetails(order);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void  _showOrderDetails(History order) {
    print(order.activities);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Détail de la commande du ${DateFormat('dd/MM/yyyy').format(order.createdAt)}"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Total: ${order.total}€', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('Activités:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Column(
                children: order.activities.map((activity) {
                  return ListTile(
                    leading: Image.network(activity.image),
                    title: Text(activity.title),
                    subtitle: Text('${activity.place} - ${activity.price}€'),
                  );
                }).toList(),
              ),
            ],
          ),// Ajoutez les détails de la commande ici
        ),
      ),
    );

  }

}
