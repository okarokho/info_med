
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0, top: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1000),
            child: Container(
              width: 50,
              decoration:  BoxDecoration(
                 
                  color: Colors.grey[200],
                  // Provider.of<SharedPreference>(context).darkTheme
                  //     ? Colors.black
                  //     : Colors.white
                  shape: BoxShape.circle),
              child: IconButton(
                  splashRadius: 1,
                  onPressed: () {},
                  icon: const Icon(
                    size: 30,
                    Icons.info_rounded,
                    color: Color( 0xff8F00FF),
                  )),
            ),
          ),
        ),
      ],
      leadingWidth: 60,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.3, top: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(1000),
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
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
