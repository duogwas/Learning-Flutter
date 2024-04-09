import 'package:flutter/material.dart';
import 'package:flutter_firebase_basic/components/constants.dart';
import 'package:flutter_firebase_basic/components/enums.dart';
import 'package:flutter_firebase_basic/screens/classroom/home_classroom.dart';
import 'package:flutter_firebase_basic/screens/teacher/home_teacher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.selectedMenu,
  });

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    const Color inActiveIconColor = Color(0xFFB6B6B6);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, -15),
                blurRadius: 10,
                color: const Color(0xFFDADADA).withOpacity(0.15))
          ]),
      child: SafeArea(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, HomeClassroom.routeName);
              },
              icon: SvgPicture.asset(
                "assets/icons/Shop Icon.svg",
                colorFilter: selectedMenu == MenuState.home
                    ? const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn)
                    : const ColorFilter.mode(inActiveIconColor, BlendMode.srcIn),
              )),
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/Heart Icon.svg",
                colorFilter: selectedMenu == MenuState.favourite
                    ? const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn)
                    : const ColorFilter.mode(inActiveIconColor, BlendMode.srcIn),
              )),
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/Chat bubble Icon.svg",
                colorFilter: selectedMenu == MenuState.message
                    ? const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn)
                    : const ColorFilter.mode(inActiveIconColor, BlendMode.srcIn),
              )),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, HomeTeacher.routeName);
              },
              icon: SvgPicture.asset(
                "assets/icons/User Icon.svg",
                colorFilter: selectedMenu == MenuState.profile
                    ? const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn)
                    : const ColorFilter.mode(inActiveIconColor, BlendMode.srcIn),
              ))
        ],
      )),
    );
  }
}
