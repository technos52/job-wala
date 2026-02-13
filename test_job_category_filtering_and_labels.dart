import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    runApp(const TestJobCategoryFilteringAndLabelsApp());
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    runApp(const TestJobCategoryFilteringAndLabelsApp(