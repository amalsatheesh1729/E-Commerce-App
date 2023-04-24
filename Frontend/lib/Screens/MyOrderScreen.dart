import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_online_store/DRY.dart';
import 'package:simple_online_store/Models/DTO.dart';
import 'package:simple_online_store/Providers/UserProvider.dart';
import 'package:simple_online_store/Services/orderServices.dart';

class MyOrderScreen extends StatefulWidget {
   MyOrderScreen({Key? key}) : super(key: key);

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  List<OrderModel> myorders=[];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(context.mounted)
      getOrders(context);
  }



  Future<void> getOrders(BuildContext context) async {
    final userId = context.read<UserProvider>().userModel!.userId;
    myorders = await getOrdersOfUser(userId!);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    return
    Scaffold(
      appBar: const AppBarCommon(),
        body:Container(
        width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: const BoxDecoration(
    image: DecorationImage(
    fit: BoxFit.cover,
    image: AssetImage("./lib/assets/cover3.jpg")),
    ),
    child: Container(
    margin: EdgeInsets.symmetric(
    horizontal:MediaQuery.of(context).size.width>=600?MediaQuery.of(context).size.width / 5:1,
    vertical: MediaQuery.of(context).size.height / 15),
    decoration: BoxDecoration(
    border: Border.all(width: 1, color: Colors.purple),
    borderRadius: BorderRadius.circular(60)),
    child: myorders.isEmpty?Center(child: const Text('Looks like you have not  placed an Order yet !!!!!!' ,style: TextStyle(
      color: Colors.red,
      fontSize: 20,
      fontWeight: FontWeight.w200
    ),)):ListView.builder(
    itemCount: myorders.length,
    itemBuilder: (context,index){
      return Card(
        margin: const EdgeInsets.all(25),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               Text('Order Id : ${myorders[index].orderId}'),
    const SizedBox(height: 10),
    Text('Order Status: ${myorders[index].orderstatus}'),
               const SizedBox(height: 10),
    Text('Order Total Value: ${myorders[index].totalordervalue}')
             ],
         ),
      );
    })
    )));
  }
}
