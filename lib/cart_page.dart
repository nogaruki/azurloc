import 'package:azurloc/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'models/activity_model.dart'; // Assurez-vous que le chemin est correct
import 'package:azurloc/services/user_service.dart'; // Assurez-vous que le chemin est correct

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Activity> cartActivities = []; // La liste des activités dans le panier
  Cart? cart; // Le panier de l'utilisateur
  double total = 0.0; // Le total général des prix des activités dans le panier
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    getCart();
  }

  void getCart() {
    _userService.getUserCart().then((cart) {
      if (cart != null) {
        setState(() {
          this.cart = cart;
          cartActivities = cart.activities;
          calculateTotal();
        });
      }
    });
  }

  void calculateTotal() {
    total = cartActivities.fold(0.0, (sum, item) => sum + item.price);
  }

  void removeFromCart(Activity activity) {
    _userService.removeFromCart(activity.id).then((_) {
      setState(() {
        cartActivities.remove(activity);
        calculateTotal();
      });
    });
  }

  void buy() async {
    if (cart == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le panier est vide.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }


    final bool success = await _userService.buyProcess(cart!);

    if (success) {
      // Traitement réussi, afficher une confirmation ou passer à l'étape suivante.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Achat réussi'),
          content: const Text('Votre achat a été traité avec succès.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(),
                setState(() {
                  cartActivities.clear();
                  total = 0.0;
                }),
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Échec du traitement, afficher un message d'erreur.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Échec de l\'achat'),
          content: const Text('Une erreur est survenue lors du traitement de votre achat.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartActivities.length,
              itemBuilder: (context, index) {
                final activity = cartActivities[index];
                return ListTile(
                  leading: Image.network(activity.image),
                  title: Text(activity.title),
                  subtitle: Text('${activity.place} - ${activity.price}€'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => removeFromCart(activity),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Total général: $total€', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: buy,
              child: const Text('Payer'),
            ),
          ),
        ],
      ),
    );
  }
}
