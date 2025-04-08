import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../utils/constants/api_constants.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../settings/app_settings.dart';

class FollowUs extends StatelessWidget {
  const FollowUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: Icon(AppIcons.facebook, size: 20, color: Colors.blue),
              onPressed: () => launchUrlString(AppSettings.facebook)),
            IconButton(icon: Icon(AppIcons.instagram, size: 20, color: Colors.pinkAccent),
              onPressed: () => launchUrlString(AppSettings.instagram)),
            IconButton(icon: Icon(AppIcons.youtube, size: 20, color: Colors.red),
              onPressed: () => launchUrlString(AppSettings.youtube)),
            IconButton(icon: Icon(AppIcons.twitter, size: 20, color: Colors.lightBlue),
              onPressed: () => launchUrlString(AppSettings.twitter)),
          ],
        ),
      ],
    );
  }
}
