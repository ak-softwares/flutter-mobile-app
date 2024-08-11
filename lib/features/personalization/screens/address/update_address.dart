import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/data/state_iso_code_map.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/address_controller.dart';
import '../../models/address_model.dart';
import '../change_profile/change_profile.dart';

class UpdateAddressScreen extends StatelessWidget {
  const UpdateAddressScreen({super.key, this.title = "Update Address", required this.address, this.isShippingAddress = false});

  final String title;
  final AddressModel address;
  final bool isShippingAddress;

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    controller.firstName.text = address.firstName!;
    controller.lastName.text = address.lastName!;
    controller.address1.text = address.address1!;
    controller.address2.text = address.address2!;
    controller.city.text = address.city!;
    controller.pincode.text = address.pincode!;
    controller.state.text = address.state!;
    controller.country.text = address.country!;

    return Scaffold(
      appBar: TAppBar2(titleText: title, showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: controller.addressFormKey,
            child: Column(
              children: [
                //Name
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                          controller: controller.firstName,
                          validator: (value) => TValidator.validateEmptyText('First Name', value),
                          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'First Name*'),
                        )
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputFields),
                    //Pincode
                    Expanded(
                        child: TextFormField(
                            controller: controller.lastName,
                            decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user4), labelText: 'Last name')
                        )
                    ),
                  ],
                ),
                //Address1
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                    controller: controller.address1,
                    validator: (value) => TValidator.validateEmptyText('Street address', value),
                    decoration: const InputDecoration(prefixIcon: Icon(Iconsax.building), labelText: 'Street Address*')
                ),

                //Address2
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                    controller: controller.address2,
                    decoration: const InputDecoration(prefixIcon: Icon(Iconsax.buildings), labelText: 'Land Mark')
                ),

                //City
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                          controller: controller.city,
                          validator: (value) => TValidator.validateEmptyText('City', value),
                          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.building), labelText: 'City*'),
                        )
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputFields),
                    //Pincode
                    Expanded(
                        child: TextFormField(
                          controller: controller.pincode,
                          validator: (value) => TValidator.validatePinCode(value),
                          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.code), labelText: 'Pincode*')
                        )
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  items: StateData.indianStates.map((state) {
                    return DropdownMenuItem<String>(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  value: controller.state.text.isNotEmpty ? controller.state.text : null,
                  onChanged: (value) {controller.state.text = value!;},
                  validator: (value) => TValidator.validateEmptyText('State', value),
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.activity), labelText: 'State*'),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                    enabled: false,
                    controller: controller.country,
                    decoration: const InputDecoration(prefixIcon: Icon(Iconsax.buildings), labelText: 'Country*')
                ),
                // DropdownButtonFormField<String>(
                //   isExpanded: true,
                //   items: CountryData.countries.map((country) {
                //     return DropdownMenuItem<String>(
                //       value: country,
                //       child: Text(country),
                //     );
                //   }).toList(),
                //   value: controller.country.text,
                //   onChanged: (value) {controller.country.text = value!;},
                //   validator: (value) => TValidator.validateEmptyText('Country', value),
                //   decoration: const InputDecoration(prefixIcon: Icon(Iconsax.global), labelText: 'Country*'),
                // ),

                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('To Edit Phone and Email', style: Theme.of(context).textTheme.labelLarge),
                      TextButton(
                          onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeProfile()));},
                          child: Text('Click here', style: Theme.of(context).textTheme.labelLarge!.copyWith(color: TColors.linkColor)))
                    ]
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () => controller.wooUpdateAddress(isShippingAddress),
                        child: const Text('Update Address')
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
