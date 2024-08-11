
import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';
class TSectionHeading extends StatelessWidget {
  const TSectionHeading({
    super.key,
    this.seeActionButton = false,
    required this.title,
    this.buttonTitle = 'View all',
    this.onPressed,
    this.verticalPadding = true,
  });

  final bool seeActionButton, verticalPadding;
  final String title, buttonTitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    List<String> titleParts = title.split(',');

    return Container(
      padding: verticalPadding ? const EdgeInsets.symmetric(vertical: TSizes.sm) : const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RichText(
              maxLines: 1, // Limit the RichText to one line
              overflow: TextOverflow.ellipsis, // Overflow handling
              text: TextSpan(
                children: [
                  TextSpan(
                    text: titleParts[0],
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (titleParts.length > 1) // Check if there's more than one part after splitting
                    TextSpan(
                      text: titleParts[1],
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ),
          ),
          if(seeActionButton)
            InkWell(
                onTap: onPressed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(buttonTitle, style: Theme.of(context).textTheme.bodySmall!,),
                    const Icon(Icons.arrow_right, size: 25, color: Colors.blue),
                  ],
                )
            )
        ],
      ),
    );

  }
}

