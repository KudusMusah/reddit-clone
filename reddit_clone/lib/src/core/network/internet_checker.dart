import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract interface class InternetChecker {
  Future<bool> get hasInternectConnection;
}

class InternetCheckerImpl implements InternetChecker {
  @override
  Future<bool> get hasInternectConnection async =>
      await InternetConnectionChecker().hasConnection;
}
