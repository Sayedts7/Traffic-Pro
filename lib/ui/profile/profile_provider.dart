import 'package:flutter/cupertino.dart';

class ProfileProvider extends ChangeNotifier {
  bool _obsecureText = true;

  bool get obsecureText => _obsecureText;

  setObsecureText(bool value) {
    _obsecureText = value;
    notifyListeners();
  }

  bool _editBtnClicked = true;
  bool get editBtnClicked => _editBtnClicked;

  setEditBtnClicked(bool value) {
    _editBtnClicked = value;
    notifyListeners();
  }

  bool _showLoader = false;

  bool get showLoader => _showLoader;

  changeShowLoaderValue(bool value) {
    _showLoader = value;
    notifyListeners();
  }
}
