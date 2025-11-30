import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailLoginController = TextEditingController();
  final TextEditingController passwordLoginController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  @override
  void onClose() {
    emailLoginController.dispose();
    passwordLoginController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.onClose();
  }
}