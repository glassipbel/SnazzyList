# Best Practices and FAQs

This guide provides notes and details on best practices in using `SnazzyList`, general tips, and answers to FAQs.

## Best Practices

### Naming your ConfigFiles:
We strongly recommend that the configFiles should be named after the name of the cell that they are going to configure and adding 'ConfigFile' at the end of the name.  
For example if you have a cell with name `PersonCollectionViewCell`  
Then the configFile should be named: `PersonCollectionViewCellConfigFile`  

### Location of your ConfigFiles:
The best place to create the struct would be in the same file of your cell at the bottom of it:

For example: `PersonCollectionViewCell.swift`

```swift
// Swift
class PersonCollectionViewCell: UICollectionViewCell {
  let label: UILabel!

  /*
  .
  .
  ...
  */
}

struct PersonCollectionViewCellConfigFile {
  var name: String
}
```

### Creating your ConfigFiles:
In case that you need to do some operations in order to create your configFiles we recommend creating a controller for those operations with a method as `getConfigFiles()` for retrieving all the configFiles.

For example: `PersonController.swift`

```swift
// Swift
class PersonController {
  func getConfigFiles(people: [Person]) -> [SnazzyCollectionCellConfigurator] {
    return people.map { self.getPersonConfigFile($0) }
  }

  private func getPersonConfigFile(person: Person) -> SnazzyCollectionCellConfigurator {
    let item = PersonCollectionViewCellConfigFile(name: person.name)
    return SnazzyCollectionCellConfigurator(
      classType: PersonCollectionViewCell.self,
      item: item,
      sizingType: .specificHeight(44.0),
      originType: .xib)
  }

  private func retrievePeopleFromInternet(completion: @escaping ([Person])->()) {
    //Pseudo class.
    methodThatGoesToInternetAndRetrieveUsers { users in
      completion(users)
    }
  }
}

struct PersonCollectionViewCellConfigFile {
  var name: String
}
```

### Callbacks for your cell actions:
In case that you need to do some actions after a user taps on a cell then handling it in SnazzyList is super easy!
You should follow these steps:

#### First create a protocol with all the callbacks that you need from your cells:
Let's imagine that you have 2 cells one with a button for send a message and another one with a button for delete user.
Then our protocol would have those methods.

```swift
// Swift
protocol PeopleCallbacksDelegate {
  func tapSendMessage(person: Person)
  func tapDelete(person: Person)
}
```

#### Second implement in your viewController the recently created protocol:

```swift
// Swift
class PeopleViewController: UIViewController {
  var collectionView: UICollectionView!

  /*
  .
  .
  ...
  */
}

extension PeopleViewController: PeopleCallbacksDelegate {
  func tapSendMessage(person: Person) {
    //TODO. Open another view controller..
  }
  func tapDelete(person: Person) {
    //TODO. Delete the person.
  }
}
```

#### Third in your ConfigFiles you should have a reference of those methods:

```swift
// Swift
class DeleteCollectionViewCell: UICollectionViewCell, SnazzyCollectionCellProtocol {

  func collectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, with item: Any) {
      guard let configFile = item as? DeleteCollectionViewCellConfigFile else { return } // This should not happen but its safer.
      self.configFile = configFile
  }

  func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.configFile.tapDeletePerson(self.configFile.person)
  }

  fileprivate var configFile: DeleteCollectionViewCellConfigFile!
}

struct DeleteCollectionViewCellConfigFile {
  var person: Person
  var tapDeletePerson: (Person)->()
}
```

#### Forth in your controller you should create the cells with those callbacks attached:

```swift
// Swift
class PeopleController {

  init(callbacks: PeopleCallbacksDelegate) {
    self.callbacks = callbacks
  }

  func getConfigFiles() -> [SnazzyCollectionCellConfigurator] {
    let people: [Person] = [Person(name: "Kevin"), Person(name: "Nick"), Person(name: "Jaime"), Person(name: "Dingo")]

    return people.map { getDeleteConfigFile($0) }
  }

  private func getDeleteConfigFile(person: Person) -> SnazzyCollectionCellConfigurator {
    let item = DeleteCollectionViewCellConfigFile(person: person, tapDeletePerson: callbacks.tapDelete)

    return SnazzyCollectionCellConfigurator(
      classType: DeleteCollectionViewCell.self,
      item: item,
      sizingType: .specificHeight(60.0),
      originType: .code)
  }

  private callbacks: PeopleCallbacksDelegate
}
```
#### Fifth finally in your `UIViewController` use the controller to get the configFiles:

```swift
// Swift
class PeopleViewController: UIViewController {
  var collectionView: UICollectionView!

  func viewDidLoad() {
    super.viewDidLoad()

    setDataSourceAndDelegate()
  }

  private func setDataSourceAndDelegate() {

    let controller = PeopleController(callbacks: self)

    let configFiles = controller.getConfigFiles()
    dataSource = SnazzyCollectionViewDataSource(collectionView: collectionView, configFiles: configFiles)
    delegate = SnazzyCollectionViewDelegate(dataSource: dataSource)
  }

  fileprivate var dataSource: SnazzyCollectionViewDataSource!
  fileprivate var delegate: SnazzyCollectionViewDelegate!
}

extension PeopleViewController: PeopleCallbacksDelegate {
  func tapSendMessage(person: Person) {
    //TODO. Open another view controller..
  }
  func tapDelete(person: Person) {
    //TODO. Delete the person.
  }
}
```

*That's it!*
