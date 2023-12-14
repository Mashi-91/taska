import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/constant/utils.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  bool isFirst = true;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Utils.snackBarMsg(
        titleWidget: const Icon(
          Icons.wifi_off,
          color: Colors.white,
          size: 30,
        ),
        msg:
            'Oops! It seems you\'re offline. Please check your internet connection.',
      );
    } else {
      if (isFirst) {
        isFirst = false;
      } else {
        Utils.snackBarMsg(
            titleWidget: const Icon(
              Icons.wifi,
              color: Colors.white,
              size: 30,
            ),
            msg: 'Hooray! You\'re back online.');
      }
    }
  }
}
