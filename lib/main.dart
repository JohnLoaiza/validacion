
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:validacion_telefono/valido.dart';
// import 'package:pybus_wallet/data/shared_preferences_helper.dart';
// import 'package:pybus_wallet/pages/Register.screen.dart';
import 'shared_preferences_helper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


void main() {
  runApp(MyHomePage());
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new validaPhone())
    );
  }
}















class validaPhone extends StatefulWidget {
  @override
  _validaPhoneState createState() => _validaPhoneState();
}

class _validaPhoneState extends State<validaPhone> {
  FirebaseUser _user;
  String _error = '';
  String codeCountry="+57";
  TextEditingController tele = new TextEditingController(text: "");
  String _message = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  String _verificationId;
  String _code;
  Color _colorbase =  Color(0xFF011C74);
  bool _onEditing = true;
  bool isValidating =false;
  bool isLoggedInValid =false;
  bool visibleSend=false;
  int TimeToValid=0;
  int TimeCount=0;
  String miTelefo="";
  SharedPreferencesHelper shareHelper = new SharedPreferencesHelper();


  @override
  void initState() {
    _auth.setLanguageCode("es");

    GetDataPrev();
    super.initState();
  }

  Future GetDataPrev() async{
    TimeToValid     = await shareHelper.TimerValidaPhone();
    isLoggedInValid = await shareHelper.isLoggedInValid();
    miTelefo = await shareHelper.MiTelefono();

    user=await _auth.currentUser();



    if(isLoggedInValid!=null){}else{isLoggedInValid=false;}
    if(TimeToValid!=null){}else{TimeToValid=0;}
    int timeNow= new DateTime.now().millisecondsSinceEpoch;
    if(TimeToValid>0){
      TimeCount=((timeNow-TimeToValid)/1000).round();
    }
    tele.text=miTelefo;
    if(user!=null){
      print("****  Cerrando sessiones previas..");
      try {
        Navigator.of(context).pushAndRemoveUntil(
            new CupertinoPageRoute(
                builder: (BuildContext context) =>
                new MyHomePage()),(Route<dynamic> route) => false);
        // await _auth.signOut();
      }catch(erf){}
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text('Verificar numero'),
          ),
          body: ListView(
              children: <Widget>[
                Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: Column(
                          verticalDirection: VerticalDirection.down,
                          //  mainAxisSize: MainAxisSize.min,
                          children: <Widget>[

                            SizedBox(
                              height: 60,
                            ),
                            SizedBox(
                              height: 35,
                            ),

                            SizedBox(
                              height: 35,
                            ),
                            Container(

                                child:
                                IntrinsicHeight(
                                  child:
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[

                                      Container(
                                        width: MediaQuery.of(context).size.width*0.23,
                                        child:
                                        CountryCodePicker(

                                          onChanged: cargaCountry,
                                          hideMainText: false,
                                          textStyle:TextStyle(fontSize: 11) ,

                                          flagWidth: 16,
                                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                          initialSelection: 'CO',
                                          favorite: ['+57','CO'],
                                          // optional. Shows only country name and flag
                                          showCountryOnly: false,
                                          // optional. Shows only country name and flag when popup is closed.
                                          showOnlyCountryWhenClosed: false,
                                          // optional. aligns the flag and the Text left
                                          alignLeft: true,
                                          padding: EdgeInsets.only(left: 5),
                                        ),
                                      ),
                                      // ),
                                      Expanded(
                                          child:
                                          Container(
                                              padding: EdgeInsets.only(right: 5.0),
                                              child:
                                              TextField(
                                                controller: tele,
                                                //style: ,
                                                decoration: InputDecoration(

                                                    hintText: 'Numero de celular',

                                                    border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(50.0)
                                                        )
                                                    ),

                                                    filled: true,
                                                    hintStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Montserrat',
                                                        fontSize: 14

                                                    ),
                                                    contentPadding: EdgeInsets.only(right: 16,top: 16),
                                                    prefixIcon: Icon(Icons.phone)
                                                ),

                                                keyboardType: TextInputType.text,
                                              )
                                          )
                                      ),

                                    ],
                                  ),
                                )
                            ),

                            SizedBox(
                              height: 40,
                            ),

                            RaisedButton(

                              onPressed: () {

                                EnviaSMS(context);
                              },
                              color: Colors.green,
                              child: Container(
                                padding: EdgeInsets.only(top: 9),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                ),
                                width: 204,
                                height: 44,
                                child:
                                Row(
                                    children: <Widget>[
                                      isValidating?
                                      Text("Esperando Codigo.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.grey, fontSize: 13)
                                      ):
                                      Text(
                                        "Enviar SMS",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(color: Colors.white, fontSize: 14),
                                      ),isValidating?
                                      Padding(padding: EdgeInsets.only(left:16.0)):Container(),
                                      isValidating?
                                      CountdownFormatted(

                                        duration: Duration(seconds: TimeCount>0?TimeCount:120),
                                        onFinish: () {
                                          setState(() {
                                            isValidating=false;
                                            TimeCount=0;
                                            shareHelper.setTimeTovalid(0);

                                          });

                                          print('finished!');
                                        },
                                        builder: (BuildContext ctx, String remaining) {
                                          return Text(remaining,style: TextStyle(color: Colors.white),); // 01:00:00
                                        },
                                      ):Container()
                                    ]
                                ),
                              ),
                              shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            isValidating?
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(
                                  child: VerificationCode(
                                    textStyle: TextStyle(fontSize: 18.0, color: Colors.black),
                                    keyboardType: TextInputType.number,
                                    // in case underline color is null it will use primaryColor: Colors.red from Theme
                                    underlineColor: Colors.amber,
                                    itemSize: 40,
                                    length: 6,
                                    // clearAll is NOT required, you can delete it
                                    // takes any widget, so you can implement your design
                                    clearAll: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        'Limpiar',
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            decoration: TextDecoration.underline,
                                            color: Colors.blue[700]),
                                      ),
                                    ),
                                    onCompleted: (String value) {
                                      setState(() {

                                        _code = value;
                                        // visibleSend=true;
                                        _signInWithPhoneNumber(context);
                                      });
                                    },
                                    onEditing: (bool value) {
                                      setState(() {
                                        _onEditing = value;
                                      });
                                      if (!_onEditing) FocusScope.of(context).unfocus();
                                    },
                                  ),
                                )
                            ):
                            Container(),
                            visibleSend? RaisedButton(

                              onPressed: () {

                                _signInWithPhoneNumber(context);
                              },
                              color: Colors.white,
                              child: Container(
                                  padding: EdgeInsets.only(top:5),
                                  decoration: BoxDecoration(
                                    color: Color(0xff011C94),
                                  ),
                                  width: 160,
                                  height: 34,
                                  child:

                                  Text(
                                    "Enviar Codigo",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(color: Colors.white, fontSize: 13),
                                  )


                              ),
                              shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ):Container(),
                            Container(child: Text(_message))
                            // _getErrorText()

                          ],
                        ),
                      )
                    ]
                )
              ]

          )

      ),
    );
  }

  Widget _getMessage() {
    if (_user != null) {
      return
        Container(
            padding: EdgeInsets.only(left: 30,right: 30),
            child:
            Text(
              'El numero ${_user.phoneNumber ?? ''} ha sido verificado correctamente ',
              textAlign: TextAlign.center,
              style: TextStyle(

                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: _colorbase
              ),
            )
        );
    } else {
      return
        Container(
            padding: EdgeInsets.only(left: 30,right: 30),
            child:
            Text(
              'Primero vamos a validar el número de teléfono que deseas registrar!\n\n'+
                  'Enviaremos el código de verificación via SMS al siguiente Número!',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: _colorbase,

                  fontFamily: 'Montserrat'
              ),
            )
        );
    }
  }

  Widget _getErrorText() {
    if (_message?.isNotEmpty == true) {
      return Text(
        _message,
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: 13,
        ),
      );
    } else {
      return Container();
    }
  }



  void EnviaSMS(BuildContext context){
    if(isValidating){

    }else{
      setState(() {
        shareHelper.setMiTelefono(tele.text);
        isValidating=true;
        TimeCount=120;
        int timeNow= (new DateTime.now().millisecondsSinceEpoch);

        shareHelper.setTimeTovalid(timeNow+(120*1000));
        _verifyPhoneNumber(context);
      });
    }


  }


  void cargaCountry(CountryCode valor){
    codeCountry=valor.dialCode;

  }


  void _verifyPhoneNumber(BuildContext context) async {
    setState(() {
      _message = '';
    });


    /*    final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential phoneAuthCredential) {
        _auth.signInWithCredential(phoneAuthCredential);
        setState(() {
          //aca se almacena en BD.. local y remota..
          shareHelper.setMiTokenFirebase("");
          _message = 'Credencial de autenticación recibida: $phoneAuthCredential';
          print(_message);
        });
      };*/

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        print(authException);
        isValidating=false;
        TimeCount=0;
        _message =
        'Error en Verificación de numero telefonico. Code: ${authException
            .code}. Mensaje: ${authException.message}';
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      setState(() {
        _message =
        'Verificación de numero telefonico. Token ${verificationId}';
      });
      /* _scafol.showSnackBar(const SnackBar(
        content: Text('Please check your phone for the verification code.'),
      ));*/
      // MostrarAlertConfirmaCode(context);
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      setState(() {
        isValidating =false;

        _message =
        'Verificación de numero telefonico. Token ${verificationId}';
      });
      /*   Alert(
        context: context,
        style: AlertStyle(backgroundColor: Colors.white),
        title: "Tiempo Agotado",
        desc: "La validez del codigo generado a caducado, es necesario generar un nuevo codigo mediante el boton de 'Validar'",
          buttons: [
            DialogButton(
              color: Colors.blue,
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ]
      ).show();*/
      // isValidating=false;
      _verificationId = verificationId;
    };


    await _auth.verifyPhoneNumber(
        phoneNumber: codeCountry + " " + tele.text,
        timeout: const Duration(seconds: 120),
        //verificationCompleted: verificationCompleted,
        verificationCompleted: null,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

  }


  void _signInWithPhoneNumber(BuildContext contexte) async {
    print("Enviando codigo a firebase...");
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _code,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    print("*** currentUser"+currentUser.uid);
    print("*** userLogin"+user.uid);
    assert(user.uid == currentUser.uid);

    if (user != null) {
      setState(() {
        _message = 'Successfully signed in, uid: ' + user.uid;
        print(_message);
        shareHelper.setMiTokenFirebase(user.uid);
        shareHelper.setMiTelefono(tele.text);
        //Navigator.of(contexte).pushReplacementNamed('/registro');
      });
      Navigator.of(context).pushAndRemoveUntil(
          new CupertinoPageRoute(
              builder: (BuildContext context) =>
              new MyHomePage()),(Route<dynamic> route) => false);
      //Navigator.popAndPushNamed(context, '/registro');

      // Navigator.pushNamedAndRemoveUntil(context, '/registro', (Route<dynamic> route) => false);

    } else {
      setState(() {
        _message = 'Error, El codigo no es valido o ha caducado su tiempo de validez.';
        shareHelper.setMiTelefono("");
        print(_message);
        shareHelper.setMiTokenFirebase("");
        isValidating=false;
      });
    }

  }

}