import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static final boxShadow = [
    const BoxShadow(
        offset: Offset(10, 10), color: Colors.black38, blurRadius: 20),
    BoxShadow(
        offset: const Offset(-5, -5),
        color: Colors.white.withOpacity(0.85),
        blurRadius: 20)
  ];

  static String secretValue = 'hasura@1907';
  static String psqlDb = 'secret';
  static String secretKey = 'x-hasura-admin-secret';
  static String userName = 'UserName';
  static String password = 'Password';
  static String type = 'Type';
  static String email = 'Email';
  static String department = 'Department';
  static String employeeCode = 'employeeCode';
  static String createdId = 'createdId';

  static String mobile = 'Mobile';
  static String avatarKey = 'Avatar';
  static List<String> departmentList = [];
  static List<String> teamList = [];
  static List<String> projectFilterList =[];
  static var distinctIds;
  static String keyDashBoard = 'LoginScreen';
  static var sharedCreatedId, shareddepId, sharedRoleId, sharedteamId, sharedisActive;
  static String? shareduserName,
      sharedpassword,
      sharedEmail,
      sharedEmployeeCode,
      sharedMobile;
  static String sharedAvatar = '';
  static bool logout = true;
  static String avatar =
      'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar_3.png?alt=media&token=05600dda-67d7-4a0c-a6e7-fc6c09fe4a95';
  static Map<dynamic, dynamic> filterTeam = {};
  static Map<dynamic, dynamic> filterDepartment = {};

  getStringFormSharePreferences(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  removeStringFormSharePreferences(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
