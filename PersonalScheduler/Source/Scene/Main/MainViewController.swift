//
//  MainViewController.swift
//  PersonalScheduler
//
//  Created by Dragon on 23/02/06.
//

import UIKit
import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

class MainViewController: UIViewController {
    
    let listView = ListView()
    var scheduleList: [Schedule] = [] {
        didSet {
            listView.reloadTableViewData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        listView.configureTableView(with: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        checkLogin()
    }
    
    private func checkLogin() {
        if Auth.auth().currentUser?.uid == nil {
            let presentViewController = LoginViewController()
            
            navigationController?.present(presentViewController, animated: true)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Personal Scheduler"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .actions,
            style: .done,
            target: self,
            action: #selector(tapRightBarButton)
        )
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "취소",
            style: .done,
            target: self,
            action: #selector(tapBackBarButton)
        )
    }
    
    private func configureLayout() {
        view.addSubview(listView)
        
        listView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            listView.widthAnchor.constraint(equalTo: view.widthAnchor),
            listView.heightAnchor.constraint(equalTo: view.heightAnchor),
            listView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            listView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc
    private func tapRightBarButton() {
        let presentViewController = LoginViewController()
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        presentViewController.toggleFacebookLoginButton()
        
        self.navigationController?.present(presentViewController, animated: true)
    }
    
    @objc
    private func tapAddButton() {
        let pushViewController = ScheduleInfoViewController()
        
        pushViewController.mode = .create
        pushViewController.delegate = self
        
        navigationController?.pushViewController(pushViewController, animated: true)
    }
    
    @objc
    private func tapBackBarButton() {
        dismiss(animated: true)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            scheduleList.remove(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pushViewController = ScheduleInfoViewController()
        
        pushViewController.mode = .read
        pushViewController.delegate = self
        
        navigationController?.pushViewController(pushViewController, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: ListTableViewCell.identifier,
            for: indexPath) as? ListTableViewCell {
            let data = scheduleList[indexPath.row]
            
            cell.configureLabelText(schedule: data)
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension MainViewController: DataSendable {
    func sendData(with data: Schedule, mode: ManageMode) {
        switch mode {
        case .create:
            scheduleList.append(data)
        case .edit:
            break
        case .read:
            break
        }
    }
}