import 'package:flutter/cupertino.dart';

class EventTypeProvider with ChangeNotifier{
  String event = '';
  void updateEvent(String eventU){
   event = eventU;
   notifyListeners();
  }
}
