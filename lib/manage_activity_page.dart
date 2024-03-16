import 'package:azurloc/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:azurloc/models/activity_model.dart';
import 'package:azurloc/services/category_service.dart';
import 'package:azurloc/services/activity_service.dart';
import 'package:intl/intl.dart';
import 'activity_detail_page.dart';
// Importez vos modèles et services ici

class ActivityListPage extends StatefulWidget {
  const ActivityListPage({super.key});

  @override
  _ActivityListPageState createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  List<Activity> activities = []; // Remplacez Activity par votre modèle d'activité
  final CategoryService _categoryService = CategoryService();
  final ActivityService _activityService = ActivityService();
  List<Category> categories = []; // Remplacez Category par votre modèle de catégorie
  @override
  void initState() {
    super.initState();
    _loadActivities();

  }

  void _loadActivities() async {
    categories = await _categoryService.getAll();
    activities = await _activityService.getAll();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Date initiale sélectionnée
      firstDate: DateTime(2024), // Première date disponible
      lastDate: DateTime(2030), // Dernière date disponible
    );
    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked); // Formatez la date en String
      controller.text = formattedDate; // Mettez à jour le contrôleur de texte avec la date formatée
    }
  }

  void _addActivity() {
    // Création des contrôleurs de texte
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController dateController = TextEditingController(); // Utiliser un format de date approprié
    TextEditingController priceController = TextEditingController();
    TextEditingController placeController = TextEditingController();
    TextEditingController minPeopleController = TextEditingController();
    String? selectedCategory ; // Catégorie sélectionnée
    TextEditingController imageController = TextEditingController();

    // Création du GlobalKey pour le Form
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter une nouvelle activité"),
        content: SingleChildScrollView(
          child: Form(
            key: formKey, // Utilisation du FormKey ici
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: "Titre de l'activité"),
                  validator: (value) => value == null || value.isEmpty ? "Ce champ est obligatoire" : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(hintText: "Description"),
                  validator: (value) => value == null || value.isEmpty ? "Ce champ est obligatoire" : null,
                ),
              GestureDetector(
                onTap: () => _selectDate(context, dateController),
                child: AbsorbPointer( // Empêche le clavier de s'afficher
                  child: TextFormField(
                    controller: dateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Date (YYYY-MM-DD)",
                      labelText: "Date",
                    ),
                    validator: (value) {
                      final dateNow = DateTime.now();
                      if (value == null || value.isEmpty) {
                        return "Ce champ est obligatoire";
                      } else if (DateTime.parse(value).isBefore(dateNow)) {
                        return "La date ne peut pas être dans le passé";
                      }
                      return null;
                    },
                  ),
                ),
              ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(hintText: "Prix"),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ce champ est obligatoire";
                    }
                    final number = num.tryParse(value);
                    if (number == null) {
                      return "Veuillez entrer un nombre valide";
                    }
                    if (number <= 0) {
                      return "Le prix doit être supérieur à 0";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: placeController,
                  decoration: const InputDecoration(hintText: "Lieu"),
                  validator: (value) => value == null || value.isEmpty ? "Ce champ est obligatoire" : null,
                ),
                TextFormField(
                  controller: minPeopleController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Nombre minimum de personnes"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ce champ est obligatoire";
                    }
                    final number = int.tryParse(value);
                    if (number == null) {
                      return "Veuillez entrer un nombre entier valide";
                    }
                    if (number <= 0) {
                      return "Le nombre de personnes doit être supérieur à 0";
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: "Catégorie"),
                  items: categories.map((Category category) {
                    return DropdownMenuItem<String>(
                      value: category.id, // Assumer que Category a un attribut id
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (newValue) => selectedCategory = newValue,
                  validator: (value) => value == null ? "Ce champ est obligatoire" : null,
                ),
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(hintText: "URL de l'image"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ce champ est obligatoire";
                    }
                    // Expression régulière pour valider une URL
                    const urlPattern = r'(http|https):\/\/([\w-]+(\.[\w-]+)+)([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])';
                    final urlRegex = RegExp(urlPattern);
                    if (!urlRegex.hasMatch(value)) {
                      return "Veuillez entrer une URL valide";
                    }
                    return null;
                  },
                ),

              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                bool success = await _activityService.add(Activity(
                  id: '', // L'ID sera généralement généré par le backend
                  title: titleController.text,
                  description: descriptionController.text,
                  date: DateTime.parse(dateController.text),
                  price: double.parse(priceController.text),
                  place: placeController.text,
                  minPeople: int.parse(minPeopleController.text),
                  category: selectedCategory!,
                  image: imageController.text,
                ));
                if (success) {
                  setState(() {
                    _loadActivities();
                  });
                }
                Navigator.of(context).pop(); // Fermez la boîte de dialogue
              }
            },
            child: const Text('Ajouter'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _viewDetails(Activity activity) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ActivityDetailPage(activity: activity),
      ),
    );
  }

  void _editActivity(Activity activity) {
    // Initialisation des contrôleurs de texte et de la catégorie sélectionnée
    TextEditingController titleController = TextEditingController(text: activity.title);
    TextEditingController descriptionController = TextEditingController(text: activity.description);
    TextEditingController dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(activity.date));
    TextEditingController priceController = TextEditingController(text: activity.price.toString());
    TextEditingController placeController = TextEditingController(text: activity.place);
    TextEditingController minPeopleController = TextEditingController(text: activity.minPeople.toString());
    String? selectedCategory = activity.category; // Supposons que cela stocke l'ID de la catégorie
    TextEditingController imageController = TextEditingController(text: activity.image);

    // Création du GlobalKey pour le Form
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifier l'activité"),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Titre de l'activité"),
                  validator: (value) => value == null || value.isEmpty ? "Ce champ est obligatoire" : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description de l'activité"),
                  validator: (value) => value == null || value.isEmpty ? "Ce champ est obligatoire" : null,
                ),
                GestureDetector(
                  onTap: () => _selectDate(context, dateController),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: dateController,
                      decoration: const InputDecoration(labelText: "Date"),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Ce champ est obligatoire";
                        return null;
                      },
                    ),
                  ),
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: "Prix"),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => value != null && value.isNotEmpty && double.tryParse(value) == null ? "Entrez un nombre valide" : null,
                ),
                TextFormField(
                  controller: placeController,
                  decoration: const InputDecoration(labelText: "Lieu"),
                  validator: (value) => value == null || value.isEmpty ? "Ce champ est obligatoire" : null,
                ),
                TextFormField(
                  controller: minPeopleController,
                  decoration: const InputDecoration(labelText: "Nombre minimum de personnes"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value != null && value.isNotEmpty && int.tryParse(value) == null ? "Entrez un nombre entier" : null,
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: "Catégorie"),
                  onChanged: (newValue) => selectedCategory = newValue,
                  items: categories.map<DropdownMenuItem<String>>((Category category) {
                    return DropdownMenuItem<String>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  validator: (value) => value == null ? "Ce champ est obligatoire" : null,
                ),
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: "URL de l'image"),
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
                Activity updatedActivity = Activity(
                  id: activity.id,
                  title: titleController.text,
                  description: descriptionController.text,
                  date: DateTime.parse(dateController.text),
                  price: double.parse(priceController.text),
                  place: placeController.text,
                  minPeople: int.parse(minPeopleController.text),
                  category: selectedCategory!,
                  image: imageController.text,
                );

                bool success = await _activityService.edit(updatedActivity);
                if (success) {
                  setState(() {
                    _loadActivities();
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

  void _deleteActivity(String activityId) {
    // Affiche une boîte de dialogue de confirmation avant de supprimer
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text('Êtes-vous sûr de vouloir supprimer cette activité ? Cette action est irréversible.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue sans supprimer
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                bool success = await _activityService.delete(activityId);
                if (success) {
                  setState(() {
                    _loadActivities();
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showAddActivityDialog(BuildContext context) async {
    if (categories.isEmpty) {
      // S'il n'y a pas de catégories, montrez une alerte
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Aucune catégorie disponible"),
          content: const Text("Veuillez créer une catégorie avant d'ajouter une activité."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermez la boîte de dialogue
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      _addActivity();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Gestion des activités',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddActivityDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Activity>>(
        future: _activityService.getAll(), // Assurez-vous que cette méthode retourne un Future<List<Activity>>
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Une erreur est survenue"));
          } else if (snapshot.hasData) {
            final activities = snapshot.data ?? [];
            return ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      activity.image,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('', width: 50, height: 50);
                      },
                    ),
                    title: Text(activity.title),
                    subtitle: Text("Date: ${DateFormat('dd-MM-yyyy').format(activity.date)} \nCatégorie: ${activity.categoryObject?.name ?? activity.category} \nPrix: ${activity.price}€"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () => _viewDetails(activity),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editActivity(activity),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteActivity(activity.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Aucune activité disponible"));
          }
        },
      ),
    );
  }

}
