import 'package:flutter/material.dart';

import 'models/category_model.dart';
import 'package:azurloc/services/category_service.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  List<Category> categorys = []; // Remplacez Category par votre modèle de catégorie
  final CategoryService _categoryService = CategoryService();
  @override
  void initState() {
    super.initState();
    _loadCategorys();
  }

  void _loadCategorys() async {
    categorys = await _categoryService.getAll();
  }

  void _addCategory() {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter une catégorie"),
        content: Form(
          key: formKey,
          child: Column(
            children : <Widget>[
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom pour la catégorie';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Nom de la catégorie",
                ),
              ),
              TextFormField(
                controller: descriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description pour la catégorie';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Description de la catégorie",
                ),
              ),
            ],
          )
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () async { // Rendre cette fonction asynchrone
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                bool success = await _categoryService.add(Category(
                  name: nameController.text,
                  description: descriptionController.text,
                  activities: [],
                  id: '',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ));


                if (success) {
                  setState(() {
                    _loadCategorys();
                  });

                }
                Navigator.of(context).pop();
              }
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }


  void _editCategory(Category category) {
    TextEditingController nameController = TextEditingController(text: category.name);
    TextEditingController descriptionController = TextEditingController(text: category.description);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifier la catégorie"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom pour la catégorie';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Nom de la catégorie",
                    ),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une description pour la catégorie';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Description de la catégorie",
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Category updatedCategory = Category(
                    id: category.id,
                    name: nameController.text,
                    description: descriptionController.text,
                    activities: category.activities,
                    createdAt: category.createdAt,
                    updatedAt: DateTime.now(),
                  );
                  bool rep = await _categoryService.edit(updatedCategory);
                  if (rep) {
                    setState(() {
                      _loadCategorys();
                    });
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }


  void _deleteCategory(String categoryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Supprimer la catégorie"),
          content: const Text("Êtes-vous sûr de vouloir supprimer cette catégorie ? Cette action est irréversible."),
          actions: [
            TextButton(
              child: const Text("Non"),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue sans supprimer la catégorie
              },
            ),
            TextButton(
              child: const Text("Oui"),
              onPressed: () async {
                bool success = await _categoryService.delete(categoryId);
                if (success) {
                  setState(() {
                    _loadCategorys();
                  });
                }
                Navigator.of(context).pop(); // Ferme la boîte de dialogue après la suppression
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Gestion des catégories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCategory,
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: _categoryService.getAll(), // Ici, nous appelons directement la fonction asynchrone
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erreur de chargement des catégories"));
          } else if (snapshot.hasData) {
            final categorys = snapshot.data!;
            return ListView.builder(
              itemCount: categorys.length,
              itemBuilder: (context, index) {
                final category = categorys[index];
                return Card(
                  child: ListTile(
                    title: Text(category.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editCategory(category),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteCategory(category.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("Aucune catégorie trouvée"));
          }
        },
      ),
    );
  }

}


