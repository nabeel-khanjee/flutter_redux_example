import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(new MyApp());
@immutable
class AppState {
  final counter;
  AppState(this.counter);
}

//action
enum Action { Increment }

//it is a pure funtion
AppState reducer(AppState prev, action) {
  if (action == Action.Increment) {
    return new AppState(prev.counter+1);
  }
  return prev;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData.dark(),
      title: "FLutter Demo",
      home: new HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  final store = new Store(reducer, initialState: AppState(0));
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text("Redux App"),
          ),
          body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Text("You have push the button this many times "),
                new StoreConnector(
                  converter: (store)=> store.state.counter,
                  builder: (context, counter) => new Text("$counter"),
                )
              ],
            ),
          ),
          floatingActionButton: new StoreConnector<int,VoidCallback>(
              builder: (context, callback) => new FloatingActionButton(
                  onPressed: callback,
                  tooltip: "Increment",
                  child: new Icon(Icons.add)),
              converter: (store) {
                return () => store.dispatch(Action.Increment);
              }),
        ));
  }
}
