import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'NavigationDrawer.dart';
import 'commonClasses/utilities.dart';
import 'classes/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Praeceptor',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 145, 200, 245)),
        ),
        home: Login(),
      ),
    );
  }
}

Future<String?> getJWT() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('JWT');
}

class MyAppState extends ChangeNotifier {}

Future<void> storeUserInfo(String username, String JWT) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString('username', username);
  prefs.setString('JWT', JWT);
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoggedIn = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> LoginFunction() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client
        .postUrl(Uri.parse("https://localhost:7097/api/Register/Login"));
    request.headers.set('Content-Type', 'application/json');
    final Map<String, String> requestBody = {
      'NumeUtilizator': usernameController.text,
      'Parola': passwordController.text,
    };
    final requestBodyJson = jsonEncode(requestBody);
    request.headers
        .set('Content-Length', utf8.encode(requestBodyJson).length.toString());
    request.write(requestBodyJson);
    HttpClientResponse result = await request.close();
    print(result.statusCode);
    if (result.statusCode == 200) {
      isLoggedIn = true;
      String responseBody = await result.transform(utf8.decoder).join();
      Map<String, dynamic> responseJson = jsonDecode(responseBody);
      String jwtToken = responseJson['token'];
      storeUserInfo(usernameController.text, jwtToken);
      print('JWT TOKEN: $jwtToken');
    } else
      isLoggedIn = false;
    print(isLoggedIn);
  }

  @override
  Widget build(BuildContext build) {
  return Scaffold(
    body: Container(
      color: const Color.fromARGB(255, 192, 218, 244),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(build).size.width * 0.75,
            child: Column(
              children: [
                const Text('Praeceptor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 70.0),
                FilledTextField(
                  controller: usernameController,
                  icon: Icon(Icons.person),
                  labelText: 'Username',
                  hintText: 'Enter username..',
                ),
                const SizedBox(height: 30.0),
                FilledTextField(
                  controller: passwordController,
                  icon: Icon(Icons.password),
                  labelText: 'Password',
                  hintText: 'Enter password..',
                  askMask: true
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: () async {
                    await LoginFunction();
                    if (isLoggedIn) {
                      NotificationService().ShowNotification(title: 'Welcome back!',body: 'We prepared some courses for you!');
                      username = usernameController.text;
                      Navigator.push(
                        build,
                        MaterialPageRoute(builder: (context) => Homepage()),
                      );
                    } else
                      showSnackBar(build);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(400.0, 50.0),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      build,
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(400.0, 50.0),
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('Login unsuccessful!'),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Retry',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class DropdownForm extends StatefulWidget {
  final String initialValue;
  final List<String> items;
  final String labelText;

  const DropdownForm({
    Key? key,
    required this.initialValue,
    required this.items,
    required this.labelText,
  }) : super(key: key);

  @override
  DropdownFormState createState() => DropdownFormState();
}

class DropdownFormState extends State<DropdownForm> {
  late String selectedCountry;

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText),
        DropdownButtonFormField<String>(
          value: selectedCountry,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedCountry = newValue;
              });
            }
          },
          items: widget.items.map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

//ignore: must_be_immutable
class Register extends StatelessWidget {
  final TextEditingController NumeUtilizator = TextEditingController();
  final TextEditingController Parola = TextEditingController();
  final TextEditingController ParolaConfirma = TextEditingController();
  final TextEditingController Prenume = TextEditingController();
  final TextEditingController NumeFamilie = TextEditingController();
  final TextEditingController NrTelefon = TextEditingController();
  final TextEditingController AdresaMail = TextEditingController();
  final TextEditingController Tara = TextEditingController();
  final TextEditingController Adresa = TextEditingController();
  final String selectedCountry =
      'Romania'; 
  final List<String> countries = [
    'Romania',
    'Other Country 1',
    'Other Country 2'
  ];
  DateTime birthday = DateTime.now();
  final String NivelEducational = 'ISCED1';
  final List<String> NiveluriEducationale = [
    'ISCED1',
    'ISCED2',
    'ISCED3',
    'ISCED4',
    'ISCED5',
    'ISCED6',
    'ISCED7',
    'ISCED8'
  ];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<DropdownFormState> countryKey =
      GlobalKey<DropdownFormState>();
  final GlobalKey<DropdownFormState> educationLevelKey =
      GlobalKey<DropdownFormState>();

  Future<void> registerUser() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client
        .postUrl(Uri.parse("https://localhost:7097/api/Register/register-student"));
    request.headers.set('Content-Type', 'application/json');
    request.add(utf8.encode(jsonEncode(<String, String>{
      'NumeUtilizator': NumeUtilizator.text,
      'Parola': Parola.text,
      'Prenume': Prenume.text,
      'NumeFamilie': NumeFamilie.text,
      'NrTelefon': NrTelefon.text,
      'AdresaMail': AdresaMail.text,
      'Tara': countryKey.currentState!.selectedCountry,
      'Adresa': Adresa.text,
      'DataNasterii': birthday.toIso8601String(),
      'NivelEducational': educationLevelKey.currentState!.selectedCountry,
    })));
    HttpClientResponse result = await request.close();
    if (result.statusCode == 200) {
      return jsonDecode(await result.transform(utf8.decoder).join());
    } else {
      return null;
    }
  }

  void updateBirthdayDate(DateTime date) {
    // Callback function to update the selected date
    birthday = date;
  }

  @override
  Widget build(BuildContext build) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Registration'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(build);
            },
          ),
        ),
        body: Container(
          color: const Color.fromARGB(255, 192, 209, 244),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(build).size.width * 0.75,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 25.0),
                      ProfilePicture(),
                      const SizedBox(height: 25.0),
                      FilledTextField(controller: NumeUtilizator, icon: Icon(Icons.person), labelText: 'Username', hintText: 'Enter username..'),

                     // TextInput(controller: NumeUtilizator, labelText: 'Username', maskText: false),
                      const SizedBox(height: 10),
                      FilledTextField(controller: Parola, icon: Icon(Icons.password), labelText: 'Password', hintText: 'Enter password..', askMask: true),
                      //TextInput(controller: Parola, labelText: 'Password', maskText: true),
                      FilledTextField(controller: ParolaConfirma, icon: Icon(Icons.password), labelText: 'Confirm password', hintText: 'Confirm password..', askMask: true),
                      //TextInput(controller: ParolaConfirma, labelText: 'Confirm Password', maskText: true),
                      const SizedBox(height: 10),
                      FilledTextField(controller: Prenume, icon: Icon(Icons.person), labelText: 'First Name', hintText: 'Enter your first name..'),
                      //TextInput(controller: Prenume, labelText: 'First Name', maskText: false),
                      const SizedBox(height: 10),
                      FilledTextField(controller: NumeFamilie, icon: Icon(Icons.person), labelText: 'Last Name', hintText: 'Enter your last name..'),
                      //TextInput(controller: NumeFamilie, labelText: 'Last Name', maskText: false),
                      const SizedBox(height: 10),
                      FilledTextField(controller: AdresaMail, icon: Icon(Icons.email), labelText: 'Email address', hintText: 'Enter your email address..'),
                      //TextInput(controller: AdresaMail, labelText: 'Email address', maskText: false),
                      const SizedBox(height: 10),
                      FilledTextField(controller: NrTelefon, icon: Icon(Icons.phone), labelText: 'Phone number', hintText: 'Enter your phone number..'),
                      //TextInput(controller: NrTelefon, labelText: 'NrTelefon', maskText: false),
                      const SizedBox(height: 20),
                      const Text('Date of birth:'),
                      DateTimePicker(onDateSelected: updateBirthdayDate),
                      const SizedBox(height: 30),
                      const Text('Country:'),
                      DropdownForm(
                        key: countryKey,
                        initialValue: 'Romania',
                        items: countries,
                        labelText: 'Tara',
                      ),
                      const SizedBox(height: 10),
                      FilledTextField(controller: Adresa, icon: Icon(Icons.pin_drop), labelText: 'Address', hintText: 'Enter your address..'),
                      //TextInput(controller: Adresa, labelText: 'Adresa', maskText: false),
                      const SizedBox(height: 30),
                      DropdownForm(
                        key: educationLevelKey,
                        initialValue: 'ISCED1',
                        items: NiveluriEducationale,
                        labelText: 'Educational Level',
                      ),
                      const SizedBox(height: 10),
                      CheckboxWidget(),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            fixedSize: const Size(400.0, 50.0)),
                        onPressed: () {
                          registerUser();
                          Navigator.pop(build);
                        },
                        child: const Text('Create account'),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CheckboxWidget extends StatefulWidget {
  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext build) {
    return CheckboxListTile(
      title: const Text('Agree to Terms and Conditions'),
      value: isChecked,
      onChanged: (newValue) {
        setState(() {
          isChecked = newValue ?? false;
        });
      },
      activeColor: Colors.blue,
    );
  }
}

