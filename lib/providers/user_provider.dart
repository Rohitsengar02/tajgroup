import 'package:flutter/material.dart';

enum UserRole {
  admin,
  superStockist,
  distributor,
  salesPerson,
  retailer,
}

class UserProvider extends ChangeNotifier {
  UserRole _currentRole = UserRole.admin;
  String _userName = "Rohit Sharma";
  String _userEmail = "rohit@tajpro.com";

  UserRole get currentRole => _currentRole;
  String get userName => _userName;
  String get userEmail => _userEmail;

  void setRole(String roleName) {
    if (roleName == "Admin Panel") {
      _currentRole = UserRole.admin;
    } else if (roleName == "Super Stockist Panel") {
      _currentRole = UserRole.superStockist;
    } else if (roleName == "Distributor Panel") {
      _currentRole = UserRole.distributor;
    } else if (roleName == "Sales Person Panel") {
      _currentRole = UserRole.salesPerson;
    } else if (roleName == "Retailer / Customer Panel") {
      _currentRole = UserRole.retailer;
    }
    notifyListeners();
  }
}
