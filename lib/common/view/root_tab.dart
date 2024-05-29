import 'package:app_template/common/const/colors.dart';
import 'package:app_template/common/layout/default_layout.dart';
import 'package:app_template/common/utils/app_bar_util.dart';
import 'package:app_template/template_guide_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with TickerProviderStateMixin {
  late TabController _tabController;
  int index = 0;

  @override
  void initState() {
    _tabController = TabController(
      length: 5,
      vsync: this,  //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );

    _tabController.addListener(tabListener);
    super.initState();
  }

  void tabListener() {
    setState(() {
      index = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBarUtil.buildAppBar(AppBarType.TEXT_TITLE, title: '홈'),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          const TemplateGuideScreen(),
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 300,
                        child: Text('sdsad'),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 300,
                        color: Colors.grey,
                        child: Text('sdsad'),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 300,
                        child: Text('sdsad'),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 300,
                        color: Colors.grey,
                        child: Text('sdsad'),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Center(child: Text('3'),),
          Center(child: Text('4'),),
          Center(child: Text('5'),),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
            )
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: PRIMARY_COLOR,
            unselectedItemColor: BODY_TEXT_COLOR,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            type: BottomNavigationBarType.fixed, // 디폴트 : shifting -> 탭 메뉴를 클릭할 때 마다 선택된 메뉴가 확대됨
            onTap: (int index){
              _tabController.animateTo(index);
            },
            currentIndex: index,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: '1',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: '2',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_outlined),
                label: '3',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_outlined),
                label: '4',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_outlined),
                label: '5',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
