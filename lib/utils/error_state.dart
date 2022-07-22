part of '../diomond.dart';


class ErrorState {}

String handleError(Error error) {
  String errorDescription = "";
  if (error is DioError) {
    DioError dioError = error as DioError;
    switch (dioError.type) {
      case DioErrorType.cancel:
        errorDescription = "Request to API server was cancelled";
        break;
      case DioErrorType.connectTimeout:
        errorDescription = "Connection timeout with API server";
        break;
      case DioErrorType.other:
        errorDescription =
            "Connection to API server failed due to internet connection";
        break;
      case DioErrorType.receiveTimeout:
        errorDescription = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        errorDescription =
            "Received invalid status code: ${dioError.response!.statusCode}";
        break;
      case DioErrorType.sendTimeout:
        errorDescription = "Send timeout in connection with API server";
        break;
    }
  } else {
    errorDescription = "Unexpected error occured";
  }
  return errorDescription;
}

String handleErrorDio(DioError dioError) {
  String errorDescription = "";
  if (dioError != null) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        errorDescription = "Request to API server was cancelled";
        break;
      case DioErrorType.connectTimeout:
        errorDescription = "Connection timeout with API server";
        break;
      case DioErrorType.other:
        errorDescription = "Tidak ada koneksi internet";
        break;
      case DioErrorType.receiveTimeout:
        errorDescription = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        errorDescription =
            "Received invalid status code: ${dioError.response!.statusCode}";
        break;
      case DioErrorType.sendTimeout:
        errorDescription = "Send timeout in connection with API server";
        break;
    }
  }
  return errorDescription;
}
