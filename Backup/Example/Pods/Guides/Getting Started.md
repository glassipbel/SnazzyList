# Getting Started

This guide provides a brief overview for how to get started using `SnazzyList`.

## Creating your first list

After installing `SnazzyList`, creating a new list is easy.

### Creating a cell

Creating a new cell is simple.
First create an struct with all the data that you will need for configuring the cell, for example lets say that we have a cell with an UILabel an we need a name (String) in order to display it correctly.
Then we will create the struct like this:

```swift
struct NameCollectionViewCellConfigFile {
  var name: String
}
```

Then Create your UICollectionViewCell and implement `SnazzyCollectionCellProtocol` and implement at least `cellForItemAtIndexPath:`.

```swift
class NameCollectionViewCell: SnazzyCollectionCellProtocol {
  var titleLabel: UILabel!

  func collectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, with item: Any) {
      guard let configFile = item as? NameCollectionViewCellConfigFile else { return } // This should not happen but its safer.

      titleLabel.text = configFile.name
  }
}
```

### Creating the UI

After creating your cells, you must create a `UICollectionView`.

```swift
import UIKit
import SnazzyList

class NamesViewController: UIViewController {
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    func viewDidLoad() {
      super.viewDidLoad()

      let configFiles = getConfigFiles()
      dataSource = SnazzyCollectionViewDataSource(collectionView: collectionView, configFiles: configFiles)
      delegate = SnazzyCollectionViewDelegate(dataSource: dataSource)
    }

    private func getConfigFiles() -> [SnazzyCollectionCellConfigurator] {
      var names: ["Kevin", "Jaime", "Martin", "Nick"]

      return names.map {

        let item = NameCollectionViewCellConfigFile(name: $0)
        return SnazzyCollectionCellConfigurator(
          classType: NameCollectionViewCell.self,
          item: item,
          sizingType: .specificHeight(44.0),
          originType: .code)
      }
    }
    private var dataSource: SnazzyCollectionViewDataSource!
    private var delegate: SnazzyCollectionViewDelegate!
}
```

> **Note:** This example is done within a `UIViewController` and uses a `UICollectionViewFlowLayout`. You can use your own layout if you need advanced features!

That's it! You will see your collectionView rendering the cells perfectly!

Forget about registering cells anymore!

If you need something more complex please check the tutorial at: TODO KEV.
