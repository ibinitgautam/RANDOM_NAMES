// ignore_for_file: camel_case_types

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
/*
    
SYNTAX:

IconData <variable>

if (context.watch<Class Containing button>().button.contains(context.watch<Class Containing button>().<some action>))
{
      <variable> = Icons.<type of icon you want>;
} else {
      <variable> = Icons.<type of icon you want>;
}
    
*/

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Combinations',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 0, 47, 86)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //this value hold the track which shows on which page you are
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Switch control
    Widget pages;

    if (selectedIndex == 0) {
      pages = GeneratorPage();
    } else if (selectedIndex == 1) {
      pages = FavPage();
    } else if (selectedIndex == 2) {
      pages = AboutMe();
    } else {
      throw UnimplementedError("No Widget for $selectedIndex");
    }

    //Main Control of Application
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 550,
                destinations: [
                  //Home Page
                  NavigationRailDestination(
                      icon: Icon(Icons.home), label: Text("Home")),

                  //LIKE
                  NavigationRailDestination(
                      icon: Icon(Icons.favorite), label: Text("Favourites")),

                  //Account example : BINIT
                  NavigationRailDestination(
                      icon: Icon(Icons.account_circle), label: Text("Account"))
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  //Tracker changes according to selection
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
                child: Container(
              color: Theme.of(context).colorScheme.onSurfaceVariant,

              //switch between pages with the help of Widget page
              child: pages,
            ))
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var alphabets = context.watch<MyAppState>();
    var pair = alphabets.words;

    //adding icon for LIKE button
    IconData icon;
    if (alphabets.likeButton.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Extracted method by (ctrl + .)
            alphabetsCombinations(pair: pair),

            //padding between COMBINATIONS and Button "N E X T"
            SizedBox(height: 20),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () => {alphabets.likedWords()},
                  label: Text("L I K E"),
                  icon: Icon(icon),
                ),

                //padding between LIKE and NEXT button
                SizedBox(width: 15),

                ElevatedButton(
                    onPressed: () => {
                          //put function here
                          alphabets.combinations()
                        },
                    child: Text("N E X T")),
              ],
            )
          ],
        ),
      ),
    );
  }
}

//Function used by Homepage() created by chasngeNotifier
class MyAppState extends ChangeNotifier {
  var words = WordPair.random();
  var favWords = [];

  //Random Names Generator
  void combinations() {
    words = WordPair.random();
    notifyListeners();
  }

  //remove words
  void removeWord(var msg) {
    //print(msg);
    favWords.remove(msg);
    notifyListeners();
  }

  //Adding Another Like Button Functionality
  var likeButton = <WordPair>[];

  void likedWords() {
    if (likeButton.contains(words)) {
      likeButton.remove(words);

      if (favWords.contains(words)) {
        //To remove words which are liked accidently
        favWords.remove(words);
        //print("Removed");
      } else {}
    } else {
      likeButton.add(words);

      //adding LIKED words
      favWords.add(words);
      //print(words);
    }
    notifyListeners();
  }
}

//Extracted method using (Ctrl + .)
class alphabetsCombinations extends StatelessWidget {
  const alphabetsCombinations({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    //extracting themes for ui
    final theme = Theme.of(context);

    //text ui
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.errorContainer);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asLowerCase,
            style: style,

            //Semantic view of word combinations so formed!
            semanticsLabel: "${pair.first} ${pair.second}"),
      ),
    );
  }
}

//Favourite Page
class FavPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favWords.isEmpty) {
      return Scaffold(
          body: Center(
        child: Text('No favorites yet.'),
      ));
    }

    return Scaffold(
        body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favWords.length} favorites:'),
        ),
        for (var pair in appState.favWords)
          ListTile(
            leading: IconButton(
                icon: Icon(Icons.delete), onPressed: () => {appState.removeWord(pair)}),
            title: Text(pair.asLowerCase),
          ),
      ],
    ));
  }
}

class AboutMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            "Hello There!\n This app is built by BINIT GAUTAM,\n Thanks for using this application."),
      ),
    );
  }
}
