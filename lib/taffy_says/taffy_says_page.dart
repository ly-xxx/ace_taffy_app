import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../common/common_text_style.dart';

class TaffySaysPage extends StatefulWidget {
  const TaffySaysPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TaffySaysPageState();
}

class TaffySaysPageState extends State<TaffySaysPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _tc = TextEditingController();
  late AnimationController _ac;
  late final Animation<double> _animation;
  bool running = false;

  Map<String, String> magicalWords = {};

  Widget _avatarWidget() {
    return Center(
        child: Stack(
      children: [
        InkWell(
          onTap: () {
            if (!running) {
              running = true;
              _play();
              _ac.repeat();
            } else {
              running = false;
              _pause();
              _ac.stop();
            }
          },
          child: RotationTransition(
            turns: _ac,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(114.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2.r, 7.r),
                      blurRadius: 15.r,
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage(
                      'asset/menu_logo/crazy_taffy.png',
                    ),
                    fit: BoxFit.fill,
                  )),
              width: 180.r,
              height: 180.r,
              alignment: Alignment.center,
            ),
          ),
        ),
        Positioned(
          bottom: 4.r,
          right: 8.r,
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(114.r),
                boxShadow: [
                  //阴影
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(4.r, 4.r),
                    blurRadius: 6.r,
                  )
                ]),
            child: const Icon(Icons.play_arrow),
          ),
        ),
      ],
    ));
  }

  @override
  void initState() {
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_ac);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            '活字印刷',
            style: TextUtil.base.black2A.medium.sp(18),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 0.r, horizontal: 20.r),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.r),
                        _avatarWidget(),
                        SizedBox(height: 15.r),
                        Text(
                          "文字",
                          style: TextUtil.base.sp(18).black2A.w500,
                        ),
                        TextField(
                          controller: _tc,
                          style: TextUtil.base.sp(16).black4E,
                        )
                      ]),
                ))));
  }

  _play() {}

  _pause() {}
}
