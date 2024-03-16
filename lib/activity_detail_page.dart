import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:azurloc/models/activity_model.dart'; // Assurez-vous que le chemin est correct
import 'package:azurloc/services/user_service.dart'; // Assurez-vous que le chemin est correct

class ActivityDetailPage extends StatefulWidget {
  final Activity activity;

  const ActivityDetailPage({super.key, required this.activity});

  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  final _userService = UserService();

  @override
  void initState() {
    super.initState();

  }

  void _addToCart() {
    if (kDebugMode) {
      print('Ajout de ${widget.activity.title} au panier');
    }
    _userService.addToCart(widget.activity).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Activité ajoutée au panier'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de l\'ajout au panier'),
          ),
        );
      }
    });
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.network(widget.activity.image),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.activity.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Text('Catégorie: ${widget.activity.categoryObject?.name ?? widget.activity.category}'),
            Text('Lieu: ${widget.activity.place}'),
            Text('Nombre de personnes minimum: ${widget.activity.minPeople}'),
            Text('Prix: ${widget.activity.price}€'),
            ElevatedButton(
              onPressed: _addToCart,
              child: const Text('Ajouter au panier'),
            ),
          ],
        ),
      ),
    );
  }
}
