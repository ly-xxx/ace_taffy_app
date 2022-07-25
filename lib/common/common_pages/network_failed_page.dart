import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NetworkFailedPage extends StatefulWidget {
  final bool is404;

  NetworkFailedPage({Key? key, required this.is404}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NetworkFailedPageState();
}

class NetworkFailedPageState extends State<NetworkFailedPage> {
  var subscription;

  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (widget.is404)
              Image.asset(
                "assets/home/default/404.png",
                width: 308.w,
                height: 548.h,
              )
            else
              Image.asset(
                "assets/home/default/network_failed.png",
                width: 299.w,
                height: 532.h,
              )
          ],
        ),
      ),
    );
  }
}
