//login exceptions

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {} 

// register exceptions

class WeakPasswordAuthException implements Exception {} 

class EmailAlreadyInAuthException implements Exception {} 

class InvalidEmailAuthException implements Exception {} 

// generic exceptions

class GenericAuthException implements Exception {} 

// user not logged in exception

class UserNotLoggedInAuthException implements Exception {} 
