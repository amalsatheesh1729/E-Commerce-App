import 'package:flutter/material.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;
import 'package:simple_online_store/Providers/CartProvider.dart';
import 'package:simple_online_store/Providers/UserProvider.dart';
import 'package:simple_online_store/Services/NotificationService.dart';

import 'Models/DTO.dart';
import 'Services/cartServices.dart';
import 'Services/userservices.dart';

//SHOW SNACK BAR
ScaffoldFeatureController showSnack(BuildContext context, String s, Color c) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 3),
    content: Text(s),
    backgroundColor: c,
  ));
}





//COMMON TEXT FORM FIELD FOR BOTH USER SIGNUP AND UPDATE
TextFormField getFormField(
  TextEditingController controller,
  String label,
) {
  return TextFormField(
    autofocus: true,
    controller: controller,
    obscureText: label.contains('Password'),
    decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
        labelText: label),
    // The validator receives the text that the user has entered.
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'You can\'t leave the field blank';
      }
      if (label.contains('E-Mail') && !validateEmail(value)) {
        return 'Enter a valid gmail/yahoo/outlook address (To receive order confirmation)';
      }
      if (label.contains('Mobile') && !validateMobile(value)) {
        return 'The client side regex is checked against a valid Indian Phone Number (For Razorpay) ';
      }

      return null;
    },
  );
}

bool validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(pattern);

  return regExp.hasMatch(value);
}

bool validateEmail(String email) {
  final bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@(gmail|yahoo|outlook|)+\.[a-zA-Z]+")
      .hasMatch(email);

  return emailValid;
}

class AppBarCommon extends StatefulWidget implements PreferredSizeWidget {
  const AppBarCommon({super.key});

  @override
  State<AppBarCommon> createState() => _AppBarCommonState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}







//COMMON APP BAR ACROSS ALL SCREENS

class _AppBarCommonState extends State<AppBarCommon> {
  int cartsize = 0;
  String? selectedMenu;
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (context.mounted) {
      syncedexecutiontogetproviderdata(context);
    }
  }

  void syncedexecutiontogetproviderdata(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userid = prefs.getInt("userid");
    UserModel usermodel = await getUser(userid!);
    CartDTO cartDTO = await getUserCartFromServer(userid);
    context.read<UserProvider>().setUserState(usermodel);
    context.read<CartProvider>().setUserCartState(cartDTO);
    notifications = await getNotificationsForUser(userid);
  }

  @override
  Widget build(BuildContext context) {
    CartDTO? cartdto = context.watch<CartProvider>().cartDTO;

    if (cartdto == null) return const CircularProgressIndicator();

    cartsize = cartdto.products!.length;

    return AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/products');
            },
            icon: const Icon(Icons.home_outlined)),
        backgroundColor: Colors.purple.shade300,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                  child: badges.Badge(
                    badgeContent: Text('$cartsize'),
                    child: const Icon(Icons.shopping_cart),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                notifications.isEmpty
                    ? badges.Badge(
                        badgeContent: const Text('0'),
                        showBadge: true,
                        child: const Icon(Icons.notification_important),
                      )
                    : PopupMenuButton(
                        position: PopupMenuPosition.under,
                        child: badges.Badge(
                          badgeContent: Text('${notifications.length}'),
                          showBadge: true,
                          child: const Icon(Icons.notification_important),
                        ),
                        itemBuilder: (context) {
                          List<PopupMenuItem> popupitems = [];
                          for (NotificationModel nm in notifications) {
                            popupitems.add(PopupMenuItem(
                                onTap: () async {
                                  notifications.remove(nm);
                                  await updateNotificationsForUser(nm.notifId!);
                                  setState(() {});
                                },
                                padding: const EdgeInsets.all(25),
                                textStyle: const TextStyle(
                                  letterSpacing: 4,
                                  wordSpacing: 2,
                                  fontSize: 10,
                                ),
                                child: Text('${nm.notification}')));
                          }
                          return popupitems;
                        }),
                const SizedBox(
                  width: 20,
                ),
                PopupMenuButton(
                  position: PopupMenuPosition.under,
                  icon: const Icon(Icons.account_circle),
                  // Callback that sets the selected popup menu item.
                  initialValue: selectedMenu,
                  onSelected: (val) {
                    setState(() {
                      selectedMenu = val.toString();
                    });
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ButttonWithIcon(
                          icon: Icons.my_library_books_sharp,
                          title: "My Orders",
                          onPressed: () {
                            Navigator.pushNamed(context, '/myorders');
                          }),
                    ),
                    PopupMenuItem(
                      child: ButttonWithIcon(
                          icon: Icons.account_circle,
                          title: "My Profile",
                          onPressed: () {
                            Navigator.pushNamed(context, '/user-detail');
                          }),
                    ),
                    PopupMenuItem(
                      child: ButttonWithIcon(
                          icon: Icons.logout,
                          title: "Log Out",
                          onPressed: () async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.clear();
                            Navigator.pushNamed(context, '/home');
                          }),
                    ),
                  ],
                ),
                const SizedBox(width: 10)
              ],
            ),
          ),
        ]);
  }
}
