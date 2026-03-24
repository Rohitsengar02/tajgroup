import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter/foundation.dart';

class MongoService {
  static Db? _db;
  
  // Replace with your MongoDB Atlas or Local connection string
  // For local: "mongodb://localhost:27017/tajpro"
  static const String mongoUrl = "mongodb+srv://username:password@cluster.mongodb.net/tajpro";

  static Future<void> connect() async {
    try {
      _db = await Db.create(mongoUrl);
      await _db!.open();
      debugPrint("Connected to MongoDB");
    } catch (e) {
      debugPrint("MongoDB Connection Error: $e");
    }
  }

  static Db get db {
    if (_db == null) throw Exception("MongoDB not initialized");
    return _db!;
  }

  static Future<void> close() async {
    await _db?.close();
  }
}
