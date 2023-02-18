
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:info_med/constants/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // make appbar transparent
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      leadingWidth: 60,
      elevation: 0,
      // rigth icon info
      actions: [
        Padding(
          padding: AppLocalizations.of(context)!.language != 'English' ? const EdgeInsets.only(left: 10.3, top: 4) : const EdgeInsets.only(right: 10.3, top: 4),
          child: Container(
            width: 50,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle),
            child: IconButton(
                splashRadius: 1,
                onPressed: () {},
                icon: const Icon(
                  size: 30,
                  Icons.info_sharp,
                  color: purple,
                )),
          ),
        ),
      ],
      // left icon setting
      leading: Padding(
        padding: AppLocalizations.of(context)!.language != 'English' ? const EdgeInsets.only(right: 10.3, top: 4) : const EdgeInsets.only(left: 10.3, top: 4),
        child: Container(
          decoration:  BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle),
          child: IconButton(
            splashRadius: 1,
            icon: const Icon(
              size: 30,
              Icons.settings,
              color: Color( 0xff8F00FF),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
