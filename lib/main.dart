import 'dart:io';
import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'PTSerif ',
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'PTSerif',
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
            titleLarge: const TextStyle(
                fontFamily: 'RobotoSlab',
                fontStyle: FontStyle.normal,
                fontSize: 20,
                fontWeight: FontWeight.w800),
            titleMedium: const TextStyle(
              color: Colors.blueAccent,
            )),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  final List<Transaction> _userTransaction = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;
  List<Transaction> get _recentTransaction {
    return _userTransaction.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate, String id) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: id,
    );
    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((element) => element.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar2, txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Show Chart'),
          Switch(
            value: _showChart,
            onChanged: (value) => setState(() {
              _showChart = value;
            }),
          ),
        ],
      ),
      _showChart
          ? SizedBox(
              height: (mediaQuery.size.height -
                      appBar2.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransaction),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPotraitContent(
      MediaQueryData mediaQuery, AppBar appBar2, txListWidget) {
    return [
      SizedBox(
        height: (mediaQuery.size.height -
                appBar2.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransaction),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('build() MyHomePage()');
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar2 = AppBar(
      title: const Text('Flutter App'),
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );
    final txListWidget = SizedBox(
      height: (mediaQuery.size.height -
              appBar2.preferredSize.height -
              mediaQuery.padding.top) *
          0.6,
      child: TransactionList(_userTransaction, _deleteTransaction),
    );
    return Scaffold(
      appBar: appBar2,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBar2, txListWidget),
            if (!isLandscape)
              ..._buildPotraitContent(mediaQuery, appBar2, txListWidget),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () => _startAddNewTransaction(context),
              child: const Icon(Icons.add),
            ),
    );
  }
}
