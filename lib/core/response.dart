class CResponse<T> extends BaseResponse<T> {
  CResponse({
    required String requestId,
    T? data,
    required bool isSuccess,
    Error? error,
  }) : super(
          requestId: requestId,
          data: data,
          isSuccess: isSuccess,
          error: error,
        );
}

class BaseResponse<T> {
  BaseResponse({required this.requestId, this.data, required this.isSuccess, this.error});
  bool isSuccess = false;
  String requestId;

  T? data;
  Error? error;
}

class Error {
  Error() {
    errorMessages = <String>[];
  }

  late List<String> errorMessages;

  add(String errorMessage) {
    errorMessages.add(errorMessage);
  }
}
