import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/address_model.dart';

class TSingleAddress extends StatelessWidget {

  const TSingleAddress({
    super.key,
    required this.address,
    required this.onTap,
    this.hidePhone = false,
    this.hideEdit = false,
  });

  final AddressModel address;
  final bool hidePhone;
  final bool hideEdit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            padding: TSpacingStyle.defaultPagePadding,
            child: Stack(
              children: [
                !hideEdit
                  ? const Positioned(
                      right: 5,
                          top: 0,
                          child: Row(
                            spacing: Sizes.sm,
                            children: [
                              Icon(Icons.edit, size: 20, color: TColors.linkColor),
                              Text('Edit', style: TextStyle(color: TColors.linkColor),)
                            ],
                          )
                      )
                  : SizedBox.shrink(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(address.name, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 15), overflow: TextOverflow.ellipsis),
                    hidePhone
                        ? const SizedBox.shrink()
                        : Text(address.formattedPhoneNo, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15), overflow: TextOverflow.ellipsis),
                    hidePhone
                        ? const SizedBox.shrink()
                        : Text(address.email ?? '', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15), overflow: TextOverflow.ellipsis),
                    Text(address.toString(), style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis, maxLines: 4,
                    ),
                    const SizedBox(height: Sizes.sm),
                  ],
                )
              ],
            ),
          ),
        );
  }
}

