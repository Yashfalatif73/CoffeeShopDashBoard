// Copy this file into your Flutter project's lib/main.dart
// Add this to pubspec.yaml under dependencies:
//   google_fonts: ^5.0.0
// Then run: flutter pub get
// To run on web: flutter run -d chrome

import 'package:beamer/beamer.dart';
import 'package:coffee_shop_dashboard/core/helpers/theme/app_style.dart';
import 'package:coffee_shop_dashboard/core/utils/sp_utils.dart';
import 'package:coffee_shop_dashboard/widgets/my_widgets/my_text.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bindings/app_binding.dart';
import 'core/helpers/colors.dart';
import 'core/helpers/constants.dart';
import 'core/helpers/theme/app_notifier.dart';
import 'firebase_options.dart';
import 'location_builders.dart';
import 'package:url_strategy/url_strategy.dart';

void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AppStyle.init();
  init();

  runApp(ChangeNotifierProvider<AppNotifier>(
    create: (context) => AppNotifier(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  final routerDelegate = BeamerDelegate(
    locationBuilder: simpleLocationBuilder.call,
    initialPath: spUtil?.get(apiToken) != null ? '/dashboard' : '/admin/login',
    // initialPath: '/admin/login',
    transitionDelegate: const NoAnimationTransitionDelegate(),
    setBrowserTabTitle: true,
    // notFoundPage: const NotFoundBeamPage(),
    routeListener: (routeInformation, delegate) {
      // currentRoute = routeInformation.uri.path;
    },
    // guards: [
    //   BeamGuard(
    //       pathPatterns: protectedRoutePaths,
    //       check: (context, location) => spUtil?.get(apiToken) != null,
    //       beamToNamed: (origin, target) => '/admin/login'
    //   ),
    // ],
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (_, notifier, ___) {
        return GetMaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerDelegate: routerDelegate,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade900),
            useMaterial3: true,),
          routeInformationParser: BeamerParser(),
          backButtonDispatcher: BeamerBackButtonDispatcher(delegate: routerDelegate),
          key: Get.key,
          initialBinding: AppBinding(),
        );
      },
    );
    // return GetMaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Dashboard Web',
    //   theme: ThemeData(
    //     scaffoldBackgroundColor: Colors.white,
    //     textTheme: GoogleFonts.poppinsTextTheme(),
    //   ),
    //   home: const DashboardScreen(),
    // );
  }
}

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   int selectedIndex = 0; // 0=Dashboard, 1=Products, 2=Orders, 3=Campaigns
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           // Sidebar
//           Container(
//             width: 280,
//             decoration: BoxDecoration(
//               color: kPrimaryGreen,
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//             ),
//             child: SafeArea(
//               child: Sidebar(
//                 selectedIndex: selectedIndex,
//                 onSelect: (i) {
//                   setState(() => selectedIndex = i);
//                 },
//               ),
//             ),
//           ),
//
//           // Main content
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 36),
//               child: _buildPage(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPage() {
//     switch (selectedIndex) {
//       case 0:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             TopBar(),
//             SizedBox(height: 28),
//             DashboardHeader(),
//             SizedBox(height: 20),
//             InfoCardsRow(),
//             SizedBox(height: 32),
//             RevenueAnalyticsSection(),
//           ],
//         );
//       case 1:
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: const [
//             TopBar(),
//             SizedBox(height: 28),
//             ProductsPage(),   // 👈 new module
//           ],
//         );
//
//       case 2:
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: const [
//             TopBar(),
//             SizedBox(height: 28),
//             OrdersPage(),
//           ],
//         );
//       case 3:
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: const [
//             TopBar(),
//             SizedBox(height: 28),
//             AddCampaignScreen(),
//           ],
//         );
//       default:
//         return const SizedBox();
//     }
//   }
// }

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  const Sidebar({super.key, required this.selectedIndex, required this.onSelect});

  Widget _menuItem(String icon, String title, int index) {
    bool selected = selectedIndex == index;
    return InkWell(
      onTap: () => onSelect(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: selected
            ? BoxDecoration(
          color: const Color(0xFF18412F),
          borderRadius: BorderRadius.circular(12),
        )
            : null,
        child: Row(
          children: [
            Image.asset(icon, color: Colors.white70, height: 30, width: 30,),
            const SizedBox(width: 14),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
            Spacer(),
            selected ? Icon(Icons.arrow_forward, color: Colors.white70, size: 20): SizedBox(width: 1,),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                Image.asset('assets/images/logo.png', color: Colors.white, width: 46, height: 46),
                const SizedBox(width: 12),
                const Text('Market Coffee',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          const SizedBox(height: 28),

          _menuItem('assets/images/dash.png', 'Dashboard', 0),
          _menuItem('assets/images/products.png', 'Products', 1),
          _menuItem('assets/images/orders.png', 'Orders', 2),
          _menuItem('assets/images/campaigns.png', 'Campaigns', 3),
          _menuItem('assets/images/campaigns.png', 'Vouchers', 4),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(children:  [
                  Image.asset('assets/images/setting.png', color: Colors.white70, height: 30, width: 30,),
                  SizedBox(width: 12),
                  Text('Settings', style: TextStyle(color: Colors.white70)),
                ]),
                const SizedBox(height: 12),
                Row(children:  [
                  Image.asset('assets/images/logout.png', color: Colors.white70, height: 30, width: 30,),
                  SizedBox(width: 12),
                  Text('Logout', style: TextStyle(color: Colors.white70)),
                ])
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [

          /// --------------------------------------------------------
          /// SEARCH BAR (exact layout as your uploaded screenshot)
          /// --------------------------------------------------------
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 1,vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xffE8F2EB),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Color(0xFF057939).withOpacity(0.2)
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF579395).withOpacity(0.3)
                      ),
                      child: const Icon(Icons.search, color: Colors.green,size: 14,)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          const SizedBox(width: 30),

          /// --------------------------------------------------------
          /// USER PROFILE AREA (picture + name + role)
          /// --------------------------------------------------------
          Row(
            children: [
               Image.asset('assets/images1/profile.png', height: 30,width: 30,),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Daveo",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height:2),
                  Text(
                    "Admin",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(width: 25),

          /// --------------------------------------------------------
          /// NOTIFICATION ICON (green)
          /// --------------------------------------------------------
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xffE8F2EB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.green,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}


// class TopBar extends StatelessWidget {
//   const TopBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         // Search box
//         Expanded(
//           child: Container(
//             height: 54,
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             decoration: BoxDecoration(
//               color: kLightGreen,
//               borderRadius: BorderRadius.circular(40),
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.search, color: Colors.black45),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: TextField(
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Search',
//                     ),
//                   ),
//                 ),
//                 const Icon(Icons.mic, color: Colors.black45),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(width: 18),
//         // Profile
//         Row(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: const [
//                 Text('Dave', style: TextStyle(fontWeight: FontWeight.w600)),
//                 SizedBox(height: 4),
//                 Text('Admin', style: TextStyle(color: Colors.black45, fontSize: 12)),
//               ],
//             ),
//             const SizedBox(width: 12),
//             const CircleAvatar(
//               radius: 20,
//               backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
//             ),
//             const SizedBox(width: 8),
//             const Icon(Icons.notifications_none, color: Colors.black54),
//           ],
//         )
//       ],
//     );
//   }
// }


class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  String selected = "Today";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText.bodyLarge(
          'Dashboard',
          fontWeight: 800,
          fontSize: 30,
          // style: GoogleFonts.poppins(
          //   fontSize: 30,
          //   fontWeight: FontWeight.bold,
          // ),
        ),

        const SizedBox(height: 14),

        /// ================= MAIN BAR =================
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0D3B2E),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Left side tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _tabButton(
                    title: "Today",
                    isSelected: selected == "Today",
                  ),
                  const SizedBox(width: 22),
                  _tabButton(
                    title: "This Week",
                    isSelected: selected == "This Week",
                  ),
                  const SizedBox(width: 22),
                  _tabButton(
                    title: "This Month",
                    isSelected: selected == "This Month",
                  ),
                ],
              ),

              /// Calendar icon on right
              IconButton(
                onPressed: () async {
                  await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    initialDate: DateTime.now(),
                  );
                },
                icon: const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  /// ----------------------------------------------------------
  /// WHITE SELECTED TAB (Today)
  /// ----------------------------------------------------------
  Widget _tabButton({required String title, required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() => selected = title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// ----------------------------------------------------------
  /// UNSELECTED TEXT TABS
  /// ----------------------------------------------------------
  Widget _textTab(String title) {
    return GestureDetector(
      onTap: () {
        setState(() => selected = title);
      },
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.white,
          fontWeight: selected == title ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}



// class DashboardHeader extends StatelessWidget {
//   const DashboardHeader({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Dashboard', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 14),
//         // Tab-like date filter
//         Container(
//           height: 48,
//           padding: const EdgeInsets.all(6),
//           decoration: BoxDecoration(
//             color: kLightGreen.withOpacity(0.6),
//             borderRadius: BorderRadius.circular(40),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 120,
//                 height: 36,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: kPrimaryGreen,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: const Text('Today', style: TextStyle(color: Colors.white)),
//               ),
//               const SizedBox(width: 12),
//               const SizedBox(
//                   width: 140, child: Center(child: Text('This Week'))),
//               const SizedBox(width: 12),
//               const SizedBox(width: 140, child: Center(child: Text('This Month'))),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class InfoCardsRow extends StatelessWidget {
  const InfoCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cardWidth = (constraints.maxWidth - 72) / 4;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          InfoCard(title: 'Total Sales', value: '\$12,500', sub: '+10%'),
          InfoCard(title: 'Orders Today', value: '230', sub: '+5%'),
          InfoCard(title: 'Active Campaigns', value: '5', sub: '0%'),
          InfoCard(title: 'Low Stock Products', value: '12', sub: '0%'),
        ],
      );
    });
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String sub;
  const InfoCard({super.key, required this.title, required this.value, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 18),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          border: Border.all(color: kCardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(sub, style: const TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}

class RevenueAnalyticsSection extends StatelessWidget {
  const RevenueAnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    final heights = [150.0, 170.0, 140.0, 160.0, 180.0, 165.0, 155.0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Revenue Analytics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: const [
            Text('\$12,500', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
            SizedBox(width: 12),
            Text('This Week', style: TextStyle(color: Colors.black54)),
            SizedBox(width: 6),
            Text('+10%', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 18),

        // Bar chart like layout
        SizedBox(
          height: 220,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(days.length, (index) {
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: heights[index] / 2, // scale down
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: kLightGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(days[index], style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
