// @dart=2.9

import 'package:admin_toutn/core/model/site.dart';
import 'package:dio/dio.dart';

class ApiService {
  static BaseOptions options = BaseOptions(
      baseUrl: 'http://tourtunisieapi.herokuapp.com/sites',
      connectTimeout: 30000,
      receiveTimeout: 30000,
      contentType: "application/json",

      validateStatus: (code) {
        if (code >= 200) {
          return true;
        } else
          return false;
      });
  Future deleteSite( String id) async {
    Dio dio = Dio(options);

    try {
      print("delete!!");

      var response = await dio.delete("/delete/$id");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data.toString());
        /*var responsejson = json.decode(response.data.toString());
      print(responsejson);*/

        return response.data;
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        print(response.statusCode);
        print(response.data.toString());
        return "ERROR" + response.data.toString();
      }
    } on DioError catch (exception) {
      print("IAMAT update catch");

      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.receiveTimeout ||
          exception.type == DioErrorType.connectTimeout) {
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        print("exception found");
        print(exception.error);
        print(exception.message);

        return null;
      }
    }
  }
  Future updateSite(Map <String,dynamic> data , String id) async {
    Dio dio = Dio(options);

    try {
      print("IAMAT update");

      var response = await dio.patch("/Update/$id",data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data.toString());
        /*var responsejson = json.decode(response.data.toString());
      print(responsejson);*/

        return Site.fromMap(response.data);
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        print(response.data.toString());
        return "ERROR" + response.data.toString();
      }
    } on DioError catch (exception) {
      print("IAMAT update catch");

      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.receiveTimeout ||
          exception.type == DioErrorType.connectTimeout) {
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        print(exception.error);
        print(exception.message);

        return null;
      }
    }
  }
  Future createSite(Map <String,dynamic> data) async {
    Dio dio = Dio(options);

    try {
      print("I AM AT post");

      var response = await dio.post("/post",data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data.toString());
        /*var responsejson = json.decode(response.data.toString());
      print(responsejson);*/

        return Site.fromMap(response.data);
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        print(response.data.toString());
        return "ERROR" + response.data.toString();
      }
    } on DioError catch (exception) {
      print("I AM AT update catch");

      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.receiveTimeout ||
          exception.type == DioErrorType.connectTimeout) {
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        print(exception.error);
        print(exception.message);

        return null;
      }
    }
  }
  Future getSitesPerFilter(String filter) async {
    Dio dio = Dio(options);

    List<Site> sites = [];
    print("IAMATGETSITES API");

    try {
      print("IAMAT try");

      var response = await dio.get(filter);

      if (response.statusCode == 200 || response.statusCode == 201) {
        /*var responsejson = json.decode(response.data.toString());
      print(responsejson);*/
        for (var element in response.data) {
          sites.add(Site.fromMap(element));
        }
        return sites;
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        print(response.data.toString());
        return "ERROR" + response.data.toString();
      }
    } on DioError catch (exception) {
      print("IAMAT catch");

      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.receiveTimeout ||
          exception.type == DioErrorType.connectTimeout) {
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        print(exception.error);
        print(exception.message);

        return null;
      }
    }
  }
}