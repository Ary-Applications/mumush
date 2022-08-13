import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../base/base_view_model.dart';

@injectable
class HomeViewModel extends BaseViewModel {
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}