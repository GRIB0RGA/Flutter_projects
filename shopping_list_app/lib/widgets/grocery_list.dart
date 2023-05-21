import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/services/network-controller.service.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryList = [];
  bool _isLoading = true;
  String? _error;

  final networkControllerService = NetworkControllerService();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    try {
      final response = await networkControllerService.getGroceries();
      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please try again';
        });
        return;
      }
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);

      final List<GroceryItem> loadedItems = [];

      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (element) => element.value.title == item.value['category'])
            .value;
        loadedItems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ));

        setState(() {
          _groceryList = loadedItems;
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _error = 'Failed to fetch groceries';
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const NewItem()));

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryList.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) {
    networkControllerService.deleteGroceryItem(item.id);
    setState(() {
      _groceryList.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent = const Center(child: CircularProgressIndicator());

    if (_isLoading) {
      bodyContent = const Center(child: CircularProgressIndicator());
    }
    if (!_isLoading && _groceryList.isEmpty) {
      bodyContent = const Center(child: Text('No items added yet'));
    }

    if (!_isLoading && _groceryList.isNotEmpty) {
      bodyContent = ListView.builder(
        itemCount: _groceryList.length,
        itemBuilder: (context, index) => Dismissible(
          key: ValueKey(_groceryList[index].id),
          onDismissed: (direction) => {_removeItem(_groceryList[index])},
          child: ListTile(
            title: Text(_groceryList[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryList[index].category.color,
            ),
            trailing: Text(_groceryList[index].quantity.toString()),
          ),
        ),
      );
    }

    if (_error != null) {
      bodyContent = Center(child: Text(_error!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: bodyContent,
    );
  }
}
