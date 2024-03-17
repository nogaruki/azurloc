import 'package:flutter/material.dart';
import 'package:azurloc/services/auth_service.dart';
import 'package:azurloc/cart_page.dart';
import 'package:azurloc/activity_list_pages.dart';
import 'package:azurloc/profil_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // L'index pour la BottomNavigationBar
  final AuthService _authService = AuthService();

  static final List<Widget> _widgetOptions = <Widget>[
    const ActivityList(), // Page des activités
    const CartPage(), // Page du panier
    const ProfilPage(), // Page du profil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() async {
    final bool result = await _authService.logout(); // Appel à la fonction de déconnexion
    if (result) {
      // Si la déconnexion est réussie
      Navigator.of(context).pushReplacementNamed('/'); // Redirigez vers la page de connexion
    } else {
      // Échec de la déconnexion, afficher un message d'erreur
      const snackBar = SnackBar(content: Text('Échec de la déconnexion.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
        backgroundColor: Colors.blue,
        actions: [IconButton(
          icon: const Icon(Icons.logout), // Utilisez l'icône SVG pour le bouton
          onPressed: _logout, // La fonction à appeler lors du clic sur le bouton
        ),
        ],// Fond de l'AppBar en bleu
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // Affiche la page sélectionnée
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Activités',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

