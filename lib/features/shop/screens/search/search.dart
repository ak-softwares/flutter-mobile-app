import 'package:aramarket/features/shop/screens/home_page_section/scrolling_products/widgets/scrolling_products.dart';
import 'package:aramarket/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import 'widgets/empty_search_screen.dart';
import 'widgets/search_product_screen.dart';

class TSearchDelegate extends SearchDelegate {

  @override
  String? get searchFieldLabel => 'Search Product..';

  // Add this property to customize the search text field style
  @override
  TextStyle? get searchFieldStyle => const TextStyle(
    fontSize: 15, // Customize font size
    fontWeight: FontWeight.w500,
    color: TColors.secondaryColor, // Customize font color
  );


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear, color: Colors.black),
          onPressed: () {
            query = '';
          }
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black,),
        onPressed: () {
          close(context, null);
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // FBAnalytics.logViewSearchResults(searchTerm: query, resultsCount: '');
    return SearchProductScreen(
        title: 'Search result for ${query.isEmpty ? '' : '"$query"'}',
        searchQuery: query,
        orientation: OrientationType.vertical,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty && query.length >= 3) {
      FBAnalytics.logSearch(searchTerm: query); // Log search only when query length is >= 3
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (query.isEmpty) ...[
          const Expanded(child: EmptySearchScreen())
        ],
        if (query.length >= 3) ...[
          Expanded(
            child: SearchProductScreen(
              title: 'Search result for ${query.isEmpty ? '' : '"$query"'}',
              searchQuery: query,
              orientation: OrientationType.horizontal,
            ),
          ),
        ],
      ],
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: TColors.primaryColor,
        // iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        titleTextStyle: theme.textTheme.titleLarge,
        toolbarTextStyle: theme.textTheme.bodyMedium,
      ),
      primaryColor: TColors.primaryColor,
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: Sizes.xs, horizontal: Sizes.md), // Define input field height
            // fillColor: Colors.grey.shade200, // Customize the background color
            // filled: true, // Ensure the fill color is applied
            // hintStyle: const TextStyle(
            //   fontSize: 15, // Customize hint text font size
            //   color: Colors.grey, // Customize hint text color
            // ),

            // enabledBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Colors.blue, // Customize the border color when enabled
            //     width: 2.0, // Customize the border width
            //   ),
            //   borderRadius: BorderRadius.all(Radius.circular(TSizes.sm)), // Optional: Customize the border radius
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Colors.green, // Customize the border color when focused
            //     width: 2.0, // Customize the border width
            //   ),
            //   borderRadius: BorderRadius.all(Radius.circular(TSizes.sm))
            // ),
            // border: const OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Colors.transparent, // Customize the default border color
            //     width: 1.0, // Customize the default border width
            //   ),
            //   borderRadius: BorderRadius.all(Radius.circular(TSizes.sm))
            // ),
          ),
    );
  }

}