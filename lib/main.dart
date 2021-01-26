import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dersAdi;
  int dersKredi = 1;
  double dersHarfDegeri = 4;
  double ortalama=0.0;
  static int sayac=1;
  List<Ders> tumDersler;
  var formKey=GlobalKey<FormState>(); // oluşturulan formKey Form widgetin içine key:formKey, olarak atanmazsa çalışmaz
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumDersler=[];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Ortalama Hesapla"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(formKey.currentState.validate()) {
            formKey.currentState.save();
          }
          else print("object");
            },
        child: Icon(Icons.add),
      ),
      body: uygulamaGovdesi(),
    );
  }

  uygulamaGovdesi() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: Form(
              key: formKey, // key olarak atanmazsa çalışmaz
                child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Ders Adı",
                    labelStyle: TextStyle(fontSize: 23,color: Colors.black),
                    hintText: "Ders adı giriniz",
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  validator: (girilenDeger) {
                    if (girilenDeger.length > 0) {
                      return null;
                    } else
                      return "Ders Adı Boş Bırakılamaz";
                  },
                  onSaved: (kaydedilecekDeger) {
                    dersAdi = kaydedilecekDeger;
                    setState(() {
                      tumDersler.add(Ders(dersAdi, dersHarfDegeri, dersKredi));
                      ortalama=0;
                      ortalamayiHesapla();
                    });

                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          child: DropdownButton(
                            items: dersKredileriItems(),
                            value: dersKredi,
                            onChanged: (secilenKredi) {
                              setState(() {
                                dersKredi = secilenKredi;
                              });
                            },
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          margin: EdgeInsets.only(top: 10,right: 50),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        Container(
                          child: Center(
                            child: RichText( // yanyana iki Text her texte ayrı özellikler vermek için kullanılır
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children:[
                                  TextSpan(
                                    text:tumDersler.length==0? "Lütfen Ders Ekle : ": "Ortalama : ",style: TextStyle(fontSize: 22,color: Colors.grey.shade700,),
                                  ),
                                  TextSpan(
                                    text:tumDersler.length==0? "": "${ortalama.toStringAsFixed(2)}",style: TextStyle(fontSize: 24,color: Colors.black,fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Container(

                      child: DropdownButton( elevation: 50,
                        items: dersHarfDegerleriItems(),
                        value: dersHarfDegeri,
                        onChanged: (secilenHarf) {
                          setState(() {
                            dersHarfDegeri = secilenHarf;
                          });
                        },
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                    )
                  ],
                ),

              ],
            )),
          ),


          Expanded(
            child: Container(
              color: Colors.lightBlue.shade100,
              child: ListView.builder(itemBuilder: listeElemanlariniOlustur,itemCount: tumDersler.length,),
            ),
          ),
        ],
      ),
    );
  }

  dersKredileriItems() {
    List<DropdownMenuItem<int>> krediler = [];
    for (int i = 1; i < 10; i++) {
      krediler.add(
        DropdownMenuItem(
          child: Text(
            "$i Kredi",
            style: TextStyle(fontSize: 21),
          ),
          value: i,
        ),
      );
    }
    return krediler;
  }

  dersHarfDegerleriItems() {
    List<DropdownMenuItem<double>> harler = [];
    harler.add(
      DropdownMenuItem(
        child: Text(
          "AA",
          style: TextStyle(fontSize: 22),
        ),
        value: 4,
      ),
    );
    harler.add(
      DropdownMenuItem(
        child: Text(
          "BA",
          style: TextStyle(fontSize: 20),
        ),
        value: 3.5,
      ),
    );
    harler.add(
      DropdownMenuItem(
        child: Text(
          "BB",
          style: TextStyle(fontSize: 20),
        ),
        value: 3,
      ),
    );
    harler.add(
      DropdownMenuItem(
        child: Text(
          "CB",
          style: TextStyle(fontSize: 20),
        ),
        value: 2.5,
      ),
    );
    harler.add(
      DropdownMenuItem(
        child: Text(
          "CC",
          style: TextStyle(fontSize: 20),
        ),
        value: 2,
      ),
    );
    harler.add(
      DropdownMenuItem(
        child: Text(
          "DC",
          style: TextStyle(fontSize: 20),
        ),
        value: 1.5,
      ),
    );
    harler.add(
      DropdownMenuItem(
        child: Text(
          "DD",
          style: TextStyle(fontSize: 20),
        ),
        value: 1,
      ),
    );
    harler.add(
      DropdownMenuItem(
        child: Text(
          "FF",
          style: TextStyle(fontSize: 20),
        ),
        value: 0,
      ),
    );
    return harler;
  }

  Widget listeElemanlariniOlustur(BuildContext context, int index) {
    sayac++;
  return Dismissible( // Listemizde soldan sağa doğru kaydırma yaptığımızda var olan indexteki eleman silinecek
    key: Key(sayac.toString()),
    direction: DismissDirection.startToEnd, // silme yönü seçilir
    onDismissed: (direction){
      setState(() {
        tumDersler.removeAt(index); // silme işlemi olunca var olan indexteki eleman silinsin
        ortalamayiHesapla();
      });
    },
    child: Column(

      children: [

        Card(

          elevation: 20,
          child: Column(

            children: [

              ListTile(
                onTap: (){},
                title: Text(tumDersler[index].ad),
                subtitle: Text(tumDersler[index].kredi.toString()+" Kredi Ders Not Değeri : "+tumDersler[index].harfDegeri.toString()),

              ),
              Row(
                children: [
                  SizedBox(width: 150,),
                  Icon(Icons.arrow_forward_ios,color: Colors.lightBlue.shade900,),
                  Icon(Icons.delete,color:Colors.red,),

                ],
              ),
            ],

          ),

        ),
      ],
    ),
  );

  }

  void ortalamayiHesapla() { // derslerin toplamından yola çıkılarak ortalama bılma işlemi
    double toplamNot=0;
    double toplamKredi=0;

    for(var oAnkiDers in tumDersler) { // tüm listeyi dolaşıp değerleri toplayıp ortalamasını buluyorum

      var kredi=oAnkiDers.kredi;
      var harfDegeri =oAnkiDers.harfDegeri;

      toplamNot=toplamNot+(harfDegeri*kredi);
      toplamKredi+=kredi;
    }
    ortalama=toplamNot/toplamKredi;
  }
}


class Ders{
  String ad;
  double harfDegeri;
  int kredi;
  Ders(this.ad,this.harfDegeri,this.kredi);
}
