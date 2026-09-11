import 'package:flutter/material.dart';
import 'package:glance/core/storage/storage_keys.dart';
import 'package:glance/core/storage/storage_services.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(StorageServices.getString(StorageKeys.userrole) ?? ''),),
    );
  }
}