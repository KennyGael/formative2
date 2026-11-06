class DemoReport {
  final String title;
  final String description;
  final String category;
  final String location;
  const DemoReport(this.title, this.description, this.category, this.location);
}

const demoReports = [
  DemoReport(
    'Library Wi-Fi keeps dropping',
    'The Wi-Fi disconnects every few minutes in the study area, which makes it hard to attend online classes or submit assignments.',
    'facilities',
    'Library, 2nd floor',
  ),
  DemoReport(
    'Broken chairs in Lecture Hall 3',
    'At least five chairs in the back rows have broken backs or loose legs and are not safe to sit on.',
    'facilities',
    'Lecture Hall 3',
  ),
  DemoReport(
    'Flickering lights in Computer Lab 2',
    'The ceiling lights flicker constantly, causing eye strain and headaches during long lab sessions.',
    'electricity',
    'Computer Lab 2',
  ),
  DemoReport(
    'Blocked fire exit at Block C',
    'Stacked boxes are blocking the emergency exit door. This is dangerous in case of a fire or an evacuation.',
    'safety',
    'Block C, ground floor',
  ),
  DemoReport(
    'Leaking tap in Block A restrooms',
    'A tap has been leaking nonstop since Monday and the floor around the sink is always wet and slippery.',
    'water',
    'Block A, restrooms',
  ),
  DemoReport(
    'Clogged drain near the cafeteria',
    'Dirty water collects at the entrance after every rain and gives off a strong smell.',
    'sanitation',
    'Cafeteria entrance',
  ),
  DemoReport(
    'Streetlight out on the hostel path',
    'The streetlight has been out for two weeks, so the path is very dark and unsafe to walk at night.',
    'safety',
    'Path to student hostels',
  ),
];
