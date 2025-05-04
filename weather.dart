import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class weather extends StatefulWidget {
  const weather({super.key});

  @override
  State<weather> createState() => _weatherState();
}

class _weatherState extends State<weather> {
  String url = 'https://sugoi-api.vercel.app/weather?q=';
  dynamic data = {};

  void fetchData(String city) async {
    Uri apiurl = Uri.parse(url + city);
    http.Response response = await http.get(apiurl);
    String body = response.body;

    setState(() {
      data = json.decode(body);
      print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(29, 6, 51, 0.90),
          title: Text("Weather App", style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.amber))),
          centerTitle: true),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/weatherwall.png"),
                  opacity: 1,
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 16,
                      child: TextField(
                        onSubmitted: fetchData,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        decoration: InputDecoration(
                          prefix: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25)),
                          fillColor: Colors.transparent,
                          filled: true,
                          label: Text(
                            "Enter City",
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.6)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 280,
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 170,
                            height: 150,
                            decoration: BoxDecoration(
                                image: (data["current"] == null)
                                    ? null
                                    : DecorationImage(
                                        fit: BoxFit.contain,
                                        image: NetworkImage("https:" +
                                            data["current"]["condition"]
                                                ["icon"]))),
                          ),
                          if (data["current"] != null)
                            Text(
                              "${data["current"]["condition"]["text"]}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700),
                            )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          (data["current"] == null)
                              ? "..."
                              : "${data["current"]["temp_c"]}°C",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,)
              ,
              if (data["current"] != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildBox("${data["current"]["humidity"]} %", "Humidity"),
                  buildBox("${data["current"]["wind_kph"]} kmph" , "Wind Speed"),
                  buildBox("${data["current"]["feelslike_c"]} °C", "Feels Like"),
                ],
              ),
              SizedBox(height: 20,)
              ,
              if (data["current"] != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  buildBox("${data["current"]["dewpoint_c"]}°C ", "Dew Point"),
                  buildBox((data["current"]["uv"] < 0.3) ? "low" : (data["current"]["uv"] < 0.7) ? "Medium": "High" , "UV"),
                  buildBox("${data["current"]["precip_in"]}", "Precipitation"),
                ],
              ),
            ],
            
          )),
    );
  }

  Widget buildBox(String value, String key) {
    return Container(
      width: 125,
      height: 125,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w700)),
            Text(key,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w700)),


          ],
        ),
      ),
    );
  }
}
