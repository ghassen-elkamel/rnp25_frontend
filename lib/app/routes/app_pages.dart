import 'package:get/get.dart';

import '../modules/company/bindings/company_binding.dart';
import '../modules/company/views/company_view.dart';
import '../modules/dev_mode/bindings/dev_mode_binding.dart';
import '../modules/dev_mode/views/dev_mode_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/event_details/bindings/event_details_binding.dart';
import '../modules/event_details/views/event_details_view.dart';
import '../modules/events/bindings/events_binding.dart';
import '../modules/events/views/events_view.dart';
import '../modules/force_update/bindings/force_update_binding.dart';
import '../modules/force_update/views/force_update_view.dart';
import '../modules/forms_list/bindings/forms_list_binding.dart';
import '../modules/forms_list/views/forms_list_view.dart';
import '../modules/get_started/bindings/get_started_binding.dart';
import '../modules/get_started/views/get_started_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/my_notifications/bindings/my_notifications_binding.dart';
import '../modules/my_notifications/views/my_notifications_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/program/bindings/program_binding.dart';
import '../modules/program/views/program_view.dart';
import '../modules/program_management/bindings/program_management_binding.dart';
import '../modules/program_management/views/program_management_view.dart';
import '../modules/program_overview/bindings/program_overview_binding.dart';
import '../modules/program_overview/views/program_overview_view.dart';
import '../modules/qr_code_scanner/bindings/qr_code_scanner_binding.dart';
import '../modules/qr_code_scanner/views/qr_code_scanner_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/survey/bindings/survey_binding.dart';
import '../modules/survey/views/survey_view.dart';
import '../modules/transfer_credit/bindings/transfer_credit_binding.dart';
import '../modules/transfer_credit/views/transfer_credit_view.dart';
import '../modules/users/bindings/users_binding.dart';
import '../modules/users/views/users_view.dart';
import '../modules/waiting_voucher/bindings/waiting_voucher_binding.dart';
import '../modules/waiting_voucher/views/waiting_voucher_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';
import '../core/middlewares/auth_middleware.dart';

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
      middlewares: [ProfilePictureMiddleware()],
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
      middlewares: [ProfilePictureMiddleware()],
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
      middlewares: [ProfilePictureMiddleware()],
    ),
    GetPage(
      name: _Paths.SURVEY,
      page: () => const SurveyView(),
      binding: SurveyBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_DETAILS,
      page: () => const EventDetailsView(),
      binding: EventDetailsBinding(),
    ),
    GetPage(
      name: _Paths.FORMS_LIST,
      page: () => const FormsListView(),
      binding: FormsListBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.GET_STARTED,
      page: () => const GetStartedView(),
      binding: GetStartedBinding(),
    ),
    GetPage(
      name: _Paths.PROGRAM,
      page: () => const ProgramView(),
      binding: ProgramBinding(),
      middlewares: [ProfilePictureMiddleware()],
    ),
    GetPage(
      name: _Paths.PROGRAM_MANAGEMENT,
      page: () => const ProgramManagementView(),
      binding: ProgramManagementBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.PROGRAM_OVERVIEW,
      page: () => const ProgramOverviewView(),
      binding: ProgramOverviewBinding(),
      middlewares: [ProfilePictureMiddleware()],
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
  ];
}
