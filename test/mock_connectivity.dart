import 'package:connectivity/connectivity.dart';

enum ConnectivityCase { CASE_ERROR, CASE_SUCCESS }

class MockConnectivity implements Connectivity {
  var connectivityCase = ConnectivityCase.CASE_SUCCESS;

  Stream<ConnectivityResult> _onConnectivityChanged;

  @override
  Future<ConnectivityResult> checkConnectivity() {
    if (connectivityCase == ConnectivityCase.CASE_SUCCESS) {
      return Future.value(ConnectivityResult.wifi);
    } else {
      throw Error();
    }
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    _onConnectivityChanged ??= Stream<ConnectivityResult>.fromFutures([
      Future.value(ConnectivityResult.wifi),
      Future.value(ConnectivityResult.none),
      Future.value(ConnectivityResult.mobile)
    ]).asyncMap((data) async {
      // await Future.delayed(const Duration(seconds: 1));
      if (connectivityCase == ConnectivityCase.CASE_SUCCESS) {
        return Future.value(ConnectivityResult.wifi);
      } else {
        return Future.value(ConnectivityResult.none);
      }
    });
    return _onConnectivityChanged;
  }
}
