// @dart=2.9

import 'package:admin_toutn/core/model/Reclamation.dart';
import 'package:admin_toutn/core/model/chardata.dart';
import 'package:admin_toutn/core/model/imaa_patri.dart';
import 'package:admin_toutn/core/model/notification.dart' ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

class AdminService {
  static const endpoint = "https://tourtunisiapi.herokuapp.com/sites";
  static BaseOptions options = BaseOptions(
      baseUrl: 'https://fcm.googleapis.com/fcm',
      connectTimeout: 30000,
      receiveTimeout: 30000,
      contentType: "application/json",
      headers: {
        "Authorization":
            "key=AAAAeGJl3iI:APA91bGkTLRDnQ6w6nPSfGSl9Nfcl8ger_-dFQhU33z6Fv_8OHd00qjX2TYXu2NQ7J5T2BfjpogpMBEXAwrBY7XzRHJAboXn_iWpVHzX7W4DB0T4fpB3uIHowHQ0m91yorC3NjgMsI0b"
      },
      validateStatus: (code) {
        if (code >= 200) {
          return true;
        } else
          return false;
      });
  static BaseOptions options2 = BaseOptions(
      baseUrl: 'https://api.emailjs.com/api/v1.0/email/send',
      connectTimeout: 30000,
      receiveTimeout: 30000,
      contentType: "application/json",
      headers: {
        "origin":'http://localhost'
      },
      validateStatus: (code) {
        if (code >= 200) {
          return true;
        } else
          return false;
      });
  static Dio dio = Dio(options);
  CollectionReference claims = FirebaseFirestore.instance.collection("claims");
  Future sendEmail(
      {String name, String email, String message, String title}) async {
    final serviceId="service_9o5bydi";
    final templateId="template_f4sjar9";
    final userId="user_7U1dCruBlDe0JgrfnHifU";
    Dio dio = Dio(options2);

    try {
      final response =await dio.post("/",data: {
        "service_id":serviceId,
        "template_id": templateId,
        "user_id": userId,
        "template_params": {
          "to_name":name,
          "user_email":email,
          "user_title":title,
          "message":message
        }
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("feedbacksent");
        print(response.data.toString());

      } else if (response.statusCode == 400 || response.statusCode == 404) {
        print(response.data.toString());
        return "ERROR feedback" + response.data.toString();
      }
    } on DioError catch (exception) {
      print("feedback catch");

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
  Future getClaimsPermonth(
    year,
  ) async {
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    List<CharData> chartMonths = [];
    for (var month in months) {
      DocumentSnapshot res = await claims
          .doc(year)
          .collection(month)
          .doc(month)
          .get()
          .then((value) {
        if (value.exists) {
          print("I am here ${value.data()["count"]} count in $month");
          chartMonths.add(
              CharData(count: value.data()["count"], month: month, year: year));
          return value;
        } else {
          print("I am here no count in $month");
          chartMonths.add(CharData(count: 0, month: month, year: year));
        }
      }).catchError((FirebaseException e) {
        print("ERROR IS" + e.message + e.code);
      });
    }
    return chartMonths;
  }

  Future getAllNotif() async {
    List<Notification> notifs = [];

    QuerySnapshot res = await FirebaseFirestore.instance
        .collection("notifications")
        .get()
        .catchError((FirebaseException e) {
      print("ERROR IS" + e.message + e.code);
    });
    for (var e in res.docs) {
      notifs.add(Notification.fromMap(e.data(),e.id));
    }

    return notifs;
  }
  Future getAllClaims() async {
    List<Reclamation> claims = [];

    QuerySnapshot res = await FirebaseFirestore.instance
        .collection("allclaims")
        .get()
        .catchError((FirebaseException e) {
      print("ERROR IS" + e.message + e.code);
    });
    for (var e in res.docs) {
      claims.add(Reclamation.fromMap(e.data()));
    }

    return claims;
  }
  Future getImma() async {
    List<Immat> imma_list = [];

    QuerySnapshot res = await FirebaseFirestore.instance
        .collection("immaterial")
        .get()
        .catchError((FirebaseException e) {
      print("ERROR IS" + e.message + e.code);
    });
    for (var e in res.docs) {
      imma_list.add(Immat.fromMap(e.data(),e.id));
    }

    return imma_list;
  }

  Future sendNotification(Notification notif) async {
    Response response = await dio.post("/send", data: {
      "to": "/topics/messaging",
      "notification": {"title": notif.title, "body": notif.description},
      "data": {"msgId": "msg_12344"}
    });
    print("response is");
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responsejson = response.data["message_id"];
      print(responsejson);
      return responsejson;
    } else {
      print("error");
      print(response.data.toString());
      return "ERROR" + response.data.toString();
    }
  }
}
