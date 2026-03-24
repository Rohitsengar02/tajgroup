import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole {
  admin,
  superStockist,
  distributor,
  salesPerson,
  retailer,
}

class UserProvider extends ChangeNotifier {
  UserRole _currentRole = UserRole.admin;
  String _userName = "";
  String _userEmail = "";
  String _token = "";
  bool _isLoggedIn = false;
  bool _isInitialized = false;

  UserRole get currentRole => _currentRole;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get token => _token;
  bool get isLoggedIn => _isLoggedIn;
  bool get isInitialized => _isInitialized;

  UserProvider() {
    loadUserSession();
  }

  Future<void> loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? "";
    _userName = prefs.getString('userName') ?? "";
    _userEmail = prefs.getString('userEmail') ?? "";
    String? role = prefs.getString('role');
    
    if (_token.isNotEmpty) {
      _isLoggedIn = true;
      if (role != null) setRoleOnly(role);
    }
    _isInitialized = true;
    notifyListeners();
  }

  void setRoleOnly(String roleName) {
    if (roleName == "Admin" || roleName == "Admin Panel") {
      _currentRole = UserRole.admin;
    } else if (roleName == "Super Stockist" || roleName == "Super Stockist Panel") {
      _currentRole = UserRole.superStockist;
    } else if (roleName == "Distributor" || roleName == "Distributor Panel") {
      _currentRole = UserRole.distributor;
    } else if (roleName == "Sales Person" || roleName == "Sales Person Panel") {
      _currentRole = UserRole.salesPerson;
    } else if (roleName == "Retailer" || roleName == "Retailer / Customer Panel") {
      _currentRole = UserRole.retailer;
    }
  }

  Future<void> login(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    _token = userData['token'];
    _userName = userData['fullName'] ?? "";
    _userEmail = userData['email'] ?? "";
    String role = userData['role'] ?? "";
    
    await prefs.setString('token', _token);
    await prefs.setString('userName', _userName);
    await prefs.setString('userEmail', _userEmail);
    await prefs.setString('role', role);
    
    _isLoggedIn = true;
    setRoleOnly(role);
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _token = "";
    _isLoggedIn = false;
    notifyListeners();
  }

  void setRole(String roleName) {
    setRoleOnly(roleName);
    notifyListeners();
  }
}
