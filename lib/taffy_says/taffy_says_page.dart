import 'package:ace_taffy/common/toast_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lpinyin/lpinyin.dart';
import '../common/common_text_style.dart';

class TaffySaysPage extends StatefulWidget {
  const TaffySaysPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TaffySaysPageState();
}

class TaffySaysPageState extends State<TaffySaysPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _tc = TextEditingController();
  final player = AudioPlayer();
  late AnimationController _ac;
  late final Animation<double> _animation;
  bool running = false;
  List<String> list = [];
  int playing = 0;
  String taffySays = '关注永雏塔菲喵 关注永雏塔菲谢谢喵';

  String musicAssetName(String pinyin) {
    if (double.tryParse(pinyin) != null) {
      List<String> numToPinyin = [
        'ling',
        'yi',
        'er',
        'san',
        'si',
        'wu',
        'liu',
        'qi',
        'ba',
        'jiu'
      ];
      pinyin = numToPinyin[double.parse(pinyin).toInt()];
    } else if (pinyin.length <= 1 && pinyin != 'a' && pinyin != 'e') {
      pinyin = 'space';
    }
    return 'sounds/$pinyin.wav';
  }

  List<String> taffySaysListArrange(String input) {
    List<String> taffySays = [];
    String rawPinyin = PinyinHelper.getPinyin(input,
            separator: "#", format: PinyinFormat.WITHOUT_TONE)
        .replaceAll(' ', 'space');
    print(rawPinyin);
    rawPinyin.split('#').forEach((element) {
      taffySays.add(musicAssetName(element));
    });
    return taffySays;
  }

  Widget _avatarWidget() {
    return Center(
        child: Stack(
      children: [
        InkWell(
          onTap: () {
            if (!running) {
              if (_tc.text.isNotEmpty) {
                running = true;
                _play();
                _ac.repeat();
              } else {
                ToastProvider.error('请输入文字！');
              }
            } else {
              running = false;
              _ac.stop();
              player.release();
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
                      'assets/menu_logo/crazy_taffy.png',
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
    player.setPlayerMode(PlayerMode.lowLatency);
    player.setReleaseMode(ReleaseMode.release);
    player.onPlayerComplete.listen((event) async {
      if (playing < list.length - 1 && running == true) {
        playing++;
        await player.setSourceAsset(list[playing]);
        await player.resume();
      } else {
        if (playing == list.length - 1) {
          _ac.reset();
          playing = 0;
        }
      }
    });
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

  _play() async {
    if (taffySays != _tc.text) {
      list = taffySaysListArrange(_tc.text);
      await player.setSourceAsset(list[playing]);
      player.resume();
      taffySays = _tc.text;
    } else {
      await player.setSourceAsset(list[playing]);
      player.resume();
    }
  }
}
