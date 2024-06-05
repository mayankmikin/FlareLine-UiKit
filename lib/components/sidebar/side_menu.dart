import 'package:flareline_uikit/core/theme/flareline_colors.dart';
import 'package:flareline_uikit/service/sidebar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

class SideMenuWidget extends StatelessWidget {
  dynamic e;
  bool? isDark;

  SideMenuWidget({super.key, this.e, this.isDark});

  @override
  Widget build(BuildContext context) {
    isDark ?? false;
    return _itemMenuWidget(context, e, isDark!);
  }

  Widget _itemMenuWidget(BuildContext context, e, bool isDark) {
    List? childList = e['childList'];

    bool isExpanded =
        context.watch<SideBarProvider>().isExpanded(e['menuName'], childList);
    bool isSelected = childList != null && childList.isNotEmpty
        ? false
        : context
            .watch<SideBarProvider>()
            .isSelectedPath(context, e['path'] ?? '');

    return Column(children: [
      InkWell(
        child: Container(
            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? (isDark
                      ? const LinearGradient(
                          begin: Alignment(1.00, -0.03),
                          end: Alignment(-1, 0.03),
                          colors: [Color(0x0C316AFF), Color(0x38306AFF)],
                        )
                      : const LinearGradient(
                          begin: Alignment(1.00, -0.03),
                          end: Alignment(-1, 0.03),
                          colors: [
                            FlarelineColors.background,
                            FlarelineColors.gray
                          ],
                        ))
                  : null,
            ),
            child: Row(
              children: [
                if (e['icon'] != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: SvgPicture.asset(
                      e['icon'],
                      width: 18,
                      height: 18,
                      color:
                          isDark ? Colors.white : FlarelineColors.darkBlackText,
                    ),
                  ),
                Expanded(
                    child: Text(
                  e['menuName'],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : FlarelineColors.darkBlackText),
                )),
                if (childList != null && childList.isNotEmpty)
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color:
                        isDark ? Colors.white : FlarelineColors.darkBlackText,
                  )
              ],
            )),
        onTap: () {
          if (childList != null && childList.isNotEmpty) {
            context.read<SideBarProvider>().setExpandedMenuName(e['menuName']);
          } else {
            context.read<SideBarProvider>().setExpandedMenuName('');
            pushOrJump(context, e);
          }
        },
      ),
      const SizedBox(
        height: 10,
      ),
      if (childList != null && childList.isNotEmpty)
        Visibility(
            visible: isExpanded,
            child: Column(
              children: childList
                  .map((e) => _itemSubMenuWidget(context, e, isDark))
                  .toList(),
            ))
    ]);
  }

  Widget _itemSubMenuWidget(BuildContext context, e, bool isDark) {
    bool isSelected = context
        .watch<SideBarProvider>()
        .isSelectedPath(context, e['path'] ?? '');

    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 50, top: 10, bottom: 10),
        color: isSelected
            ? (isDark ? FlarelineColors.darkBackground : FlarelineColors.gray)
            : Colors.transparent,
        child: Row(
          children: [
            Expanded(
                child: Text(
              e['menuName'],
              style: TextStyle(
                  color: isDark ? Colors.white : FlarelineColors.darkBlackText),
            )),
          ],
        ),
      ),
      onTap: () {
        pushOrJump(context, e);
      },
    );
  }

  pushOrJump(BuildContext context, e) {
    if (Scaffold.of(context).isDrawerOpen) {
      Scaffold.of(context).closeDrawer();
    }

    String path = e['path'];

    String? routePath = ModalRoute.of(context)?.settings?.name;

    if (path == routePath) {
      return;
    }
    Navigator.of(context).pushNamed(path);
  }
}
