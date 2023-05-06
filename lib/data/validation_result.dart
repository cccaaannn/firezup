class ValidationResult {
  ValidationResult(this._valid, this._message);

  final bool _valid;
  final String? _message;

  bool isValid() {
    return _valid;
  }

  String? getMessage() {
    return _message;
  }
}
