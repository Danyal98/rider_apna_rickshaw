import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_apna_rickshaw/AllWidgets/Divider.dart';
import 'package:rider_apna_rickshaw/Assistants/requestAssistant.dart';
import 'package:rider_apna_rickshaw/DataHandler/appData.dart';
import 'package:rider_apna_rickshaw/Models/placePredictions.dart';
import 'package:rider_apna_rickshaw/configMaps.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();

  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {

    String placeAddress = Provider.of<AppData>(context).pickUpLocation!.placeName;
    pickUpTextEditingController.text = placeAddress;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(height: 30.0,),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back
                        ),
                      ),
                      Center(
                        child: Text("Select Drop Off", style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.0,),
                  Row(
                    children: [
                      Image.asset("images/pickicon.png", height: 25.0, width: 25.0,),
                      SizedBox(width: 18.0,),
                      Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                controller: pickUpTextEditingController,
                                decoration: InputDecoration(
                                  hintText: "Pickup Location",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                                ),
                              ),
                            ),
                          ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Image.asset("images/desticon.png", height: 25.0, width: 25.0,),
                      SizedBox(width: 18.0,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val)
                              {
                                findPlace(val);
                              },
                              controller: dropOffTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Dropoff Location",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //tile for displaying places
          (placePredictionList.length > 0)
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListView.separated(
                      itemBuilder: (context, index){
                        return PredictionTile(placePredictions: placePredictionList[index],);
                      },
                      separatorBuilder: (BuildContext context, int index) => DividerWidget(),
                      itemCount: placePredictionList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                  ),
                )
              :Container(),
        ],
      ),
    );
  }

  void findPlace(String placeName) async
  {
    if(placeName.length > 1){
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=123456789&components=country:pk";

      Uri uri = Uri.parse(autoCompleteUrl);
      var res = await RequestAssistant.getRequest(uri);

      if(res == "failed"){

        return;
      }

      if(res["status"] == "OK")
      {
        var predictions = res["predictions"];

        var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();

        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget
{

  final PlacePredictions? placePredictions;
  PredictionTile({Key? key, this.placePredictions}) : super(key: key);
  // const PredictionTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Container(
      child: Column(
        children: [
          SizedBox(width: 10.0,),
          Row(
            children: [
              Icon(Icons.add_location),
              SizedBox(width: 14.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(placePredictions!.main_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),),
                    SizedBox(height: 3.0,),
                    Text(placePredictions!.secondary_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color: Colors.grey),),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 10.0,),
        ],
      ),
    );
  }
}
