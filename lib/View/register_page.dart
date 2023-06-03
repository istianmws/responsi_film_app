import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../Db/user_hive.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _validatorController = TextEditingController();

  bool _isErrorVisible = false;
  bool _isPasswordHidden = true;

  Future<void> _signup() async {
    // Ambil nilai dari input username dan password
    String username = _usernameController.text;
    String password = _passwordController.text;
    String validator = _validatorController.text;

    // Cek apakah user valid
    bool isUserValid = false;

    if (password == validator) {
      isUserValid = true;
    }

    if (isUserValid) {
      // Tambahkan user ke Hive
      await addUser(username, password);

      // Berhasil signup
      setState(() {
        _isErrorVisible = false;
      });
      // Navigasi ke halaman selanjutnya
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      // Gagal login
      setState(() {
        _isErrorVisible = true;
      });
    }

    // Mengatur ulang nilai controller _passwordController
    _passwordController = TextEditingController.fromValue(
      TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      ),
    );
  }

  Future<void> addUser(String username, String password) async {
    var box = await Hive.openBox<UserHive>('users');
    var user = UserHive()
      ..username = username
      ..password = password;
    await box.add(user);
  }

  String _getErrorText() {
    if (_usernameController.text.isEmpty && _passwordController.text.isEmpty) {
      return 'Username dan password belum diisi.';
    } else if (_usernameController.text.isEmpty) {
      return 'Username belum diisi.';
    } else if (_passwordController.text.isEmpty) {
      return 'Password belum diisi.';
    } else {
      return 'Periksa kembali username dan password Anda.';
    }
  }

  void printUserData() async {
    var box = await Hive.openBox<UserHive>('users');
    for (var i = 0; i < box.length; i++) {
      var user = box.getAt(i);
      print('User ${i + 1}:');
      print('Username: ${user?.username}');
      print('Password: ${user?.password}');
      print('---');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                //logo
                const Icon(
                  Icons.ac_unit_rounded,
                  size: 100,
                ),

                const SizedBox(height: 50),
                //welcome
                Center(
                  child: Text(
                    'Isi sesuai data anda',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle_outlined),
                    labelText: 'Masukkan Username',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: _isPasswordHidden,
                  decoration: InputDecoration(
                    labelText: 'Masukkan Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                      child: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _validatorController,
                  obscureText: _isPasswordHidden,
                  decoration: InputDecoration(
                    labelText: 'Validasi Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                      child: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _signup,
                  child: Text('Sign Up'),
                ),
                SizedBox(height: 16.0),
                Visibility(
                  visible: _isErrorVisible,
                  child: Center(
                    child: Text(
                      _getErrorText(),
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Masuk!',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Aksi yang akan dijalankan saat tombol ditekan
            printUserData();
          },
          backgroundColor: Colors.grey[24],
          child: Icon(
            Icons.question_mark_rounded,
            color: Colors.deepPurpleAccent[100],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
