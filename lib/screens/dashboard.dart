import 'package:admin_toutn/screens/widgets/colors_cons.dart';
import 'package:admin_toutn/screens/widgets/events_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_toutn/core/controller/form_controller.dart';
import 'event_form.dart';
import 'event_modify.dart';
import 'notification_form.dart';

class DashboardScreen extends StatefulWidget {
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder<FormController>(builder: (_) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xffc16161),
            child: Icon(
              Icons.notifications_active,
              color: Colors.white,
            ),
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotifScreen()));
            },
          ),
          backgroundColor: Color(0xfff9f9f9),
          appBar: AppBar(
            backgroundColor: Color(0xfff9f9f9),
            elevation: 0.0,
            centerTitle: true,
            title: Text(
              'liste des événements',
              style: TextStyle(color: Color(0xffc16161)),
            ),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
                  //padding: EdgeInsets.all(defaultPadding),
                  child: Container(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 3,
                                padding: EdgeInsets.only(right: 30),
                                child: TextField(
                                  onChanged: (val) {
                                     _.setQuery(val);
                                  },
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    hintText: "recherche",
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey[200]!,
                                          width: 0.5,
                                          style: BorderStyle.none),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                         _.setQuery(searchController.text);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Color(0xffc16161)
                                              .withOpacity(0.2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Icon(
                                          Icons.search,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    /*  placecontroller.setMonumentUpdate([]);
                                            placecontroller.setImagesUpdate([]);
                                            placecontroller.setImages360Update([]);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => AddOneSite(
                                                      update: false,
                                                    )));*/
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FormEventScreen()));
                                  },
                                  child: Material(
                                    shadowColor: Colors.grey,
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    color: Colors.lightBlue,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: 150,
                                      child: Text(
                                        'Ajouter un événement',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                        SizedBox(
                          height: 20,
                        ),
                        _.query.isEmpty
                            ?  FutureBuilder(
                            future: _.getEvents(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasError)
                                return Text(snapshot.error.toString());
                              if (snapshot.hasData) {
                                print("list length" +
                                    snapshot.data.length.toString());
                                return EventTable(events: _.eventsList,);
                                /*  return ListView.builder(
                      itemCount: _.eventsList.length,
                      itemBuilder: (context, index) {
                        return Container(
                            height: 100,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FormEventModifyScreen(
                                              event: _.eventsList[index],
                                            )));
                              },
                              child: ListTile(
                                leading: Container(
                                  height: MediaQuery.of(context).size.width / 4,
                                  width: MediaQuery.of(context).size.width / 4,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                        )
                                      ],
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            _.eventsList[index].image,
                                          ),
                                          fit: BoxFit.cover)),
                                ),
                                title: Text(
                                  _.eventsList[index].title_en,
                                  style: TextStyle(
                                      color: Color(0xffc16161),
                                      fontFamily: 'Questrial',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  _.eventsList[index].location_en,
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontFamily: 'Questrial',
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                trailing: GestureDetector(
                                  onTap: () async {
                                    await _.removeEvent(_.eventsList[index].id);
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Color(0xffc16161),
                                    size: 30,
                                  ),
                                ),
                              ),
                            ));
                      });*/
                              } else
                                return Center(
                                    child: CircularProgressIndicator());
                            }):EventTable(
                          events: _.eventsList
                              .where((element) =>
                          (element.title_en.toLowerCase().contains(
                              _.query) ||
                              element.title_fr.toLowerCase().contains(
                                  _.query) ||
                              element.title_ar.toLowerCase().contains(
                                  _.query)))
                              .toList(),
                        )
                      ])))));
    });
  }
}
