import 'package:pkureader_frontend/account/login.dart';
import 'package:pkureader_frontend/app_theme.dart';
import 'package:flutter/material.dart';

import '../non_ui.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  @override
  void initState() {
    setDrawerListArray();
    super.initState();
  }

  void setDrawerListArray() {
    if (user != null) {
      drawerList = <DrawerList>[
        DrawerList(
          index: DrawerIndex.HOME,
          labelName: '首页',
          icon: Icon(Icons.home),
        ),
        DrawerList(
          index: DrawerIndex.FavArticles,
          labelName: '我的收藏',
          icon: Icon(Icons.bookmark),
        ),
        DrawerList(
          index: DrawerIndex.RssSources,
          labelName: '我的订阅',
          icon: Icon(Icons.source),
        ),
        DrawerList(
          index: DrawerIndex.Post,
          labelName: '发布',
          icon: Icon(Icons.add_link),
        ),
        DrawerList(
          index: DrawerIndex.About,
          labelName: '关于',
          icon: Icon(Icons.info),
        ),
      ];
    } else {
      drawerList = <DrawerList>[
        DrawerList(
          index: DrawerIndex.HOME,
          labelName: '首页',
          icon: Icon(Icons.home),
        ),
        DrawerList(
          index: DrawerIndex.About,
          labelName: '关于',
          icon: Icon(Icons.info),
        ),
      ];
    }

    if (user != null && user.isAdmin != null && user.isAdmin)
      drawerList.add(DrawerList(
        index: DrawerIndex.SubmissionManager,
        labelName:
            '待处理申请 ', // A space is added due to the strange line wrapping
        icon: Icon(Icons.pending_actions),
      ));
    if (user != null && user.isAdmin != null && !user.isAdmin)
      drawerList.add(DrawerList(
        index: DrawerIndex.GetAdmin,
        labelName:
        '获得管理员权限 ', // A space is added due to the strange line wrapping
        icon: Icon(Icons.vpn_key),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(
                            1.0 - (widget.iconAnimationController.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                      begin: 0.0, end: 24.0)
                                  .animate(CurvedAnimation(
                                      parent: widget.iconAnimationController,
                                      curve: Curves.fastOutSlowIn))
                                  .value /
                              360),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.6),
                                    offset: const Offset(2.0, 4.0),
                                    blurRadius: 8),
                              ],
                            ),
                            child: IconButton(
                              iconSize: 160,
                              padding: EdgeInsets.zero,
                              icon: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(60.0)),
                                child: user == null
                                    ? Icon(
                                        Icons.person,
                                        size: 140.0,
                                      )
                                    : Image.asset(
                                        'assets/images/userImage.png'),
                              ),
                              onPressed: user == null
                                  ? () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => LoginPage(
                                                  callback: setDrawerListArray),
                                              fullscreenDialog: true));
                                    }
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      user == null ? '未登录' : user.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
          Opacity(
            opacity: user == null ? 0.0 : 1.0,
            child: Divider(
              height: 1,
              color: AppTheme.grey.withOpacity(0.6),
            ),
          ),
          Opacity(
            opacity: user == null ? 0.0 : 1.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    '退出登录',
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppTheme.darkText,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  trailing: Icon(
                    Icons.power_settings_new,
                    color: AppTheme.pkuReaderPurple,
                  ),
                  onTap: user == null
                      ? null
                      : () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('退出登录'),
                                    content: Text('退出登录后，本地存储的新闻缓存将丢失。'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('取消')),
                                      TextButton(
                                          onPressed: () async {
                                            await Account.logOut();
                                            setState(() {
                                              setDrawerListArray();
                                            });
                                            if (widget.screenIndex ==
                                                DrawerIndex.AccountManager)
                                              navigationtoScreen(
                                                  DrawerIndex.HOME);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('好')),
                                    ],
                                  ));
                        },
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? Colors.blue
                                  : AppTheme.nearlyBlack),
                        )
                      : Icon(listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? AppTheme.pkuReaderPurple
                              : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? AppTheme.pkuReaderPurple
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppTheme.pkuReaderPurple.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  FeedBack,
  Help,
  Share,
  About,
  Invite,
  Testing,
  AccountManager,
  RssSources,
  FavArticles,
  Post,
  SubmissionManager,
  GetAdmin
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
