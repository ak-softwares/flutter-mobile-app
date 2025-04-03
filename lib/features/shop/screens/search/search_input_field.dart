import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import 'search.dart';

class TSearchBar extends StatelessWidget {
  const TSearchBar({super.key, this.searchText = "Search"});

  final String? searchText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.sm),
      child: InkWell(
        onTap: () => showSearch(context: context, delegate: TSearchDelegate()),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
          ),
          child: Row(
            children: [
              Icon(Icons.search),
              const SizedBox(width: 20),
              Text(searchText!)
            ],
          ),
        ),
      ),
    );
  }
}
