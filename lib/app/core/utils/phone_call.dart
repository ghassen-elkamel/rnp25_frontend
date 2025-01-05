import 'package:url_launcher/url_launcher.dart';

void callNumber(String phoneNumber) async {
  String url = "tel://$phoneNumber";
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not call $phoneNumber';
  }
}