import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

import 'hoje_page.dart';
import 'home_main_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _intCurrentIntegrado = 0;
  final _pagaeController = PageController();

  @override
  void initState() {

    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottonNavBar(),
      body: _pageView(),
    );
  }

  PageView _pageView() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pagaeController,
      children: [Calendar(), const HojePage()],
    );
  }

  Widget _bottonNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _intCurrentIntegrado,
      onTap: (indexTap) {
        setState(
          () {
            _intCurrentIntegrado = indexTap;

            _pagaeController.jumpToPage(indexTap);
          },
        );
      },
      items: const [
        BottomNavigationBarItem(
          label: 'Agendar',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Hoje',
          icon: Icon(Icons.view_agenda_outlined),
        ),
      ],
    );
  }

}
