import 'package:meta/meta.dart';

class ProviderResponse<T> {
  bool status;
  T data;

  ProviderResponse({@required this.status, @required this.data});

  static get generalError => ProviderResponse<String>(
      status: false, data: 'Something went wrong, please try again');
}
