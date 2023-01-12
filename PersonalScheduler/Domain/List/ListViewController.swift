//
//  ListViewController.swift
//  PersonalScheduler
//
//  Created by 우롱차 on 2023/01/12.
//

import UIKit

final class ListViewController: UIViewController {
    
    static func instance(userId: String) -> ListViewController {
        let viewModel = ListViewModel(userId: userId)
        let viewController = ListViewController(viewModel: viewModel)
        return viewController
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Schedule>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Schedule>
    
    enum Section: Hashable {
        case scheduleSection
    }
    
    private let viewModel: ListViewModelAble
    private lazy var dataSource = createDataSource()
    
    private lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: .zero)
        tabelView.backgroundColor = .gray
        return tabelView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "스케줄 목록"
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .black
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(textStyle: .title1, scale: .large)
        let image = UIImage(systemName: "plus.circle")?.withConfiguration(config)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(addButtonClicked(_:)), for: .touchUpInside)
        
        return button
    }()
    
    init(viewModel: ListViewModelAble) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setUp()
        bind()
    }
    
    private func setUp() {
        view.backgroundColor = .white
        view.addSubviews(tableView, titleLabel, addButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    private func bind() {
        viewModel.errorMessage.observe(on: self) { [weak self] errorMessage in
            guard let errorMessage = errorMessage else {
                return
            }
            self?.showErrorAlert(message: errorMessage)
        }
        viewModel.scheduls.observe(on: self) { [weak self] schedulArray in
            if let schedulArray = schedulArray {
                self?.applySnapshot(models: schedulArray)
            }
        }
    }
    
    private func createDataSource() -> DataSource {
        let datasource =
        DataSource(tableView: self.tableView) {
            tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.identifier, for: indexPath) as? ListViewCell else {
                return UITableViewCell()
            }
            cell.configureCell(itemIdentifier, row: indexPath.row)
            return cell
        }
        return datasource
    }
    
    private func applySnapshot(models: [Schedule]) {
        var snapShot = Snapshot()
        snapShot.appendSections([.scheduleSection])
        snapShot.appendItems(models)
        dataSource.apply(snapShot)
    }
    
    @objc private func addButtonClicked(_: UIBarButtonItem) {
        let viewController = DetailViewController.instance(
            mode: .add,
            userId: viewModel.userId,
            schedule: nil
        )
        viewController.modalPresentationStyle = .formSheet
        present(viewController, animated: true)
    }
    
}
