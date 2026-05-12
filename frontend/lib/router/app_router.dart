import 'package:antipattern/models/manage_listing.dart';
import 'package:antipattern/models/profile.dart';
import 'package:antipattern/models/reviews.dart';
import 'package:antipattern/pages/account_page.dart';
import 'package:antipattern/pages/add_listing_page.dart';
import 'package:antipattern/pages/all_reviews_page.dart';
import 'package:antipattern/pages/chat_list_page.dart';
import 'package:antipattern/pages/chat_room_page.dart';
import 'package:antipattern/pages/collector_dashboard.dart';
import 'package:antipattern/pages/edit_account_page.dart';
import 'package:antipattern/pages/featured_page.dart';
import 'package:antipattern/pages/orders_page.dart';
import 'package:antipattern/pages/profile_page.dart';
import 'package:antipattern/pages/sales_analytics.dart';
import 'package:antipattern/models/sellers.dart';
import 'package:antipattern/pages/search_page.dart';
import 'package:antipattern/pages/page_not_found.dart';
import 'package:antipattern/pages/seller_page.dart';
import 'package:antipattern/pages/settings_page.dart';
import 'package:antipattern/pages/wishlist_page.dart';
import 'package:go_router/go_router.dart';
import 'package:antipattern/pages/home_page.dart';
import 'package:antipattern/pages/product_page.dart';
import 'package:antipattern/models/photocards.dart';
import 'package:antipattern/pages/edit_photocard_page.dart';
import 'package:antipattern/pages/edit_seller_page.dart';


final GoRouter appRouter = GoRouter(
  errorBuilder: (context, state) => const NotFoundPage(),


  routes: [
    GoRoute(
  path: "/account",
  builder: (context, state) => const AccountPage(),
),



GoRoute(
  path: "/account/edit",
  builder: (context, state) {
    final profile = state.extra is ProfileData
        ? state.extra as ProfileData
        : currentUserProfile;

    return EditAccountPage(profile: profile);
  },
),

GoRoute(
  path: "/account/settings",
  builder: (context, state) => const SettingsPage(),
),



    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
        
GoRoute(
  path: "/seller/:id/listings",
  builder: (context, state) {
    final id = state.pathParameters["id"]!;
    return ManageListingsPage(sellerId: id);
  },
),
        
// GoRoute(
//   path: '/chat/:id',
//   builder: (context, state) {
//     final id = state.pathParameters['id']!;
//     return ChatRoomPage(conversationId: id);
//   },
// ),


// GoRoute(
//   path: '/chat',
//   builder: (context, state) => const ChatListPage(),
// ),

GoRoute(
  path: '/chat/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return ChatRoomPage(conversationId: id);
  },
),

GoRoute(
  path: '/chat',
  builder: (context, state) => const ChatListPage(),
),


    GoRoute(
      path: "/seller/:id/analytics",
      builder: (context, state) {
        final id = state.pathParameters["id"]!;
        return SalesAnalyticsPage(sellerId: id);
      },
    ),
    GoRoute(
  path: "/seller/:sellerId/create",
  builder: (context, state) {
    final sellerId = state.pathParameters['sellerId']!;
    return AddListingPage(sellerId: sellerId);
  },
),

    GoRoute(
      path: "/seller/:sellerId/edit/:id",
      builder: (context, state) {
        // Prefer extra to avoid search
        if (state.extra is Listings) {
          return EditPhotocardPage(listing: state.extra as Listings);
        }

        final id = state.pathParameters['id']!;
        final found = dummyListings.firstWhere(
          (p) => p.id == id,
          orElse: () => Listings.notFound(id),
        );

        return EditPhotocardPage(listing: found);
      },
    ),

    GoRoute(
      path: "/seller/:id",
      builder: (context, state) {
        final id = state.pathParameters["id"]!;
        return SellerPage(sellerId: id);
      },
    ),

    GoRoute(
      path: "/seller/:id/edit",
      builder: (context, state) {
        final seller = state.extra is Seller
            ? state.extra as Seller
            : dummySellers.firstWhere(
                (s) => s.id == state.pathParameters['id'],
                orElse: () => dummySellers.first,
              );

        return EditSellerPage(seller: seller);
      },
    ),


    GoRoute(
      path: "/account",
      builder: (context, state) => const AccountPage(),
    ),

    GoRoute(
      path: '/product/:id',
      name: 'product',
      builder: (context, state) {
        // Prefer extra because it avoids searching the list
        if (state.extra is Listings) {
          return ProductPage(product: state.extra as Listings);
        }

        final id = state.pathParameters['id']!;
        
        // Search dummy list safely
        final product = dummyListings.firstWhere(
          (p) => p.id == id,
          orElse: () => Listings.notFound(id),
        );

        return ProductPage(product: product);
      },
    ),



    GoRoute(
      path: '/search',
      builder: (context, state) {
        final q = state.uri.queryParameters['query'] ?? '';
        return SearchPage(initialQuery: q);
      },
    ),
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => const WishlistPage(),
    ),

    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrdersPage(),
    ),

    GoRoute(
      path: '/collector_dashboard',
      builder: (context, state) => const CollectorDashboardPage(),
    ),

GoRoute(
  path: '/reviews',
  builder: (context, state) {
    final reviews = state.extra is List<Review>
        ? state.extra as List<Review>
        : <Review>[];

    return AllReviewsPage(
      reviews: reviews,
    );
  },
),

GoRoute(
  path: '/search',
  builder: (context, state) {
    final query = state.uri.queryParameters['query'] ?? '';
    return SearchPage(initialQuery: query);
  },
),

// GoRoute(
//   path: '/profile',
//   builder: (context, state) {
//     final sellerId = state.extra as String;
//     return ProfilePage(sellerId: sellerId);
//   },
// ),

GoRoute(
  path: "/profile/:id",
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return ProfileViewPage(userId: id);
  },
),

GoRoute(
  path: '/featured/:slug',
  builder: (context, state) {
    final slug = state.pathParameters['slug']!;
    return FeaturedPage(slug: slug);
  },
),


  ],
);
