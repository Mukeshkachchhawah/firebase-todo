import 'package:flutter/foundation.dart';

class TodoProvider extends ChangeNotifier {
  List<Map<String, dynamic>> arrData = [];

  List<Map<String, dynamic>> get GetData => arrData;

  void AddData(Map<String, dynamic> mData) {
    arrData.add(mData);
    notifyListeners();
  }

  void DeletData(int index) {
    arrData.remove(index);
    notifyListeners();
  }

  void UpdateData(Map<String, dynamic> Update, int index){
    
  }
}