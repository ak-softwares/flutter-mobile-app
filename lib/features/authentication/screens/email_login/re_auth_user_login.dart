import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/navigation_bar/app_appbar.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';
import '../../../personalization/controllers/user_controller.dart';

class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('re_auth_login_screen');
    final controller = Get.put(UserController());
    return Scaffold(
      appBar: const AppAppBar(title: "Re-Authentication User", showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                  key: controller.reAuthFormKey,
                  child: Column(
                      children: [
                        //Email
                        TextFormField(
                            controller: controller.verifyEmail,
                            validator: (value) => Validator.validateEmail(value),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.direct_right),
                              labelText: TTexts.email,
                            )
                        ),
                        //Password
                        const SizedBox(height: AppSizes.inputFieldSpace),
                        Obx(
                              () => TextFormField(
                                controller: controller.verifyPassword,
                                validator: (value) => Validator.validateEmptyText('Password', value),
                                obscureText: controller.hidePassword.value,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Iconsax.password_check),
                                    labelText: TTexts.password,
                                    suffixIcon: IconButton(
                                      onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                                      icon: controller.hidePassword.value ? const Icon(Iconsax.eye_slash) : const Icon(Iconsax.eye),
                                    )
                                )
                            )),
                        // Login button
                        const SizedBox(height: AppSizes.spaceBtwSection),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: const Text('Verify'),
                            onPressed: () => controller.reAuthenticateEmailAndPasswordUser(),
                          ),
                        ),
                      ]
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

