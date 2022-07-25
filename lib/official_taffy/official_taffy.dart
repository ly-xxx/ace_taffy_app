import 'package:ace_taffy/common/constants.dart';
import 'package:ace_taffy/common/toast_provider.dart';
import 'package:ace_taffy/common/webview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/common_text_style.dart';
import '../common/preferences_util.dart';

class OfficialTaffyPage extends StatefulWidget {
  const OfficialTaffyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OfficialTaffyPageState();
}

class OfficialTaffyPageState extends State<OfficialTaffyPage>
    with SingleTickerProviderStateMixin {
  late final ScrollController _sc;

  @override
  void initState() {
    _sc = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    //_wc.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          primary: false,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black), onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              Text(
                '塔动态',
                style: TextUtil.base.black2A.medium.sp(18),
              ),
              Text(
                '（屏幕底部滑动切换卡片）',
                style: TextUtil.base.black4E60.medium.sp(14),
              ),
            ],
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 20.w),
              onPressed: () {
                ToastProvider.error('自定义功能开发中，请耐心等候');
              },
              icon: Icon(Icons.edit, color: Colors.black, size: 18.sp),
            )
          ],
        ),
        body: WebViewPage(SpUtil.pltUrls.get(), SpUtil.pltNames.get())
      ),
    );
  }
}