class TextInput extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool maskText;
  TextInput(
      {required this.controller,
      required this.labelText,
      required this.maskText});

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.maskText,
      decoration: InputDecoration(
        labelText: widget.labelText,
      ),
    );
  }
}

class DateTimePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const DateTimePicker({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.onDateSelected(
            selectedDate); // Notify the parent about the selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${selectedDate.toLocal()}".split(' ')[0],
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              onPressed: () => _selectDate(context),
              child: const Text('Select date'),
            ),
          ],
        ),
      ],
    );
  }
}

class ProfilePicture extends StatefulWidget {
  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  XFile? _image;
  String imagePath1 = '';


  Future getImageFromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    String imagePath = '';
    if (image != null) imagePath = image.path;
    setState(() {
      _image = image;
      imagePath1 = imagePath;
    });
  }

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: () {
        //_showImagePickerDialog();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Container(
            width: 100.0,
            height: 100.0,
            color: Colors.blue,
            child: Image.network('https://cdn-icons-png.flaticon.com/512/1077/1077114.png'), 
//            _image != null
//                ? Image.file(
//                    File(imagePath1),
//                    fit: BoxFit.cover,
//                  )
//                : const Icon(
//                    Icons.camera_alt,
//                    size: 40.0,
//                    color: Colors.white,
//                  )),
      ),
      )
    );
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image'),
          content:
              const Text('Choose an option to upload your profile picture'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  getImageFromGallery();
                },
                child: const Text('Gallery')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Camera')),
          ],
        );
      },
    );
  }
}
