import 'package:flutter/foundation.dart';
import 'package:rider_apna_rickshaw/Models/adress.dart';

class AppData extends ChangeNotifier
{
  Address? pickUpLocation;
  void updatePickUpLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }
}