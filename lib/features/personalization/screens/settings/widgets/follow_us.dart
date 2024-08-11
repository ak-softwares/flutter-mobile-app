import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../utils/constants/api_constants.dart';
import '../../../../../utils/constants/icons.dart';

class FollowUs extends StatelessWidget {
  const FollowUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Follow us'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(icon: Icon(TIcons.facebook, size: 20, color: Colors.blue),
              onPressed: () => launchUrlString(APIConstant.facebook)),
            IconButton(icon: Icon(TIcons.instagram, size: 20, color: Colors.pinkAccent),
              onPressed: () => launchUrlString(APIConstant.instagram)),
            IconButton(icon: Icon(TIcons.youtube, size: 20, color: Colors.red),
              onPressed: () => launchUrlString(APIConstant.youtube)),
            IconButton(icon: Icon(TIcons.twitter, size: 20, color: Colors.lightBlue),
              onPressed: () => launchUrlString(APIConstant.twitter)),
          ],
        ),
      ],
    );
  }
}
