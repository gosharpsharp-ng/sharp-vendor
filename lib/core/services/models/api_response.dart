import 'dart:convert';

class APIResponse {
  String status;
  String message;
  dynamic data;
  APIResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {'success': status, 'message': message, 'data': data};
  }

  factory APIResponse.fromMap(Map<String, dynamic> map) {
    String message = map['message'] ?? "";

    // If there are validation errors, extract the first error and append to message
    if (map.containsKey('errors') && map['errors'] != null) {
      try {
        Map<String, dynamic> errors = map['errors'] as Map<String, dynamic>;
        if (errors.isNotEmpty) {
          // Get the first error field
          String firstField = errors.keys.first;
          dynamic firstError = errors[firstField];

          // Extract the error message (could be a list or string)
          String errorMessage = '';
          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError[0].toString();
          } else if (firstError is String) {
            errorMessage = firstError;
          }

          // Append to message if we have an error message
          if (errorMessage.isNotEmpty) {
            if (message.isNotEmpty) {
              message = '$message $errorMessage';
            } else {
              message = errorMessage;
            }
          }
        }
      } catch (e) {
        // If parsing fails, fallback to the original message or errors object
        message = message.isEmpty ? (map['errors']?.toString() ?? "") : message;
      }
    }

    return APIResponse(
      status: map['status'] ?? "",
      message: message,
      data: map['data'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory APIResponse.fromJson(String source) =>
      APIResponse.fromMap(json.decode(source));
}
