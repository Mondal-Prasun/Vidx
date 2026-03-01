import 'package:flutter/material.dart';
import 'package:vidx/provider/asset_database.dart';
import 'package:vidx/screen/home_screen.dart';

late final AssetDatabase assetDb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  assetDb = await AssetDatabase.init();

  runApp(MaterialApp(home: HomeScreen()));
}
