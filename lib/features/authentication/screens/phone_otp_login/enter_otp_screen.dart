import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../common/styles/spacing_style.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/navigation_helper.dart';
import '../../controllers/phone_otp_controller/phone_otp_controller.dart';
class EnterOTPScreen extends StatelessWidget {
  const EnterOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('enter_otp_screen');

    final otpController = Get.put(OTPController());
    int seconds  = 60;
    int otpLength = otpController.otpLength;
    double screenWidth = MediaQuery.of(context).size.width;
    double boxWidth = screenWidth * 0.7; // 70% of screen width
    double maxWidthPerDigit = boxWidth / otpLength;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWidthAppbarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100,),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Enter OTP', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: AppSizes.sm),
                Text('Please Enter $otpLength Digit OTP to verify your phone number',
                    style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: AppSizes.spaceBtwItems),

                //Phone number
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(otpController.countryCode.value + otpController.phoneNumber.value,
                        style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center
                    ),
                    const SizedBox(width: AppSizes.spaceBtwItems),
                    InkWell(
                      onTap: () => NavigationHelper.navigateToMobileLogin(),
                      child: Row(
                        children: [
                          Text('Edit',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.linkColor),
                              textAlign: TextAlign.center
                          ),
                          const SizedBox(width: AppSizes.xs),
                          Icon(AppIcons.edit, color: AppColors.linkColor,size: 15,)
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceBtwSection),

                // Otp Input field
                SizedBox(
                  width: boxWidth,
                  child: PinFieldAutoFill(
                    codeLength: otpLength, //code length, default 6
                    textInputAction: TextInputAction.done,
                    decoration: UnderlineDecoration(
                      textStyle: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
                      colorBuilder: FixedColorBuilder(Theme.of(context).colorScheme.onSurfaceVariant),
                      // bgColorBuilder: FixedColorBuilder(Colors.grey.withOpacity(0.2))
                    ),
                    cursor: Cursor(
                      width: 2,
                      color: Theme.of(context).colorScheme.onSurface,
                      enabled: true,
                      height: 20
                    ),
                    controller: otpController.otp,
                    onCodeSubmitted: (otp) {
                      otpController.verifyOtp(otp);
                    },
                  ),
                ),
                const SizedBox(height: AppSizes.spaceBtwSection),

                //Button Verify OTP
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        String otp = otpController.otp.text.trim();
                        otp.length == otpLength
                            ? otpController.verifyOtp(otp)
                            : AppMassages.showToastMessage(message: 'Please enter OTP');
                      },
                      child:  const Text('Verify OTP')
                  ),
                ),
                const SizedBox(height: AppSizes.inputFieldSpace),

                //Countdown
                Countdown(
                      seconds: seconds,
                      interval: const Duration(milliseconds: 1000),
                      build: (context, currentRemainingTime) {
                        if(currentRemainingTime == 0.0) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Didn\'t receive OTP?', style: Theme.of(context).textTheme.bodyMedium),
                              TextButton(
                                onPressed: () {
                                  currentRemainingTime = seconds.toDouble();
                                  otpController.whatsappSendOtp(phone: otpController.phoneNumber.value);
                                  // otpController.phoneAuthentication(otpController.selectedCountry1.value, otpController.phone.text.trim());
                                },
                                child: Text('Resend OTP',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.linkColor))
                              ),
                            ],
                          );
                        } else {
                          return Text('Didn\'t receive OTP? Resend in ${currentRemainingTime.toStringAsFixed(0)} Sec',
                              style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center);
                        }
                      },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}