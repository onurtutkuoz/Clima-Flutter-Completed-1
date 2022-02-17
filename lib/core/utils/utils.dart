import 'package:uuid/uuid.dart';

String generateGuid() {
  var uuid = Uuid();
  return uuid.v1();
}
