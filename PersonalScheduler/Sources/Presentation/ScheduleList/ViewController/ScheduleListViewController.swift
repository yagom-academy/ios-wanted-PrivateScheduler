//
//  ScheduleListViewController.swift
//  PersonalScheduler
//
//  Created by Ari on 2023/01/10.
//

import UIKit
import Combine

class ScheduleListViewController: UIViewController {
    
    public weak var coordinator: ScheduleListCoordinatorInterface?
    
    private let viewModel: ScheduleListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    init(viewModel: ScheduleListViewModel, coordinator: ScheduleListCoordinatorInterface) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
