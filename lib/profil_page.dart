import 'package:azurloc/gestion_page.dart';
import 'package:azurloc/models/history_model.dart';
import 'package:flutter/material.dart';
import 'package:azurloc/services/user_service.dart';
import 'package:azurloc/services/auth_service.dart';
import 'package:intl/intl.dart';

import 'models/user_model.dart'; // Assurez-vous que le chemin vers votre modèle User est correct

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  final _userService = UserService();
  final AuthService _authService = AuthService();
  final List<History> _history = [];

  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;
  late User _user;

  @override
  void initState() {
    super.initState();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _cityController = TextEditingController();
    _addressController = TextEditingController();
    _userService.getInfo().then((user) {
      if(user != null) {
        setState(() {
          _user = user;
          _firstnameController.text = _user.firstname;
          _lastnameController.text = _user.lastname;
          _usernameController.text = _user.username;
          _emailController.text = _user.email;
          _cityController.text = _user.city;
          _addressController.text = _user.address;
        });

      }
      _userService.getHistory().then((value) {
        setState(() {
          _history.addAll(value);
        });
      });
    });
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      bool updateSuccess = await _userService.edit(_user);
      if (updateSuccess) {
        setState(() {
          _isEditing = false;
          _firstnameController.text = _user.firstname;
          _lastnameController.text = _user.lastname;
          _emailController.text = _user.email;
          _cityController.text = _user.city;
          _addressController.text = _user.address;
        });
      } else {
        print("Échec de la mise à jour de l'utilisateur.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
            ),
          FutureBuilder<User?>(
            future: _userService.getInfo(), 
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return IconButton(
                  icon: Icon(_isEditing ? Icons.cancel : Icons.edit),
                  onPressed: _toggleEditMode,
                );
              } else {
                // Retourne un Container vide si aucune donnée utilisateur n'est chargée ou si les données sont nulles
                return Container();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<User?>(
        future: _userService.getInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement'));
          } else if (snapshot.data != null) {
            User user = snapshot.data!;
            // Ici, user est non-null.
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: buildUserProfileForm(user),
                    ),
                    buildHistorySection(), // Ajoutez cette ligne pour afficher l'historique de commande
                  ],
                ),
              ),
            );
          } else {
            // Cas où user est null
            return const Center(child: Text('Aucune donnée utilisateur disponible'));
          }
        },
      ),
    );
  }

  Widget buildUserProfileForm(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _firstnameController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                readOnly: !_isEditing,
                onChanged: (value) {
                  _firstnameController.text = value;
                },
              ),
            ),
            const SizedBox(width: 10), // Espacement entre les champs
            Expanded(
              child: TextFormField(
                controller: _firstnameController,
                decoration: const InputDecoration(labelText: 'Nom'),
                readOnly: !_isEditing,
                onChanged: (value) {
                  _lastnameController.text = value;
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                readOnly: true, // Le username est souvent en lecture seule
              ),
            ),
            const SizedBox(width: 10), // Espacement entre les champs
            Expanded(
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                readOnly: !_isEditing,
                onChanged: (value) {
                  _emailController.text = value;
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Ville'),
                readOnly: !_isEditing,
                onChanged: (value) {
                  _cityController.text = value;
                },
              ),
            ),
            const SizedBox(width: 10), // Espacement entre les champs
            Expanded(
              child: TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Adresse'),
                readOnly: !_isEditing,
                onChanged: (value) {
                  _addressController.text = value;
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center( // Centre le bouton horizontalement
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Couleur du bouton
              ),
              onPressed: () async {
                final bool result = await _authService.logout(); // Appel à la fonction de déconnexion
                if (result) {
                  Navigator.of(context).pushReplacementNamed('/'); // Redirigez vers la page de connexion
                } else {
                  const snackBar = SnackBar(content: Text('Échec de la déconnexion.'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: const Text('Déconnexion', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        if (user.roles.containsKey("Admin"))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center( // Centre le bouton horizontalement
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GestionPage()));
                },
                child: const Text('Gestion'),
              ),
            ),
          ),
      ],
    );
  }

  // Ajout de la section Historique de commande
  Widget buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'Historique de commande',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _history.isEmpty
            ? const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text('Aucun historique disponible.'),
        )
            : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _history.length,
          itemBuilder: (context, index) {
            final historyItem = _history[index];
            return Card(
              child: ListTile(
                title: Text("Commande du ${DateFormat('dd/MM/yyyy').format(historyItem.createdAt)}"),
                subtitle: Text('${historyItem.activities.length} activités - Total : ${historyItem.total}€'),
                onTap: () {
                  _showActivitiesDialog(historyItem);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void _showActivitiesDialog(History historyItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Détail de la commande"),
          content: SingleChildScrollView(
            child: Container(
              // Définissez une hauteur maximale pour le container
              height: MediaQuery.of(context).size.height * 0.4, // par exemple, 40% de la hauteur de l'écran
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true, // Important pour s'assurer que la ListView prend seulement l'espace nécessaire
                itemCount: historyItem.activities.length,
                itemBuilder: (BuildContext context, int index) {
                  final activity = historyItem.activities[index];
                  return ListTile(
                    title: Text(activity.title),
                    subtitle: Text('Place: ${activity.place}\nPrix: ${activity.price}€\nDescription: ${activity.description}\n-------------------'),
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Text('Total : ${historyItem.total}€', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(
              child: Text("Fermer"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}
