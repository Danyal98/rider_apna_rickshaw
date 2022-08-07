import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rider_apna_rickshaw/Assistants/requestAssistant.dart';
import 'package:rider_apna_rickshaw/DataHandler/appData.dart';
import 'package:rider_apna_rickshaw/Models/adress.dart';
import 'package:rider_apna_rickshaw/configMaps.dart';

class AssistantMethods
{
  static Future<String> searchCoordinateAddress(Position position, context) async
  {
    String placeAddress = "";
    String st1, st2, st3, st4 = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${mapKey}";
    Uri uri = Uri.parse(url);
    var response = await RequestAssistant.getRequest(uri);
    if(response != "failed"){
      // placeAddress = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][1]["long_name"];
      st2 = response["results"][0]["address_components"][2]["long_name"];
      st3 = response["results"][0]["address_components"][3]["long_name"];
      st4 = response["results"][0]["address_components"][4]["long_name"];
      placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;

      Address userPickUpAddress = new Address(placeFormattedAddress: "", placeName: "", placeId: "", latitude: 0.0, longitutde: 0.0);
      userPickUpAddress.placeName = placeAddress;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.longitutde = position.longitude;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }
}