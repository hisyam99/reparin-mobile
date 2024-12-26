import 'package:get/get.dart';
import 'package:reparin_mobile/app/modules/maps/bindings/maps_binding.dart';
import 'package:reparin_mobile/app/modules/maps/views/maps_view.dart';
import 'package:reparin_mobile/app/modules/selected_location/bindings/selected_location_binding.dart';
import 'package:reparin_mobile/app/modules/selected_location/views/selected_location_view.dart';
import 'package:reparin_mobile/app/modules/service/views/service_view.dart';
import '../data/services/authentication/bindings/authentication_binding.dart';
import '../modules/admin_chat/bindings/admin_chat_binding.dart';
import '../modules/admin_chat/views/admin_chat_view.dart';
import '../modules/booking_service/views/booking_service_view.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/category_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/homeMerdeka/bindings/home_binding.dart';
import '../modules/homeMerdeka/views/home_view.dart';
import '../modules/promo/bindings/promo_binding.dart';
import '../modules/promo/views/promo_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profileView/bindings/profileView_binding.dart';
import '../modules/profileView/views/profileView_view.dart';
import '../modules/bookService/bindings/bookService_bindings.dart';
import '../modules/bookService/views/bookService_views.dart';
import '../modules/bookupcoming/bindings/bookupcoming_binding.dart';
import '../modules/bookupcoming/views/bookupcoming_views.dart';
import '../modules/bookcompleted/bindings/bookcompleted_binding.dart';
import '../modules/bookcompleted/views/bookcompleted_views.dart';
import '../modules/bookcancelled/bindings/bookcancelled_binding.dart';
import '../modules/bookcancelled/views/bookcancelled_views.dart';
import '../modules/bookingsuccess/bindings/booksuccess_binding.dart';
import '../modules/bookingsuccess/views/booksuccess_views.dart';
import '../modules/add_card/bindings/add_card_binding.dart';
import '../modules/add_card/views/add_card_view.dart';
import '../modules/paymentsmethod/bindings/paymentmethod_bindings.dart';
import '../modules/paymentsmethod/views/paymentmethod_views.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/reviewsummary/bindings/reviewsummary_binding.dart';
import '../modules/reviewsummary/views/reviewsummary_views.dart';
import '../modules/successbooking/bindings/successbooking_binding.dart';
import '../modules/successbooking/views/successbooking_views.dart';
import '../modules/e-receipt/bindings/e-receipt_binding.dart';
import '../modules/e-receipt/views/e-receipt_views.dart';
import '../modules/privacypolicy/bindings/privacypolicy_binding.dart';
import '../modules/privacypolicy/views/privacypolicy_views.dart';
import '../modules/confirm_address/bindings/confirm_address_binding.dart';
import '../modules/confirm_address/views/confirm_address_view.dart';
import '../modules/servicePage/bindings/servicePage_binding.dart';
import '../modules/servicePage/views/servicePage_view.dart';
import '../modules/servicePageConfirmation/bindings/servicePageConfirmation_binding.dart';
import '../modules/servicePageConfirmation/views/servicePageConfirmation_view.dart';
import '../modules/bookmark/bindings/bookmark_binding.dart';
import '../modules/bookmark/views/bookmark_view.dart';
import '../modules/message/bindings/message_binding.dart';
import '../modules/message/views/message_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/popular_service/bindings/popular_service_binding.dart';
import '../modules/popular_service/views/popular_service_view.dart';
import '../modules/started/bindings/started_binding.dart';
import '../modules/started/views/started_view.dart';
import '../modules/explore/bindings/explore_binding.dart';
import '../modules/explore/views/explore_view.dart';
import '../modules/review/bindings/review_binding.dart';
import '../modules/review/view/review_view.dart';
import '../modules/gallary/bindings/gallery_binding.dart';
import '../modules/gallary/views/gallery_view.dart';
import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_views.dart';
import '../modules/help_center_faq/bindings/faqbindings.dart';
import '../modules/help_center_faq/views/faqviews.dart';
import '../modules/contact_us/bindings/contact_us_bindings.dart';
import '../modules/contact_us/views/contact_us_views.dart';
import '../modules/navbar/bindings/navbar_binding.dart';
import '../modules/navbarMerdeka/bindings/navbar_binding.dart';
import '../modules/location_input/bindings/location_input_binding.dart';
import '../modules/location_input/views/location_input_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/searchresults/views/searchresults_view.dart';
import '../modules/booking_service/bindings/booking_service_binding.dart';
import '../modules/admin_dashboard/bindings/admin_dashboard_binding.dart';
import '../modules/admin_dashboard/views/admin_dashboard_view.dart';
import '../modules/admin_dashboard/bindings/add_service_binding.dart';
import '../modules/admin_dashboard/views/add_service_view.dart';
import '../modules/service/bindings/service_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;
  static const LOGIN = Routes.LOGIN;
  static const REGISTER = Routes.REGISTER;
  static const PROMO = Routes.PROMO;
  static const PROFILE = Routes.PROFILE;
  static const ProfileView = Routes.profileView;
  static const CATEGORY = Routes.CATEGORY;
  static const HOME = Routes.HOME;
  static const STARTED = Routes.STARTED;
  static const BOOKMARK = Routes.BOOKMARK;
  static const POPULAR = Routes.POPULAR;
  static const EXPLORE = Routes.EXPLORE;
  static const MESSAGE = Routes.MESSAGE;
  static const NOTIFICATION = Routes.NOTIFICATION;
  static const BookService = Routes.bookService;
  static const BOOKUPCOMING = Routes.BOOKUPCOMING;
  static const BOOKCOMPLETED = Routes.BOOKCOMPLETED;
  static const BOOKCANCELLED = Routes.BOOKCANCELLED;
  static const BOOKSUCCESS = Routes.BOOKSUCCESS;
  static const PAYMENTMETHOD = Routes.PAYMENTMETHOD;
  static const addCard = Routes.addCard;
  static const REVIEWSUMMARY = Routes.REVIEWSUMMARY;
  static const SUCCESSBOOKING = Routes.SUCCESSBOOKING;
  static const ERECEIPT = Routes.ERECEIPT;
  static const PRIVACYPOLICY = Routes.PRIVACYPOLICY;
  static const CONFIRM_ADDRESS = Routes.CONFIRM_ADDRESS;
  static const servicePage = Routes.servicePage;
  static const ServicePageConfirmation = Routes.servicePageConfirmation;
  static const LOCATIONINPUT = Routes.LOCATIONINPUT;
  static const REVIEW = Routes.REVIEW;
  static const SERVICE = Routes.SERVICE;
  static const GALLARY = Routes.GALLARY;
  static const ABOUT = Routes.ABOUT;
  static const HELP_CENTER_FAQ = Routes.HELP_CENTER_FAQ;
  static const CONTACT_US = Routes.CONTACT_US;
  static const SETTINGS = Routes.SETTINGS;
  static const SELECTED_LOCATION = Routes.SELECTED_LOCATION;
  static const ADMIN_DASHBOARD = Routes.ADMIN_DASHBOARD;
  static const ADMIN_DASHBOARD_ADD_SERVICE = Routes.ADMIN_DASHBOARD_ADD_SERVICE;

  static final routes = [
    GetPage(name: _Paths.LOGIN, page: () => const LoginView(), bindings: [
      RegisterBinding(),
      LoginBinding(),
      NavbarBinding(),
      ProfileBinding()
    ]),
    GetPage(name: _Paths.REGISTER, page: () => const RegisterView(), bindings: [
      RegisterBinding(),
      LoginBinding(),
      NavbarBinding(),
      ProfileBinding()
    ]),
    GetPage(name: _Paths.HOME, page: () => const HomeView(), bindings: [
      HomeBinding(),
      NavbarBinding(),
      CategoryBinding(),
    ]),
    GetPage(
        name: _Paths.HOMEMERDEKA,
        page: () => const HomeMerdekaView(),
        bindings: [
          HomeMerdekaBinding(),
          NavbarMerdekaBinding(),
          CategoryBinding(),
        ]),
    GetPage(
      name: _Paths.PROMO,
      page: () => const PromoView(),
      binding: PromoBinding(),
    ),
    GetPage(name: _Paths.PROFILE, page: () => const ProfileViews(), bindings: [
      ProfileBinding(),
      NavbarBinding(),
      AuthenticationBinding(),
    ]),
    GetPage(
      name: _Paths.SERVICEBOOKING,
      page: () {
        // Extract arguments passed during navigation
        final args = Get.arguments as Map<String, dynamic>;
        return ServiceBookingView(
          serviceType: args['serviceType'] as String? ?? '',
          providerName: args['providerName'] as String? ?? '',
          price: (args['price'] as num?)?.toDouble() ?? 0.0,
          longitude: (args['longitude'] as num?)?.toDouble() ?? 0.0,
          latitude: (args['latitude'] as num?)?.toDouble() ?? 0.0,
          address: args['address'] as String? ?? '',
        );
      },
      binding: ServiceBookingBinding(), // Use the new binding
    ),
    GetPage(
        name: _Paths.ProfileView,
        page: () => const ProfileViewView(),
        bindings: [
          ProfileViewBinding(),
          NavbarBinding(),
        ]),
    GetPage(
      name: _Paths.CATEGORY,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.STARTED,
      page: () => const StartedView(),
      binding: StartedBinding(),
    ),
    GetPage(name: _Paths.EXPLORE, page: () => const ExploreView(), bindings: [
      ExploreBinding(),
      NavbarBinding(),
    ]),
    GetPage(name: _Paths.BOOKMARK, page: () => const BookmarkView(), bindings: [
      BookmarkBinding(),
      NavbarBinding(),
    ]),
    GetPage(
      name: _Paths.POPULAR,
      page: () => const PopularServiceView(),
      binding: PopularServiceBinding(),
    ),
    GetPage(name: _Paths.MESSAGE, page: () => MessageView(), bindings: [
      MessageBinding(),
      NavbarBinding(),
    ]),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.BookService,
      page: () => const BookServiceView(),
      binding: BookServiceBinding(),
    ),
    GetPage(
      name: _Paths.BOOKUPCOMING,
      page: () => const MyBookingsView(),
      binding: BookupcomingBinding(),
    ),
    GetPage(
      name: _Paths.BOOKCOMPLETED,
      page: () => const BookcompletedViews(),
      binding: BookcompletedBinding(),
    ),
    GetPage(
      name: _Paths.BOOKCANCELLED,
      page: () => const BookcancelledViews(),
      binding: BookcancelledBinding(),
    ),
    GetPage(
      name: _Paths.BOOKSUCCESS,
      page: () => const BooksuccessViews(),
      binding: BooksuccessBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENTMETHOD,
      page: () => const PaymentmethodView(),
      binding: PaymentmethodBinding(),
    ),
    GetPage(
      name: _Paths.addCard,
      page: () => const AddCardView(),
      binding: AddCardBinding(),
    ),
    GetPage(
      name: _Paths.REVIEWSUMMARY,
      page: () => const ReviewsummaryView(),
      binding: ReviewSummaryBinding(),
    ),
    GetPage(
      name: _Paths.SUCCESSBOOKING,
      page: () => const SuccessbookingView(),
      binding: SuccessbookingBinding(),
    ),
    GetPage(
      name: _Paths.ERECEIPT,
      page: () => const EreceiptView(),
      binding: EreceiptBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACYPOLICY,
      page: () => const PrivacypolicyView(),
      binding: PrivacypolicyBinding(),
    ),
    GetPage(
      name: _Paths.CONFIRM_ADDRESS,
      page: () => const ConfirmAddressView(),
      binding: ConfirmAddressBinding(),
    ),
    GetPage(
      name: _Paths.servicePage,
      page: () => const ServicePageView(),
      binding: ServicePageBinding(),
    ),
    GetPage(
      name: _Paths.servicePageConfirmation,
      page: () => const ServicePageConfirmationView(),
      binding: ServicePageConfirmationBinding(),
    ),
    GetPage(
      name: _Paths.LOCATIONINPUT,
      page: () => const GetConnectView(),
      binding: GetConnectBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE,
      page: () => const ServiceView(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: _Paths.REVIEW,
      page: () => const reviewView(),
      binding: reviewBinding(),
    ),
    GetPage(
      name: _Paths.GALLARY,
      page: () => const GalleryView(),
      binding: GalleryBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: _Paths.HELP_CENTER_FAQ,
      page: () => const FaqView(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: _Paths.CONTACT_US,
      page: () => const ContactUsView(),
      binding: ContactUsBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.MAPS,
      page: () => const MapsView(),
      binding: MapsBinding(),
    ),
    GetPage(
      name: _Paths.SELECTED_LOCATION,
      page: () => SelectedLocationView(),
      binding: SelectedLocationBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_DASHBOARD_ADD_SERVICE,
      page: () => const AddServiceView(),
      binding: AddServiceBinding(),
    ),
    GetPage(
      name: '/search-results',
      page: () {
        final arguments = Get.arguments;
        return SearchResultsView(
          query: arguments['query'],
          services: arguments['services'],
        );
      },
    ),
    GetPage(
      name: '/admin-chat',
      page: () => const AdminChatView(),
      binding: AdminChatBinding(),
    ),
    GetPage(
      name: '/chat',
      page: () => ChatView(
          serviceId: Get.parameters['serviceId']!,
          receiverId: Get.parameters['receiverId']!),
      binding: ChatBinding(),
    ),
  ];
}
