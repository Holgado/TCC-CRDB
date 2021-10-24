class AppValues {
  late String _usertypeofModel;
  late String _label;
  late String _brand;
  late String _nameLastButtun;

  AppValues();

  AppValues.att(this._usertypeofModel, this._label, this._brand, this._nameLastButtun);

  String get usertypeofModel => _usertypeofModel;

  set usertypeofModel(String value) {
    _usertypeofModel = value;
  }

  String get label => _label;

  String get nameLastButtun => _nameLastButtun;

  set nameLastButtun(String value) {
    _nameLastButtun = value;
  }

  String get brand => _brand;

  set brand(String value) {
    _brand = value;
  }

  set label(String value) {
    _label = value;
  }

  @override
  String toString() {
    return 'AppValues{_usertypeofModel: , _label: $_label, _brand: $_brand, _nameLastButtun: $_nameLastButtun}';
  }
}