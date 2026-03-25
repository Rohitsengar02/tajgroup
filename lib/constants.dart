import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const primaryColor = Color(0xFF6C5CE7);
const secondaryColor = Color(0xFF3A86FF);
const bgColor = Color(0xFFF4F7FE); // light clean bg
const textPrimaryColor = Color(0xFF2B3674);
const textSecondaryColor = Color(0xFFA3AED0);
const surfaceColor = Colors.white;

const successColor = Color(0xFF05CD99);
const errorColor = Color(0xFFEE5D50);
const warningColor = Color(0xFFFFCE20);

const defaultPadding = 16.0;

const LinearGradient primaryGradient = LinearGradient(
  colors: [Color(0xFF6C5CE7), Color(0xFF3A86FF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient secondaryGradient = LinearGradient(
  colors: [Color(0xFFFF7A18), Color(0xFFFF3D81)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient successGradient = LinearGradient(
  colors: [Color(0xFF05CD99), Color(0xFF04A87D)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Local Backend URL for development
const String backendUrl = 'http://localhost:5000';
