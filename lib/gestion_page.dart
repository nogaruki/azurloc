import 'package:flutter/material.dart';
import 'package:azurloc/manage_activity_page.dart'; // Assurez-vous d'avoir créé cette page
import 'package:azurloc/manage_category_page.dart'; // Assurez-vous d'avoir créé cette page

class GestionPage extends StatelessWidget {
  const GestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Gestion des activités et catégories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue, // Fond de l'AppBar en bleu
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Liste Activité'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ActivityListPage()));
              },
            ),
            ElevatedButton(
              child: const Text('Liste Catégorie'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CategoryListPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
