import 'package:beamer/beamer.dart';
import 'package:coffee_shop_dashboard/core/helpers/colors.dart';
import 'package:flutter/material.dart';
import '../../core/helpers/constants.dart';
import '../../core/helpers/mixins/ui_mixins.dart';
import '../../core/helpers/theme/theme_customizer.dart';
import '../../core/services/url_service.dart';
import '../../widgets/my_widgets/my_card.dart';
import '../../widgets/my_widgets/my_container.dart';
import '../../widgets/my_widgets/my_shadow.dart';
import '../../widgets/my_widgets/my_spacing.dart';
import '../../widgets/my_widgets/my_text.dart';

typedef LeftbarMenuFunction = void Function(String key);

class LeftbarObserver {
  static Map<String, LeftbarMenuFunction> observers = {};

  static attachListener(String key, LeftbarMenuFunction fn) {
    observers[key] = fn;
  }

  static detachListener(String key) {
    observers.remove(key);
  }

  static notifyAll(String key) {
    for (var fn in observers.values) {
      fn(key);
    }
  }
}

class LeftBar extends StatefulWidget {
  final bool isCondensed;

  const LeftBar({super.key, this.isCondensed = false});

  @override
  _LeftBarState createState() => _LeftBarState();
}

class _LeftBarState extends State<LeftBar> with SingleTickerProviderStateMixin, UIMixin {
  final ThemeCustomizer customizer = ThemeCustomizer.instance;

  bool isCondensed = false;
  String path = UrlService.getCurrentUrl();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isCondensed = widget.isCondensed;
    return MyCard(
      paddingAll: 0,
      shadow: MyShadow(position: MyShadowPosition.centerRight, elevation: 0.2),
      child: AnimatedContainer(
        width: isCondensed ? 70 : 254,
        decoration: BoxDecoration(
          color: kPrimaryGreen,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          )
        ),
        duration: const Duration(milliseconds: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                     // context.beamToNamed('/dashboard', replaceRouteInformation: true);
                    },
                    child: !isCondensed ? Container(
                      height: 50,
                      width: 170,
                      margin: const EdgeInsets.only(top: 30),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/whiteBgLogo.png'),
                          fit: BoxFit.contain
                        )
                      ),
                    ) : SizedBox(
                        height: 30,
                        width: 140,
                        child: ClipRRect(
                          child: Image.asset("assets/images/whiteBgLogo.png",fit: BoxFit.cover,width: 40,height: 40,)
                        )
                    )
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
              physics: const PageScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  labelWidget("dashboard"),
                  NavigationItem(
                    iconData: Icons.speed_outlined,
                    title: "Dashboard",
                    isCondensed: isCondensed,
                    route: '/dashboard',
                  ),
                  NavigationItem(
                    iconData: Icons.storefront,
                    title: "Products",
                    isCondensed: isCondensed,
                    route: '/products',
                  ),
                  NavigationItem(
                    iconData: Icons.restaurant,
                    title: "Orders",
                    isCondensed: isCondensed,
                    route: '/orders',
                  ),
                  NavigationItem(
                    iconData: Icons.menu,
                    title: "Campaigns",
                    isCondensed: isCondensed,
                    route: '/campaigns',
                  ),
                  NavigationItem(
                    iconData: Icons.menu,
                    title: "Vouchers",
                    isCondensed: isCondensed,
                    route: '/vouchers',
                  ),

                  NavigationItem(
                    iconData: Icons.settings,
                    title: "Account Settings",
                    isCondensed: isCondensed,
                    route: '/account',
                  ),
                ],
              ),
            )),

            Container(
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              // alignment: Alignment.centerRight,
              child: MyText("Version: 1.0.0", color: colorWhite))
          ],
        ),
      ),
    );
  }

  Widget labelWidget(String label) {
    return isCondensed ? MySpacing.empty() :
    Container(
      padding: MySpacing.xy(24, 8),
      child: MyText.labelSmall(
        label.toUpperCase(),
        color: colorWhite,
        muted: true,
        maxLines: 1,
        overflow: TextOverflow.clip,
        fontWeight: 700,
      ),
    );
  }
}

