import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meals_app/widgets/filter/filter_switch_tile.dart';
import '../models/filter.dart';

class FiltersScreen extends StatelessWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your filters'),
      ),
      body: Column(children: const [
        FilterSwitchTileWidget(Filter.glutenFree),
        FilterSwitchTileWidget(Filter.lactoseFree),
        FilterSwitchTileWidget(Filter.vegetarian),
        FilterSwitchTileWidget(Filter.vegan),
      ]),
    );
  }
}
