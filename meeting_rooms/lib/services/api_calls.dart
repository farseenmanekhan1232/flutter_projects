import "dart:convert";

import "package:firebase_auth/firebase_auth.dart";
import "package:http/http.dart" as http;
import "package:meeting_rooms/models/response.dart";

class ApiCalls {
  String baseUrl = "https://meetingroomsapi.onrender.com/meetingrooms";
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<ApiResponse> meetingRooms() async {
    String link = baseUrl;
    try {
      final response = await http.get(Uri.parse(link));
      return ApiResponse(
        code: response.statusCode,
        responseBody: response.body,
      );
    } catch (e) {
      return ApiResponse(responseBody: "error");
    }
  }

  Future<ApiResponse> meetings(String date, String slot) async {
    String link = "$baseUrl/$date/$slot";
    try {
      final response = await http.get(Uri.parse(link));
      return ApiResponse(
        code: response.statusCode,
        responseBody: response.body,
      );
    } catch (e) {
      return ApiResponse(responseBody: "error");
    }
  }

  Future<ApiResponse> userMeets() async {
    String link = "$baseUrl/user/$uid";
    try {
      final response = await http.get(Uri.parse(link));
      return ApiResponse(
        code: response.statusCode,
        responseBody: response.body,
      );
    } catch (e) {
      return ApiResponse(responseBody: "error");
    }
  }

  //post apis
  Future<ApiResponse> scheduleMeet(
      String mid, String title, String slots, String date) async {
    String link = "$baseUrl/meetingroom/$mid/$date";

    try {
      final response = await http.post(
        Uri.parse(link),
        body: jsonEncode({
          "title": title,
          "uid": uid,
          "slots": slots,
        }),
        headers: {"Content-Type": "application/json"},
      );
      return ApiResponse(
        code: response.statusCode,
        responseBody: response.body,
      );
    } catch (e) {
      return ApiResponse(responseBody: "error");
    }
  }

  Future<ApiResponse> cancelMeet(String meetingId, String date) async {
    String link = "$baseUrl/meetingroom";
    try {
      final response = await http.delete(
        Uri.parse(link),
        body: jsonEncode({
          "uid": uid,
          "meetingid": meetingId,
          "date": date,
        }),
        headers: {"Content-Type": "application/json"},
      );
      return ApiResponse(
        code: response.statusCode,
        responseBody: response.body,
      );
    } catch (e) {
      return ApiResponse(responseBody: "error");
    }
  }
}
