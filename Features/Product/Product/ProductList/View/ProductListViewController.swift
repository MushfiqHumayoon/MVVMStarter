//
//  ProductListViewController.swift
//  Product
//
//  Created by Mushfiq Humayoon on 31/08/23.
//

import DesignKit
import RepoKit

class ProductListViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - ViewModel
    lazy var viewModel: ProductViewModel = {
        let repository = Dependencies.shared.productModule.repository
        return ProductViewModel(repo: repository)
    }()
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        initBindings()
    }
    private func initBindings() {
        viewModel.productList.addObserver { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    // MARK: - Setup Table View
    private func setupTableView() {
        let cellNib = UINib(nibName: ProductViewCell.viewIdentifier(), bundle: AppBundle.product)
        tableView.register(cellNib, forCellReuseIdentifier: ProductViewCell.viewIdentifier())
    }
}
// MARK: - Table View Data Source
extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.productList.value.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewCell.viewIdentifier()) as? ProductViewCell else { return UITableViewCell() }
        cell.labelText.text = viewModel.productList.value[indexPath.row]
        return cell
    }
}
