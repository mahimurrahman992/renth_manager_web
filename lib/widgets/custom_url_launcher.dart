import 'package:renth_manager/consts/consts.dart';

Future<void> launchCustomUrl(String url) async {
  final Uri uri = Uri.parse(url);

  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication, 
  )) {
    debugPrint('Could not launch $url');
    throw Exception('Could not launch $url');
  }
}