import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:love_calculator/models/entities/ResponseEntity.dart';
import 'package:love_calculator/viewmodels/HomeViewModel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final _yourNameController = TextEditingController();
  final _yourFriendNameController = TextEditingController();
  final _homeViewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    _homeViewModel.getPercentageStream().listen((event) {
      _showDialog(event);
    });
    _homeViewModel.getLoadingStream().listen((event) {
      _changeLoadingState(event);
    });
    _homeViewModel.errorStream().listen((event) {
      _showError(event);
    });
    _homeViewModel.invalidNameStream().listen((event) {
      ValidateName state = event;
      switch (state) {
        case ValidateName.INVALID_YOUR_FRIEND_NAME:
          Fluttertoast.showToast(msg: "Please input your girl/boy friend name", toastLength: Toast.LENGTH_SHORT);
          break;
        case ValidateName.INVALID_YOUR_NAME:
          Fluttertoast.showToast(msg: "Please input your name", toastLength: Toast.LENGTH_SHORT);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _homeViewModel,
      child: Selector<HomeViewModel, ResponseEntity>(
        selector: (context, homeViewModel) => homeViewModel.responseEntityObs,
        builder: (context, viewState, _) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: TextField(
                      style: const TextStyle(fontSize: 16),
                      autofocus: false,
                      controller: _yourNameController,
                      decoration: const InputDecoration(hintText: "Input your name"),
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: TextField(
                      style: const TextStyle(fontSize: 16),
                      autofocus: false,
                      controller: _yourFriendNameController,
                      decoration: const InputDecoration(hintText: "Input your girl/boy friend name"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _onOkClick(),
                      child: const Text(
                        "OK",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _onOkClick() {
    if (_homeViewModel.validateInput(_yourNameController.text, _yourFriendNameController.text)) {
      _homeViewModel.getPercentage(_yourNameController.text, _yourFriendNameController.text);
    }
  }

  @override
  void dispose() {
    _yourFriendNameController.dispose();
    _yourNameController.dispose();
    super.dispose();
  }

  void _showDialog(ResponseEntity result) {
    showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Calculate result'),
              content: SizedBox(
                height: 45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Match percentage: ${result.percentage}%",
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(result.result.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                    FocusScope.of(context).unfocus();
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  void _changeLoadingState(bool isLoading) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Loading"),
                ],
              ),
            ),
          );
        },
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
