# scroll_shadow

## Usage

```dart
class _MyHomePageState extends State<MyHomePage> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollShadow(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                color: Colors.orange,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                color: Colors.purple,
              )
            ],
          ),
        ),
      ),
    );
  }
}
```
