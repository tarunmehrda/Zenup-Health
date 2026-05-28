/// File: base_response.dart
/// Purpose: Defines a generic data holder wrapping outcomes of operations.
library shared;

class BaseResponse<T> {
  final T? data;
  final String? errorMessage;
  final bool isSuccess;

  const BaseResponse.success(this.data)
      : isSuccess = true,
        errorMessage = null;

  const BaseResponse.failure(this.errorMessage)
      : isSuccess = false,
        data = null;
}
