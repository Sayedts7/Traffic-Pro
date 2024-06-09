import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traffic_pro/ui/custom_widgets/dialogs/custom_dialog.dart';

class MyMarkers extends StatelessWidget {
  const MyMarkers({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('My Markers'),
        // leading: IconButton(onPressed: (){}, icon: icon),
      ),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('markers').snapshots(),
                builder: (context,  snapshot){
              if(snapshot.hasError){
                return Icon(Icons.error);
              }
              else if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }else if(snapshot.hasData){
                return ListView.builder(
                  shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.network(snapshot.data!.docs[index]['imageUrl'], width: 60,height: 60,),
                      title: Text(snapshot.data!.docs[index]['eventType']),
                      trailing: IconButton( icon: Icon(Icons.delete), onPressed: (){
                        showDeleteDialog(context, 'Are ou sure you want to delete this?', snapshot.data!.docs[index].id,
                            snapshot.data!.docs[index]['userId'], snapshot.data!.docs[index]['deleteCount'],
                            LatLng(23.3, 34.5), true );
                      },),
                    ),
                  );
                });
              }else{
                return Container();
              }
                })
          ],
        ),
      ),
    );
  }
}
