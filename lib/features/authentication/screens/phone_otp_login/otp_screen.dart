import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/loaders/loader.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/navigation_helper.dart';
import '../../controllers/phone_otp_controller/phone_otp_controller.dart';
class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otpController = Get.put(OTPController());
    int seconds  = 60;
    int otpLength = 4;
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
                const SizedBox(height: TSizes.sm),
                Text('Please Enter $otpLength Digit OTP to verify your phone number',
                    style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: TSizes.spaceBtwItems),

                //Phone number
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(otpController.countryCode.value + otpController.phoneNumber.value,
                        style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    InkWell(
                      onTap: () => NavigationHelper.navigateToMobileLogin(),
                      child: Row(
                        children: [
                          Text('Edit',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: TColors.linkColor),
                              textAlign: TextAlign.center
                          ),
                          const SizedBox(width: TSizes.xs),
                          Icon(TIcons.edit, color: TColors.linkColor,size: 15,)
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSection),

                //Otp Input field
                SizedBox(
                  width: 250,
                  child: PinFieldAutoFill(
                    codeLength: otpLength, //code length, default 6
                    cursor: Cursor(
                      color: Colors.pink,
                      enabled: true,
                      width: 2, // Specify the width of the cursor
                      height: 24, // Specify the height of the cursor
                    ),
                    textInputAction: TextInputAction.done,
                    decoration: UnderlineDecoration(
                      textStyle: const TextStyle(fontSize: 18, color: Colors.black),
                      colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.4)),
                      // bgColorBuilder: FixedColorBuilder(Colors.grey.withOpacity(0.2))
                    ),
                    controller: otpController.otp,
                    // currentCode: otpController.messageOtpCode.value,
                    // onCodeChanged: (code) {
                    //   otpController.messageOtpCode.value = code!;
                    // },
                    onCodeSubmitted: (otp) {
                      otpController.verifyOTPFast2sms(otp);
                    },
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSection),

                //Button Verify OTP
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: ()
                      {
                        String otp = otpController.otp.text.trim();
                        otp.length == otpLength
                            ? otpController.verifyOTPFast2sms(otp)
                            : TLoaders.customToast(message: 'Please enter OTP');
                      },
                      child:  const Text('Verify OTP')
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

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
                                  otpController.fast2SmsSendOpt(phone: otpController.phoneNumber.value);
                                  // otpController.phoneAuthentication(otpController.selectedCountry1.value, otpController.phone.text.trim());
                                },
                                child: Text('Resend OTP',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: TColors.linkColor))
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