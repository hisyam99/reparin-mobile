import 'package:get/get.dart';
import '../data/services/authentication/bindings/authentication_binding.dart';
import '../modules/booking_service/controllers/booking_service_controller.dart';
import '../modules/booking_service/views/booking_service_view.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/category_view.dart';
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
// import '../modules/location_input/bindings/location_input_bindings.dart';
// import '../modules/location_input/views/location_input_view.dart';
import '../modules/Service/bindings/service_provider_binding.dart';
import '../modules/Service/Views/service_provider_view.dart';
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
import '../modules/getconnect/bindings/getconnect_binding.dart';
import '../modules/getconnect/views/getconnect_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING;
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

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      bindings: [
        RegisterBinding(),
        LoginBinding(),
        NavbarBinding(),
        ProfileBinding()
        ]),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      bindings: [
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
      page: () => const PromoView(), // Ensure this points to CategoryView
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
        final args = Get.arguments as Map<String, dynamic>;
        return ServiceBookingView(
          serviceType: args['serviceType'] as String,
          providerName: args['providerName'] as String,
          price: args['price'] as double,
        );
      },
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ServiceBookingController());
      }),
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
      page: () => const CategoryView(), // Ensure this points to CategoryView
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(), // Ensure this points to CategoryView
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.STARTED,
      page: () => const StartedView(), // Ensure this points to CategoryView
      binding: StartedBinding(),
    ),
    GetPage(
      name: _Paths.EXPLORE,
      page: () => const ExploreView(), // Ensure this points to CategoryView
      bindings: [
        ExploreBinding(),
        NavbarBinding(),
      ]),
    GetPage(
      name: _Paths.BOOKMARK,
      page: () => const BookmarkView(), // Ensure this points to CategoryView
      bindings: [
        BookmarkBinding(),
        NavbarBinding(),
      ]),
    GetPage(
      name: _Paths.POPULAR,
      page: () =>
          const PopularServiceView(), // Ensure this points to CategoryView
      binding: PopularServiceBinding(),
    ),
    GetPage(
      name: _Paths.MESSAGE,
      page: () => const MessageView(), // Ensure this points to CategoryView
      bindings: [
        MessageBinding(),
        NavbarBinding(),
      ]),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () =>
          const NotificationView(), // Ensure this points to CategoryView
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.BookService,
      page: () => const BookServiceView(), // Ensure this points to CategoryView
      binding: BookServiceBinding(),
    ),
    GetPage(
      name: _Paths.BOOKUPCOMING,
      page: () => const MyBookingsView(), // Ensure this points to CategoryView
      binding: BookupcomingBinding(),
    ),
    GetPage(
      name: _Paths.BOOKCOMPLETED,
      page: () =>
          const BookcompletedViews(), // Ensure this points to CategoryView
      binding: BookcompletedBinding(),
    ),
    GetPage(
      name: _Paths.BOOKCANCELLED,
      page: () =>
          const BookcancelledViews(), // Ensure this points to CategoryView
      binding: BookcancelledBinding(),
    ),
    GetPage(
      name: _Paths.BOOKSUCCESS,
      page: () =>
          const BooksuccessViews(), // Ensure this points to CategoryView
      binding: BooksuccessBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENTMETHOD,
      page: () =>
          const PaymentmethodView(), // Ensure this points to CategoryView
      binding: PaymentmethodBinding(),
    ),
    GetPage(
      name: _Paths.addCard,
      page: () => const AddCardView(), // Ensure this points to CategoryView
      binding: AddCardBinding(),
    ),
    GetPage(
      name: _Paths.REVIEWSUMMARY,
      page: () =>
          const ReviewsummaryView(), // Ensure this points to CategoryView
      binding: ReviewSummaryBinding(),
    ),
    GetPage(
      name: _Paths.SUCCESSBOOKING,
      page: () =>
          const SuccessbookingView(), // Ensure this points to CategoryView
      binding: SuccessbookingBinding(),
    ),
    GetPage(
      name: _Paths.ERECEIPT,
      page: () => const EreceiptView(), // Ensure this points to CategoryView
      binding: EreceiptBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACYPOLICY,
      page: () =>
          const PrivacypolicyView(), // Ensure this points to CategoryView
      binding: PrivacypolicyBinding(),
    ),
    GetPage(
      name: _Paths.CONFIRM_ADDRESS,
      page: () =>
          const ConfirmAddressView(), // Ensure this points to CategoryView
      binding: ConfirmAddressBinding(),
    ),
    GetPage(
      name: _Paths.servicePage,
      page: () => const ServicePageView(), // Ensure this points to CategoryView
      binding: ServicePageBinding(),
    ),
    GetPage(
      name: _Paths.servicePageConfirmation,
      page: () =>
          const ServicePageConfirmationView(), // Ensure this points to CategoryView
      binding: ServicePageConfirmationBinding(),
    ),
    GetPage(
      name: _Paths.LOCATIONINPUT,
      page: () => const GetConnectView(), // Ensure this points to CategoryView
      binding: GetConnectBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE,
      page: () =>
          const ServiceProviderView(), // Ensure this points to CategoryView
      binding: ServiceProviderBinding(),
    ),
    GetPage(
      name: _Paths.REVIEW,
      page: () => const reviewView(), // Ensure this points to CategoryView
      binding: reviewBinding(),
    ),
    GetPage(
      name: _Paths.GALLARY,
      page: () => const GalleryView(), // Ensure this points to CategoryView
      binding: GalleryBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => const AboutView(), // Ensure this points to CategoryView
      binding: AboutBinding(),
    ),
    GetPage(
      name: _Paths.HELP_CENTER_FAQ,
      page: () => const FaqView(), // Ensure this points to CategoryView
      binding: FaqBinding(),
    ),
    GetPage(
      name: _Paths.CONTACT_US,
      page: () => const ContactUsView(), // Ensure this points to CategoryView
      binding: ContactUsBinding(),
    ),
  ];
}
