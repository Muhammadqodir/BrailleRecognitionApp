# Authentication Feature - Implementation Guide

## Overview
The authentication feature has been implemented following **Clean Architecture** principles using **BLoC** for state management and **Dio** for networking.

## Architecture

### Clean Architecture Layers

```
lib/
├── core/                           # Shared core functionality
│   ├── constants/
│   │   └── api_constants.dart      # API endpoints and constants
│   ├── error/
│   │   ├── exceptions.dart         # Exception classes
│   │   └── failures.dart           # Failure classes (for Either)
│   ├── network/
│   │   └── dio_client.dart         # Dio HTTP client with interceptors
│   └── storage/
│       └── secure_storage_helper.dart  # Secure token storage
│
└── features/
    └── auth/
        ├── data/                   # Data Layer
        │   ├── datasources/
        │   │   └── auth_remote_data_source.dart
        │   ├── models/
        │   │   └── user_model.dart
        │   ├── repositories/
        │   │   └── auth_repository_impl.dart
        │   └── services/
        │       ├── apple_signin_service.dart
        │       └── google_signin_service.dart
        │
        ├── domain/                 # Domain Layer
        │   ├── entities/
        │   │   └── user.dart
        │   ├── repositories/
        │   │   └── auth_repository.dart
        │   └── usecases/
        │       ├── apple_signin_usecase.dart
        │       ├── get_current_user_usecase.dart
        │       ├── google_signin_usecase.dart
        │       ├── login_usecase.dart
        │       ├── logout_usecase.dart
        │       └── register_usecase.dart
        │
        └── presentation/           # Presentation Layer
            ├── bloc/
            │   ├── auth_bloc.dart
            │   ├── auth_event.dart
            │   └── auth_state.dart
            ├── login_page.dart
            └── register_page.dart
```

## Features Implemented

### ✅ Email & Password Authentication
- User registration with email and password
- User login with email and password
- Password confirmation validation

### ✅ Social Authentication
- Google Sign-In
- Apple Sign-In (iOS only)

### ✅ Session Management
- Secure token storage using `flutter_secure_storage`
- Automatic token injection in API requests
- Auto logout on 401 responses

### ✅ State Management
- BLoC pattern for clean state management
- Proper loading, success, and error states

## Dependencies Added

```yaml
# State Management
flutter_bloc: ^8.1.6
equatable: ^2.0.5

# Networking
dio: ^5.7.0

# Functional Programming
dartz: ^0.10.1

# Dependency Injection
get_it: ^8.0.2

# Secure Storage
flutter_secure_storage: ^9.2.2

# Social Authentication
google_sign_in: ^6.2.2
sign_in_with_apple: ^6.1.3
```

## Configuration Required

### 1. Update API Base URL
Edit `lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = 'https://your-domain.com/api';
```

### 2. Configure Google Sign-In

#### Android
1. Add Google Services configuration file to `android/app/google-services.json`
2. Make sure SHA-1 fingerprint is registered in Firebase Console

#### iOS
1. Add `GoogleService-Info.plist` to `ios/Runner/`
2. Update `ios/Runner/Info.plist` with URL scheme

### 3. Configure Apple Sign-In (iOS)

1. Enable Sign in with Apple capability in Xcode
2. Add to `Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>your-bundle-id</string>
        </array>
    </dict>
</array>
```

## Usage

### 1. Initialize Dependency Injection
Already configured in `main.dart`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}
```

### 2. Wrap App with BlocProvider
Already configured in `main.dart`:
```dart
BlocProvider(
  create: (context) => di.sl<AuthBloc>(),
  child: MaterialApp(...)
)
```

### 3. Use Authentication in Pages

#### Login
```dart
context.read<AuthBloc>().add(
  LoginRequested(
    email: email.text,
    password: password.text,
  ),
);
```

#### Register
```dart
context.read<AuthBloc>().add(
  RegisterRequested(
    name: name.text,
    email: email.text,
    password: password.text,
    passwordConfirmation: password.text,
  ),
);
```

#### Google Sign-In
```dart
context.read<AuthBloc>().add(const GoogleSignInRequested());
```

#### Apple Sign-In
```dart
context.read<AuthBloc>().add(const AppleSignInRequested());
```

#### Logout
```dart
context.read<AuthBloc>().add(const LogoutRequested());
```

### 4. Listen to Auth State

```dart
BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      // Navigate to home page
      Navigator.pushReplacement(...);
    } else if (state is AuthError) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  builder: (context, state) {
    final isLoading = state is AuthLoading;
    // Build UI based on state
  },
)
```

## API Integration

The implementation follows the API documentation in `API_DOCS/auth_api.md`:

- ✅ `POST /api/auth/register` - User registration
- ✅ `POST /api/auth/login` - User login  
- ✅ `POST /api/auth/google` - Google sign-in
- ✅ `POST /api/auth/apple` - Apple sign-in
- ✅ `GET /api/auth/me` - Get current user
- ✅ `POST /api/auth/logout` - Logout user

## Security Features

1. **Secure Token Storage**: Uses `flutter_secure_storage` for token persistence
2. **Automatic Token Injection**: Dio interceptor automatically adds Bearer token to requests
3. **Auto Logout on Unauthorized**: 401 responses automatically clear tokens
4. **Error Handling**: Comprehensive error handling for network, validation, and server errors

## Error Handling

The following error types are handled:
- `NetworkFailure` - Network connection issues
- `ServerFailure` - Server errors (5xx)
- `ValidationFailure` - Validation errors (422)
- `UnauthorizedFailure` - Authentication errors (401)
- `AuthFailure` - Social auth failures

## Next Steps

### TODO Items in Code:
1. Navigate to home page after successful authentication
2. Implement forgot password flow  
3. Add email validation
4. Add password strength validation
5. Implement refresh token mechanism
6. Add biometric authentication support

### Testing:
1. Write unit tests for use cases
2. Write unit tests for BLoC
3. Write widget tests for auth pages
4. Write integration tests for auth flow

## Testing the Implementation

1. **Start your backend server** with the API endpoints implemented
2. **Update the base URL** in `api_constants.dart`
3. **Run the app**: `flutter run`
4. **Test authentication flows**:
   - Email/Password registration
   - Email/Password login
   - Google Sign-In
   - Apple Sign-In (iOS only)

## Troubleshooting

### Common Issues:

1. **Connection refused**: Update `baseUrl` in `api_constants.dart`
2. **Google Sign-In not working**: Check SHA-1 fingerprint in Firebase
3. **Apple Sign-In not working**: Ensure capability is enabled in Xcode
4. **Token not persisting**: Check secure storage permissions

## Architecture Benefits

✅ **Testability**: Each layer can be tested independently  
✅ **Maintainability**: Clear separation of concerns  
✅ **Scalability**: Easy to add new features  
✅ **Reusability**: Core functionality can be reused  
✅ **Type Safety**: Strong typing with Dart  
✅ **Error Handling**: Functional error handling with `Either`  

## References

- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Dio Documentation](https://pub.dev/packages/dio)
