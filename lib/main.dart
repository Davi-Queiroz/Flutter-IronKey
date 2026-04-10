import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironkey/app_theme.dart';
import 'package:ironkey/password_generator.dart';
import 'package:ironkey/password_type_enum.dart';
import 'package:ironkey/pin_password_generator.dart';
import 'package:ironkey/standard_password_generator.dart';

void main() {
  runApp(const IronKeyApp());
}

class IronKeyApp extends StatelessWidget {
  const IronKeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: app_theme.lightTheme,
      darkTheme: app_theme.darkTheme,
      themeMode: ThemeMode.system,
      home: IronKeyScreen(),
    );
  }
}

class IronKeyScreen extends StatefulWidget {
  const IronKeyScreen({super.key});

  @override
  State<IronKeyScreen> createState() => _IronKeyScreenState();
}

class _IronKeyScreenState extends State<IronKeyScreen> {
  final TextEditingController _passowordController = TextEditingController();
  int maxCharacter = 12;
  bool isEditable=false;
  PasswordTypeEnum passwordTypeSelected = PasswordTypeEnum.pin;

  @override
  void initState() {
    super.initState();
    _passowordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _passowordController.dispose();
    super.dispose();
  }

  void copyPassword(String password) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Senha copiada!')));
  }

  void generatePassword() {
    final PasswordGenerator generator;
    switch (passwordTypeSelected) {
      case PasswordTypeEnum.pin:
        generator = PinPasswordGenerator();
        break;

      case PasswordTypeEnum.standard:
        generator = StandardPasswordGenerator();
        break;
    }

    setState(() {
      _passowordController.text = generator.generate(maxCharacter);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    final colorScheme=theme.colorScheme;


    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 150,
                        height: 200,
                        child: Image.asset("assets/images/spider-man.webp"),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Sentido Aranha Ativado",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Amazing_Aranha",
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passowordController,
                      style: TextStyle(fontFamily: "Spider_Eclipse"),
                      decoration: InputDecoration(
                        labelText: "Senha",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: _passowordController.text.isNotEmpty
                            //onde coloca o max length
                            ? IconButton(
                                onPressed: () {
                                  copyPassword(_passowordController.text);
                                },
                                icon: Icon(Icons.copy),
                              )
                            : null,
                      ),
                    ),
                    Text(
                      _passowordController.text,
                      style: TextStyle(fontFamily: "Homoarak"),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Tipo de senha"),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            value: PasswordTypeEnum.pin,
                            groupValue: passwordTypeSelected,
                            title: Text("PIN"),
                            onChanged: (value) {
                              setState(() {
                                passwordTypeSelected = value!;
                              });
                            },
                          ),
                        ),

                        Expanded(
                          child: RadioListTile(
                            value: PasswordTypeEnum.standard,
                            groupValue: passwordTypeSelected,
                            title: Text("Senha Padrão"),
                            onChanged: (value) {
                              setState(() {
                                passwordTypeSelected = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(color: colorScheme.outline,),
                    Row(children: [
                      Icon(isEditable?Icons.lock_open:Icons.lock),
                      SizedBox(width: 8,),
                      Expanded(child: Text(isEditable?"TRANCADO":"ABRIDO")),
                      Switch(value: isEditable, onChanged: (value){
                        setState(() {
                        isEditable=value;
                          
                        });
                      })
                    ],),
                  Divider(color: colorScheme.outline),
                  SizedBox(height: 20,),

///não ta travando
                  if(isEditable)
                  Text("Estou em modo de edição"),
                  ],
                ),
              ),
              
              Text(_passowordController.text),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: generatePassword,
                  child: Text("Gerar senha"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
