
## Summary
## User Authentication
Login screen with username/password fields hitting the DummyJSON /auth/login endpoint. On success, the full user object is serialized and persisted via SharedPreferences. On app launch, the splash screen checks for a cached session and auto-navigates to home if found, skipping the login screen entirely. Logout clears the cache and redirects back to login.
Bottom Navigation
Three-tab IndexedStack-based navigation (Products, Posts, Settings) preserving scroll state across tab switches. Each tab is independently managed by its own BLoC.
Products Tab
Fetches from /products?limit=10&skip=0 with skip-based infinite scroll pagination triggered 200px before the list end. Each card displays a category-mapped Material icon as a thumbnail, product title, price, and star rating. Tapping a card opens a detail screen with full description, discount badge, stock count, and tags.
Posts Tab
Fetches from /posts?limit=10&skip=0 with identical skip-based pagination. Each card shows tag chips, title, a 2-line body preview, and like/dislike/view counts. Tapping opens a detail screen with full body text and reaction stats.
Settings Tab
Displays cached user data (initials avatar, full name, username, email) without any additional API call. Includes a light/dark mode toggle that persists the selection to SharedPreferences and applies it instantly app-wide. Logout triggers a confirmation dialog before clearing the session.
Theme Management
ThemeCubit wraps Flutter's ThemeMode and persists the selection via SharedPreferences. The root MaterialApp rebuilds via BlocBuilder<ThemeCubit> on every toggle, switching between fully defined light and dark ThemeData with a custom AppColors theme extension for consistent surface, border, and text colors across both modes.
State Management
BLoC pattern throughout. AuthBloc handles session check, login, and logout. ProductsBloc and PostsBloc each have Initial, Loading, Loaded, Empty, and Error states, plus isPaginating and paginationError fields on the loaded state for non-destructive pagination feedback. ThemeCubit manages theme mode.
Local Caching
SharedPreferences used for two concerns: user session (serialized as a JSON string) and theme mode (stored as a string enum). Both are read synchronously at startup before the first frame renders.
Error Handling

No internet — repositories check connectivity before every API call via connectivity_plus and return a NetworkFailure immediately
Slow API / timeout — Dio configured with 10-second connect and receive timeouts, mapped to a NetworkException with a specific timeout message
API failure — DioClient interceptor maps every HTTP error and DioException type to typed Failure classes shown as a full-screen error widget with a retry button
Empty response — explicit empty state check after every successful fetch, rendered as a distinct empty UI separate from errors
Pagination failure — error is shown as a bottom banner on the existing list (list stays intact) with an inline retry button, rather than replacing the whole screen

Architecture
Clean Architecture with three layers: domain (entities, repository contracts, use cases — zero Flutter dependencies), data (models, remote/local datasources, repository implementations), and presentation (BLoCs, pages, widgets). All dependencies are wired via get_it in a single injection_container.dart. All imports use package:taghyeer_app/... style to avoid IDE path resolution issues.

## Getting Started

