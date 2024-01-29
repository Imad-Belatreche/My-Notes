//geniric exceptions

class GeniricAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

// login exceptions

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class UserDisabledAuthException implements Exception {}

class InvalidCredentialAuthException implements Exception {}

class NetworkRequestFailedAuthException implements Exception {}

class ChannelErrorAuthException implements Exception {}

// register exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// class ChannelErrorAuthException implements Exception {}