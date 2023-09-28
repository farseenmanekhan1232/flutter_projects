import 'package:flutter/material.dart';
import 'package:meeting_rooms/models/response.dart';
import 'package:meeting_rooms/services/api_calls.dart';

class BaseApiProvider extends ChangeNotifier {
  Future<ApiResponse> meetingsRooms() async {
    ApiResponse response = await ApiCalls().meetingRooms();
    if (response.code == 200) {
      return response;
    } else {
      return ApiResponse(responseBody: 'error');
    }
  }

  Future<ApiResponse> meetings(String date, String slot) async {
    ApiResponse response = await ApiCalls().meetings(date, slot);
    if (response.code == 200) {
      return response;
    } else {
      return ApiResponse(responseBody: 'error');
    }
  }

  Future<ApiResponse> userMeets() async {
    ApiResponse response = await ApiCalls().userMeets();
    if (response.code == 200) {
      return response;
    } else {
      return ApiResponse(responseBody: 'error');
    }
  }

  Future<ApiResponse> scheduleMeet(
      String mid, String title, String slots, String date) async {
    ApiResponse response =
        await ApiCalls().scheduleMeet(mid, title, slots, date);
    if (response.code == 200) {
      return response;
    } else {
      return ApiResponse(responseBody: 'error');
    }
  }

  Future<ApiResponse> cancelMeet(String mid, String date) async {
    ApiResponse response = await ApiCalls().cancelMeet(mid, date);
    if (response.code == 200) {
      return response;
    } else {
      return ApiResponse(responseBody: 'error');
    }
  }
}
