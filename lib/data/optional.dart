class Optional<T> {
  Optional(this._value);

  T? _value;

  bool exists() {
    return _value != null;
  }

  T? get() {
    return _value;
  }

  void set(T value) {
    _value = value;
  }

  T getOrDefault(T defaultVal) {
    return _value ?? defaultVal;
  }
}
