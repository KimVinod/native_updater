import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as flutter_toast;
import 'package:url_launcher/url_launcher_string.dart';

class ErrorMaterialAlert extends StatelessWidget {
  final String appName;
  final String description;
  final String? playStoreUrl;
  final String? errorCloseButtonLabel;
  final String? errorSubtitle;

  const ErrorMaterialAlert({
    super.key,
    required this.appName,
    required this.description,
    this.playStoreUrl,
    this.errorCloseButtonLabel,
    this.errorSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    Widget closeButton = TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(errorCloseButtonLabel ?? 'Close'),
    );

    Widget openButton = TextButton(
      onPressed: () async {
        Navigator.pop(context);
        if(playStoreUrl == null) return;

        if(await canLaunchUrlString(playStoreUrl!)) {
          launchUrlString(playStoreUrl!, mode: LaunchMode.externalApplication);
        } else {
          flutter_toast.Fluttertoast.showToast(
            msg: "Error occurred. Your phone doesn't support opening links",
            toastLength: flutter_toast.Toast.LENGTH_SHORT,
          );
        }
      },
      child: Text(errorCloseButtonLabel ?? 'Open Play Store'),
    );

    return AlertDialog(
      title: Text(appName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(errorSubtitle ?? 'Can\'t perform update.'),
          SizedBox(height: 24.0),
          Text(description),
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if(playStoreUrl?.isNotEmpty == true) openButton,
              closeButton,
            ],
          ),
          SizedBox(height: 16.0),
          Divider(),
          SizedBox(height: 16.0),
          Image.asset(
            'packages/native_updater/images/google_play.png',
            width: 120.0,
          ),
        ],
      ),
    );
  }
}
