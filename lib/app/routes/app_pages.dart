import 'package:get/get.dart';

import '../modules/company/bindings/company_binding.dart';
import '../modules/company/views/company_view.dart';
import '../modules/dev_mode/bindings/dev_mode_binding.dart';
import '../modules/dev_mode/views/dev_mode_view.dart';
import '../modules/events/bindings/events_binding.dart';
import '../modules/events/views/events_view.dart';
import '../modules/force_update/bindings/force_update_binding.dart';
import '../modules/force_update/views/force_update_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/my_notifications/bindings/my_notifications_binding.dart';
import '../modules/my_notifications/views/my_notifications_view.dart';
import '../modules/qr_code_scanner/bindings/qr_code_scanner_binding.dart';
import '../modules/qr_code_scanner/views/qr_code_scanner_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/transfer_credit/bindings/transfer_credit_binding.dart';
import '../modules/transfer_credit/views/transfer_credit_view.dart';
import '../modules/users/bindings/users_binding.dart';
import '../modules/users/views/users_view.dart';
import '../modules/waiting_voucher/bindings/waiting_voucher_binding.dart';
import '../modules/waiting_voucher/views/waiting_voucher_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;
  static const HOME = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.DEV_MODE,
      page: () => const DevModeView(),
      binding: DevModeBinding(),
    ),
    GetPage(
      name: _Paths.FORCE_UPDATE,
      page: () => const ForceUpdateView(),
      binding: ForceUpdateBinding(),
    ),
    GetPage(
      name: _Paths.MY_NOTIFICATIONS,
      page: () => const MyNotificationsView(),
      binding: MyNotificationsBinding(),
    ),
    GetPage(
      name: _Paths.COMPANY,
      page: () => const CompanyView(),
      binding: CompanyBinding(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: _Paths.USERS,
      page: () => const UsersView(),
      binding: UsersBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
      transition: Transition.upToDown,
    ),
    GetPage(
      name: _Paths.WALLET,
      page: () => const WalletView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: _Paths.TRANSFER_CREDIT,
      page: () => const TransferCreditView(),
      binding: TransferCreditBinding(),
    ),
    GetPage(
      name: _Paths.QR_CODE_SCANNER,
      page: () => const QrCodeScannerView(),
      binding: QrCodeScannerBinding(),
    ),
    GetPage(
      name: _Paths.WAITING_VOUCHER,
      page: () => const WaitingVoucherView(),
      binding: WaitingVoucherBinding(),
    ),
    GetPage(
      name: _Paths.EVENTS,
      page: () => const EventsView(),
      binding: EventsBinding(),
    ),
  ];
}
