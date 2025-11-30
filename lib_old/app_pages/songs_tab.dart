      // songs tab content:
      DefaultTabController(
        length: songNavBar,
        // scaffold
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Your Songs',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],),
                // buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TabBar(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      tabs: [
                        Tab(icon: Icon(Icons.search), text: 'Search'),
                        Tab(icon: Icon(Icons.sort), text: 'Sort By'),
                        Tab(icon: Icon(Icons.loop), text: 'Rescan'),
                      ],
                    ),
                  ),
            ]),
            Expanded(child: TabBarView(children: songTabContents)),
          ],
        ),
      ),
ElevatedButton(
  onPressed: () => print('Button pressed!'),
  child: Text('Click me!')
)

ElevatedButton(
  style: ElevatedButton.styleFrom(
    primary: Colors.blue, // Set the primary color to blue
    onPrimary: Colors.white, // Set the text color to white
    textStyle: TextStyle(fontSize: 16), // Set the font size to 16
  ),
  onPressed: () => print('Button pressed!'),
  child: Text('Click me!')
)
