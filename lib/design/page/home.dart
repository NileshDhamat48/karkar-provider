import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/design/page/messages_page.dart';
import 'package:karkar_provider_app/design/page/more_page.dart';
import 'package:karkar_provider_app/design/page/reviews_page.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget? _widget;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _notify();
    switch (index) {
      case 0:
        changewidget(
          const MyBookingPage(),
        );
        break;
      case 1:
        changewidget(
          const ReviewPage(),
        );
        break;
      case 2:
        changewidget(const MessagesPage());
        break;
      case 3:
        changewidget(
          const MorePage(),
        );
        break;
    }
  }

  void changewidget(Widget widget) {
    _widget = widget;
    _notify();
  }

  void _notify() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appbarBgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: _widget ?? const MyBookingPage(),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: AppColors.appbarBgColor),
        child: BottomNavigationBar(
          // iconSize: 25,
          elevation: 0,
          // fixedColor: AppColors.appbarBgColor,
          currentIndex: _selectedIndex,
          unselectedItemColor: AppColors.whiteColor,
          // backgroundColor: AppColors.userbgcolor,
          selectedItemColor: AppColors.bottonNavigationColor,
          showUnselectedLabels: true,
          // unselectedLabelStyle: TextStyle(color: AppColors.whiteColor),
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.shield,
                size: 25,
              ),
              label: AppLocalizations.of(context).myBookings,
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.star_rate_rounded,
                size: 30,
              ),
              label: AppLocalizations.of(context).reviews,
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                size: 25,
              ),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.more_horiz_sharp,
                size: 30,
              ),
              label: AppLocalizations.of(context).more,
            ),
          ],
        ),
      ),
    );
  }
}
