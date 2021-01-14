import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

class CallService {
  void call(String number) => launch("tel: $number");
}

GetIt locator = GetIt();
void set() {
  locator.registerSingleton(CallService);
}
