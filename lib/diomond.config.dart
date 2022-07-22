part of 'diomond.dart';

class Diomond {
  final Dio _dio = Dio();
  String prefixAuthHeader = "Bearer ";

  Diomond(this.prefixAuthHeader);

  Future<Either<bool, bool>> removeAccessToken() async {
    try {
      await SharedPreferencesHelper.removeValues();
      return const Right(true);
    } catch (e) {
      return const Left(false);
    }
  }

  // //BASE
  // Future<Either<DioError, Response>> getA(url, {id, query, page}) async {
  //   String accessToken = await SharedPreferencesHelper.getAccessToken();

  //   _dio.options.headers['Authorization'] = '$prefixAuthHeader$accessToken';
  //   _dio.options.headers['Accept'] = 'application/json';

  //   if (id != null) {
  //     url = '$url/$id';
  //   }

  //   if (page != null) {
  //     query['page'] = page;
  //   }

  //   log('QUERY $query');

  //   try {
  //     Response response = await _dio.get(url, queryParameters: query);
  //     log('RESPONSE $response');
  //     return Right(response);
  //   } on DioError catch (error) {
  //     log('ERROR ${error.stackTrace.toString()}');
  //     return Left(error);
  //   }
  // }

  Future<Either<DioError, Response>> get(url,
      {id, query, page, withToken = true}) async {
    String accessToken = await SharedPreferencesHelper.getAccessToken();

    if (withToken) {
      _dio.options.headers['Authorization'] = '$prefixAuthHeader$accessToken';
      _dio.options.headers['Accept'] = 'application/json';
    }

    if (id != null) {
      url = '$url/$id';
    }

    if (page != null) {
      query['page'] = page;
    }

    log('QUERY $query');

    try {
      Response response = await _dio.get(url, queryParameters: query);
      return Right(response);
    } on DioError catch (error) {
      log('ERROR ${error.stackTrace.toString()}');
      return Left(error);
    }
  }

  Future<Either<DioError, Response>> postWithAuth(
      url, Map<String, dynamic> body) async {
    String accessToken = await SharedPreferencesHelper.getAccessToken();
    _dio.interceptors.add(LoggingInterceptor());
    _dio.options.headers['Authorization'] = '$prefixAuthHeader$accessToken';

    log('REQUEST BODY $body');
    var formBody = FormData.fromMap(body);

    try {
      Response response = await _dio.post(url, data: formBody);
      return Right(response);
    } on DioError catch (error) {
      log('ERROR ${error.stackTrace.toString()}');
      throw error.response!.data;
    }
  }

  Future<Either<DioError, Response>> deleteWithAuth(url) async {
    String accessToken = await SharedPreferencesHelper.getAccessToken();
    _dio.interceptors.add(LoggingInterceptor());
    _dio.options.headers['Authorization'] = '$prefixAuthHeader$accessToken';
//    _dio.options.queryParameters = queryParameters;

    Response response = await _dio.delete(url);

    if (response.statusCode == 200) {
      return Right(response);
    } else {
      throw response.data;
    }
  }

  Future<Either<DioError, Response>> getWithNoAuth(url,
      {id, query, page}) async {
    if (id != null) {
      url = '$url/$id';
    }

    if (page != null) {
      query['page'] = page;
    }

    log('QUERY $query');

    try {
      Response response = await _dio.get(url, queryParameters: query);
      log('RESPONSE $response');
      return Right(response);
    } on DioError catch (error) {
      log('ERROR $error');
      return error.response?.data;
    }
  }

  Future<Either<DioError, Response>> postNoAuth(
      url, Map<String, dynamic> body) async {
    _dio.interceptors.add(LoggingInterceptor());

    log('REQUEST BODY $body');
    var formBody = FormData.fromMap(body);

    try {
      Response response = await _dio.post(url, data: formBody);
      log('RESPONSE $response');
      return Right(response);
    } on DioError catch (error) {
      log('ERROR ${handleErrorDio(error)}');
      return Left(error);
    }
  }

  // Future<Either<DioError, Response>> getMap(url, {query}) async {
  //   try {
  //     query['key'] = 'AIzaSyCbo7jjDTdFANGzFcWCc9MwXsmID-OXgiQ';
  //     log(query);
  //     Response response = await _dio.get(url, queryParameters: query);
  //     return Right(response);
  //   } on DioError catch (error) {
  //     log('ERROR ${error.stackTrace.toString()}');
  //     return Left(error);
  //   }
  // }

  Future<Either<DioError, Response>> post(url,
      {bool withToken = true, body, queryParam}) async {
    String accessToken = await SharedPreferencesHelper.getAccessToken();
    _dio.interceptors.add(LoggingInterceptor());

    if (withToken) {
      _dio.options.headers['Authorization'] = '$prefixAuthHeader$accessToken';
    }
    _dio.options.headers['Accept'] = 'application/json';

    dynamic formBody;
    if (body != null) {
      log('DIO POST BODY $body');
      formBody = FormData.fromMap(body);
    }

    log('QUERY $queryParam');

    try {
      Response response =
          await _dio.post(url, data: formBody, queryParameters: queryParam);
      return Right(response);
    } on DioError catch (error) {
      return Left(error);
    }
  }
}
