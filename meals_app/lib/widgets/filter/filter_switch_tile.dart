import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/filter.dart';
import '../../providers/filters_provider.dart';

class FilterSwitchTileWidget extends ConsumerWidget {
  const FilterSwitchTileWidget(this.filter, {super.key});
  
  final Filter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(filtersProvider);
    return SwitchListTile(
        title: Text(
          filterToString(filter),
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        subtitle: Text(
          'Only include ${filterToString(filter).toLowerCase()} meals',
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        activeColor: Theme.of(context).colorScheme.tertiary,
        contentPadding: const EdgeInsets.only(left: 34, right: 22),
        value: activeFilters[filter]!,
        onChanged: (isChecked) {
          ref.read(filtersProvider.notifier).setFilter(filter, isChecked);
        });
  }
}
