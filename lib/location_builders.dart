import 'package:beamer/beamer.dart';
import 'package:coffee_shop_dashboard/modules/Auth/login_screen.dart';
import 'package:coffee_shop_dashboard/modules/Campaigns/Campaigns.dart';
import 'package:coffee_shop_dashboard/modules/OrderPage/OrderPage.dart';
import 'package:coffee_shop_dashboard/modules/Products/AddProductScreen.dart';
import 'package:coffee_shop_dashboard/modules/Products/Products.dart';
import 'package:flutter/foundation.dart';
import 'modules/Campaigns/campaigns_list_page.dart';
import 'modules/Dashboard/dashboard_screen.dart';
import 'modules/Vouchers/voucher_listing.dart';
import 'modules/Vouchers/voucher_screen.dart';

final simpleLocationBuilder = RoutesLocationBuilder(
    routes: {
      ///Login Screen
      '/admin/login': (context, state, data) => const BeamPage(
        key: ValueKey('login'),
        title: 'Login',
        child: LoginScreen(),
      ),

      // Home Screen
      '/dashboard': (context, state, data) => const BeamPage(
        key: ValueKey('dashboard'),
        title: 'Dashboard',
        child: DashboardScreen(),
      ),


      //Products
      '/products': (context, state, data) => const BeamPage(
        key: ValueKey('products'),
        title: 'Products',
        child: ProductsPage(),
      ),

      '/add-product': (context, state, data) => const BeamPage(
        key: ValueKey('add-product'),
        title: 'Add Products',
        child: AddProductScreen(),
      ),

      '/orders': (context, state, data) => const BeamPage(
        key: ValueKey('orders'),
        title: 'Orders',
        child: OrdersPage(),
      ),

      '/add-campaign': (context, state, data) => const BeamPage(
        key: ValueKey('add-campaign'),
        title: 'Add Campaign',
        child: AddCampaignScreen(),
      ),
      '/campaigns': (context, state, data) => const BeamPage(
        key: ValueKey('campaigns'),
        title: 'Campaigns',
        child: CampaignsListPage(),
      ),

      '/add-voucher': (context, state, data) => const BeamPage(
        key: ValueKey('add-voucher'),
        title: 'Add Voucher',
        child: AddVoucherScreen(),
      ),
      '/vouchers': (context, state, data) => const BeamPage(
        key: ValueKey('vouhcers'),
        title: 'Vouchers',
        child: VoucherListPage(),
      ),
      //
      // ///Home Screen or Dashboard
      // '/dashboard': (context, state, data) => const BeamPage(
      //   key: ValueKey('dashboard'),
      //   title: 'Dashboard',
      //   child: HomePage(),
      // ),
      //
      // ///Category Management
      // '/categories': (context, state, data) => const BeamPage(
      //   key: ValueKey('categories'),
      //   title: 'Categories',
      //   child: CategoryViewPage(),
      // ),
      // '/add-categories': (context, state, data){
      //   final id = state.queryParameters['id'];
      //   return BeamPage(
      //     key: const ValueKey('add-categories'),
      //     title: id != null ? 'Edit Category' : 'Add Category',
      //     child: AddCategoryPage(categoryId: id),
      //   );
      // },
      //
      // ///Complaints
      // '/complaints': (context, state, data) => const BeamPage(
      //   key: ValueKey('complaints'),
      //   title: 'Complaints',
      //   child: ComplaintsListViewPage(),
      // ),
      // '/complaint-detail': (context, state, data){
      //   final id = state.queryParameters['id'];
      //   return BeamPage(
      //     key: const ValueKey('complaint-detail'),
      //     title: 'Complaint Detail',
      //     child: ComplaintDetailViewPage(complaintId: id),
      //   );
      // },
      //
      // ///Items
      // '/items': (context, state, data) => const BeamPage(
      //   key: ValueKey('items'),
      //   title: 'Items',
      //   child: ItemListViewPage(),
      // ),
      // '/item-detail': (context, state, data){
      //   final id = state.queryParameters['id'];
      //   return BeamPage(
      //     key: const ValueKey('item-detail'),
      //     title: 'Item Detail',
      //     child: ItemDetailViewPage(itemId: id),
      //   );
      // },
      //
      // ///Rider Management
      // '/riders': (context, state, data) => const BeamPage(
      //   key: ValueKey('riders'),
      //   title: 'Riders',
      //   child: RiderListViewPage(),
      // ),
      // '/add-rider': (context, state, data){
      //   final id = state.queryParameters['id'];
      //   return BeamPage(
      //     key: const ValueKey('add-rider'),
      //     title: id != null ? 'Edit Rider' : 'Add Rider',
      //     child: AddRiderPage(riderId: id),
      //   );
      // },
      // '/rider-details': (context, state, data){
      //   final id = state.queryParameters['id'];
      //   return BeamPage(
      //     key: const ValueKey('rider-details'),
      //     title: 'Rider Info',
      //     child: RiderDetailViewPage(riderId: id),
      //   );
      // },
      //
      // ///Store Management
      // '/stores': (context, state, data) => const BeamPage(
      //   key: ValueKey('store'),
      //   title: 'Stores',
      //   child: StoreListViewPage(),
      // ),
      // '/store-details': (context, state, data){
      //   final id = state.queryParameters['id'];
      //   return BeamPage(
      //     key: const ValueKey('store-details'),
      //     title: 'Store Info',
      //     child: StoreDetailViewPage(storeId: id),
      //   );
      // },
      //
      // ///Account Management
      // '/account': (context, state, data) => const BeamPage(
      //   key: ValueKey('account'),
      //   title: 'Account Settings',
      //   child: AccountSettingViewPage(),
      // ),

    }
);

const List<String> protectedRoutePaths = [
  '/dashboard',
  '/categories',
  '/add-categories',
  '/complaints',
  '/complaint-detail',
  '/items',
  '/item-detail',
  '/riders',
  '/add-rider',
  '/rider-details',
  '/stores',
  '/store-details',
  '/account',
];