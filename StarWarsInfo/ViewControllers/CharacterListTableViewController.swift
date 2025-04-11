/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class CharacterListTableViewController: UITableViewController {
  var networkClient = StarWarsAPINetworklClient()
  var viewModel: CharacterListViewModel!
  @IBOutlet weak var emptyStateLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.accessibilityIdentifier = AccessibilityIdentifiers.characterListTable
    viewModel = CharacterListViewModel(networkClient: networkClient,
                                       delegate: self)
    emptyStateLabel.isAccessibilityElement = true
    viewModel.requestCharacterList()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard
      let viewController = segue.destination as? CharacterDetailViewController,
      let selectedIndexPath = tableView.indexPathForSelectedRow
      else {
        fatalError("Incorrect destination viewcontroller or selectedIndexPath received")
    }
    
    let character = viewModel.character(for: selectedIndexPath)
    viewController.character = character
  }
}

// MARK: - UITableViewDataSource
extension CharacterListTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfCharacters()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as? CharacterTableViewCell else {
      fatalError("Invalid cell type received")
    }
    
    let character = viewModel.character(for: indexPath)
    cell.configure(with: character)
    
    return cell
  }
  
}

extension CharacterListTableViewController: CharacterListViewModelDelegate {
  func characterListFailedToLoad(with error: any Error) {
    let alert = UIAlertController(
      title: "Error",
      message: "Failed to load characters.",
      preferredStyle: .alert
    )
    
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    
    present(alert, animated: true)
  }

  func characterListWasUpdated(withCharacters characters: [StarWarsCharacter]) {
    print("🧪 characters.count: \(characters.count)")
    print("🧪 emptyStateLabel before: \(emptyStateLabel.isHidden)")
    
    if characters.isEmpty {
      emptyStateLabel.isHidden = false
      tableView.isHidden = true
    } else {
      emptyStateLabel.isHidden = true
      tableView.isHidden = false
    }

    tableView.reloadData()
    print("🧪 emptyStateLabel after: \(emptyStateLabel.isHidden)")
  }



}
