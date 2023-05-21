import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/services/network-controller.service.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;

  late String _enteredName;
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  final networkControllerService = NetworkControllerService();

  @override
  void initState() {
    super.initState();
  }

  void _setItemInFirebase() async {
    final response = await networkControllerService.addGroceryItem(
      name: _enteredName,
      quantity: _enteredQuantity,
      category: _selectedCategory.title,
    );

    final Map<String, dynamic> decodedResponse = json.decode(response.body);
    _isSending = false;

    if (context.mounted) {
      Navigator.of(context).pop(
        GroceryItem(
            id: decodedResponse['name'],
            name: _enteredName,
            quantity: _enteredQuantity,
            category: _selectedCategory),
      );
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      _setItemInFirebase();
    }
  }

  void _reset() {
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Name')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1) {
                    return 'Must be between 1-50 chars';
                  }
                  return null; // null means no error;
                },
                onSaved: (newValue) => _enteredName = newValue!,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(label: Text('Quantity')),
                        initialValue: _enteredQuantity.toString(),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be between 1-50 chars';
                          }
                          return null; // null means no error;
                        },
                        onSaved: (newValue) =>
                            _enteredQuantity = int.parse(newValue!)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    color: category.value.color,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(category.value.title)
                                ],
                              ))
                      ],
                      onChanged: (value) => _selectedCategory = value!,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: _isSending ? null : _reset,
                      child: const Text('Reset')),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem,
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator())
                        : const Text('Add Item'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
