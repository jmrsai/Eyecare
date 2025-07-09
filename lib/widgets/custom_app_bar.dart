// Incorrect (old syntax for default value and missing braces):
void myFunction({String name: 'Default'}) { ... }

// Correct:
void myFunction({String name = 'Default'}) { ... }

// If it's a constructor:
// Incorrect:
MyWidget({Key key, required this.title: 'Default Title'});

// Correct:
MyWidget({super.key, required this.title = 'Default Title'});