import 'package:clima/core/utils/utils.dart';

class CRequest<T> extends BaseRequest<T> {
  CRequest({T? data}) : super(data: data);
}

class BaseRequest<T> {
  BaseRequest({this.data}) {
    requestId = generateGuid();
  }

  T? data;
  late String requestId;
}
