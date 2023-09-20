import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  void removeAndNavigateToRoute(String _route) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(_route, (Route<dynamic> route) => false); // replace old page with new page so user cant go back
   // navigatorKey.currentState?.popAndPushNamed(_route); // replace old page with new page so user cant go back
  }

  void navigateToRoute(String _route) {
    navigatorKey.currentState?.pushNamed(_route); // keep old page and go to new page
  }

  void navigateToPage(Widget _page) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (BuildContext _context) {
          return _page;
        },
      ),
    ); // same
  }


  String? getCurrentRoute() {
    return ModalRoute.of(navigatorKey.currentState!.context)?.settings.name!;
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }
}