// class MenuWidget extends StatefulWidget {
//   final IconData iconData;
//   final String title;
//   final bool isCondensed;
//   final bool active;
//   final List<MenuItem> children;
//
//   const MenuWidget({super.key, required this.iconData, required this.title, this.isCondensed = false, this.active = false, this.children = const []});
//
//   @override
//   _MenuWidgetState createState() => _MenuWidgetState();
// }
//
// class _MenuWidgetState extends State<MenuWidget> with UIMixin, SingleTickerProviderStateMixin {
//   bool isHover = false;
//   bool isActive = false;
//   late Animation<double> _iconTurns;
//   late AnimationController _controller;
//   bool popupShowing = true;
//   Function? hideFn;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
//     _iconTurns = _controller.drive(Tween<double>(begin: 0.0, end: 0.5).chain(CurveTween(curve: Curves.easeIn)));
//     LeftbarObserver.attachListener(widget.title, onChangeMenuActive);
//   }
//
//   void onChangeMenuActive(String key) {
//     if (key != widget.title) {
//       onChangeExpansion(false);
//     }
//   }
//
//   void onChangeExpansion(value) {
//     isActive = value;
//     if (isActive) {
//       _controller.forward();
//     } else {
//       _controller.reverse();
//     }
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     var route = currentRoute;
//     isActive = widget.children.any((element) => element.route == route);
//     onChangeExpansion(isActive);
//     if (hideFn != null) {
//       hideFn!();
//     }
//     // popupShowing = false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // var route = Uri.base.fragment;
//     // isActive = widget.children.any((element) => element.route == route);
//     if (widget.isCondensed) {
//       return CustomPopupMenu(
//         backdrop: true,
//         show: popupShowing,
//         hideFn: (hide) => hideFn = hide,
//         onChange: (_) {
//           // popupShowing = _;
//         },
//         placement: CustomPopupMenuPlacement.right,
//         menu: MouseRegion(
//           cursor: SystemMouseCursors.click,
//           onHover: (event) {
//             setState(() {
//               isHover = true;
//             });
//           },
//           onExit: (event) {
//             setState(() {
//               isHover = false;
//             });
//           },
//           child: MyContainer.transparent(
//             margin: MySpacing.fromLTRB(16, 0, 16, 8),
//             color: isActive || isHover ? leftBarTheme.activeItemBackground : Colors.transparent,
//             padding: MySpacing.xy(8, 8),
//             child: Center(
//               child: Icon(
//                 widget.iconData,
//                 color: (isHover || isActive) ? leftBarTheme.activeItemColor : leftBarTheme.onBackground,
//                 size: 20,
//               ),
//             ),
//           ),
//         ),
//         menuBuilder: (_) => MyContainer.bordered(
//           paddingAll: 8,
//           width: 190,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisSize: MainAxisSize.min,
//             children: widget.children,
//           ),
//         ),
//       );
//     }
//     else {
//       return MouseRegion(
//         cursor: SystemMouseCursors.click,
//         onHover: (event) {
//           setState(() {
//             isHover = true;
//           });
//         },
//         onExit: (event) {
//           setState(() {
//             isHover = false;
//           });
//         },
//         child: MyContainer.transparent(
//           margin: MySpacing.fromLTRB(24, 0, 16, 0),
//           paddingAll: 0,
//           child: ListTileTheme(
//             contentPadding: const EdgeInsets.all(0),
//             dense: true,
//             horizontalTitleGap: 0.0,
//             minLeadingWidth: 0,
//             child: ExpansionTile(
//                 tilePadding: MySpacing.zero,
//                 initiallyExpanded: isActive,
//                 maintainState: true,
//                 onExpansionChanged: (context) {
//                   LeftbarObserver.notifyAll(widget.title);
//                   onChangeExpansion(context);
//                 },
//                 trailing: RotationTransition(
//                   turns: _iconTurns,
//                   child: Icon(
//                     LucideIcons.chevron_down,
//                     size: 18,
//                     color: leftBarTheme.onBackground,
//                   ),
//                 ),
//                 iconColor: leftBarTheme.activeItemColor,
//                 childrenPadding: MySpacing.x(12),
//                 title: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Icon(
//                       widget.iconData,
//                       size: 20,
//                       color: isHover || isActive ? leftBarTheme.onBackground : leftBarTheme.onBackground,
//                     ),
//                     MySpacing.width(18),
//                     Expanded(
//                       child: MyText.labelLarge(
//                         widget.title,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         textAlign: TextAlign.start,
//                         color: isHover || isActive ? leftBarTheme.onBackground : leftBarTheme.onBackground,
//                       ),
//                     ),
//                   ],
//                 ),
//                 collapsedBackgroundColor: Colors.transparent,
//                 shape: const RoundedRectangleBorder(
//                   side: BorderSide(color: Colors.transparent),
//                 ),
//                 backgroundColor: Colors.transparent,
//                 children: widget.children),
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//     LeftbarObserver.detachListener(widget.title);
//   }
// }
//
// class MenuItem extends StatefulWidget {
//   final IconData? iconData;
//   final String title;
//   final bool isCondensed;
//   final String? route;
//
//   const MenuItem({
//     super.key,
//     this.iconData,
//     required this.title,
//     this.isCondensed = false,
//     this.route,
//   });
//
//   @override
//   _MenuItemState createState() => _MenuItemState();
// }
//
// class _MenuItemState extends State<MenuItem> with UIMixin {
//   bool isHover = false;
//
//   @override
//   Widget build(BuildContext context) {
//     bool isActive = currentRoute == widget.route;
//     return GestureDetector(
//       onTap: () {
//         if (widget.route != null) {
//          context.beamToNamed(widget.route!);
//         }
//       },
//       child: MouseRegion(
//         cursor: SystemMouseCursors.click,
//         onHover: (event) {
//           setState(() {
//             isHover = true;
//           });
//         },
//         onExit: (event) {
//           setState(() {
//             isHover = false;
//           });
//         },
//         child: MyContainer.transparent(
//           margin: MySpacing.fromLTRB(4, 0, 8, 4),
//           color: isActive || isHover ? leftBarTheme.activeItemBackground : Colors.transparent,
//           width: MediaQuery.of(context).size.width,
//           padding: MySpacing.xy(18, 7),
//           child: MyText.bodySmall(
//             "${widget.isCondensed ? "" : "- "}  ${widget.title}",
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//             textAlign: TextAlign.left,
//             fontSize: 12.5,
//             color: isActive || isHover ? leftBarTheme.activeItemColor : leftBarTheme.onBackground,
//             fontWeight: isActive || isHover ? 600 : 500,
//           ),
//         ),
//       ),
//     );
//   }
// }

class NavigationItem extends StatefulWidget {
  final IconData? iconData;
  final String title;
  final bool isCondensed;
  final String? route;

  const NavigationItem({super.key, this.iconData, required this.title, this.isCondensed = false, this.route});

  @override
  _NavigationItemState createState() => _NavigationItemState();
}

class _NavigationItemState extends State<NavigationItem> with UIMixin {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    bool isActive = currentRoute == widget.route;
    return GestureDetector(
      onTap: () {
        if (widget.route != null) {
          currentRoute = widget.route!;
         context.beamToNamed(widget.route!);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: MyContainer(
          margin: MySpacing.fromLTRB(16, 0, 16, 8),
          color: isActive || isHover ? activeItemColor : Colors.transparent,
          padding: MySpacing.xy(8, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.iconData != null)
                Center(
                  child: Icon(
                    widget.iconData,
                    color: colorWhite,
                    size: 20,
                  ),
                ),
              if (!widget.isCondensed)
                Flexible(
                  fit: FlexFit.loose,
                  child: MySpacing.width(16),
                ),
              if (!widget.isCondensed)
                Expanded(
                  flex: 3,
                  child: MyText.labelLarge(
                    widget.title,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    color: colorWhite,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
