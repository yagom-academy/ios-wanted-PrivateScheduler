//
//  ScheduleListTableViewCell.swift
//  PersonalScheduler
//
//  Created by Judy on 2023/01/10.
//

import UIKit

final class ScheduleListTableViewCell: UITableViewCell {
    static let identifier = "ScheduleListTableViewCell"
    
    private let highlightView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.7264262438, green: 0.9996786714, blue: 0.5089451671, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ScheduleImage.notifyingBell
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.font = .boldSystemFont(ofSize: label.font.pointSize)
        label.textColor = .label
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scheduleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func congigure(with schedule: Schedule) {
        titleLabel.text = schedule.title
        contentLabel.text = schedule.content
        changeBellImage(schedule.isNotified)
        changeHighlight(schedule.endTime)
    }
    
    private func changeBellImage(_ isNotified: Bool) {
        if isNotified {
            bellImageView.image = ScheduleImage.notifyingBell
        } else {
            bellImageView.image = ScheduleImage.unnotifyingBell
        }
    }
    
    private func changeHighlight(_ endTime: Date) {
        if Date() > endTime {
            highlightView.backgroundColor = .systemGray
        } else {
            highlightView.backgroundColor = #colorLiteral(red: 0.7264262438, green: 0.9996786714, blue: 0.5089451671, alpha: 1)
        }
    }
    
    private func setupView() {
        addSubView()
        setupConstraint()
    }
    
    private func addSubView() {
        scheduleStackView.addArrangedSubview(titleLabel)
        scheduleStackView.addArrangedSubview(contentLabel)

        entireStackView.addArrangedSubview(bellImageView)
        entireStackView.addArrangedSubview(scheduleStackView)
        
        self.contentView.addSubview(highlightView)
        self.contentView.addSubview(entireStackView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            highlightView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            highlightView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            highlightView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            
            entireStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                constant: 16),
            entireStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                    constant: -16),
            entireStackView.leadingAnchor.constraint(equalTo: highlightView.trailingAnchor,
                                                     constant: 8),
            entireStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                      constant: -8),
            
            bellImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor,
                                                 multiplier: 1/10),
            
            highlightView.widthAnchor.constraint(equalTo: bellImageView.widthAnchor,
                                                 multiplier: 1/3)
        ])
    }
}


enum ScheduleImage {
    static let notifyingBell = UIImage(systemName: "bell.circle.fill")
    static let notifiedBell = UIImage(systemName: "bell.circle")
    static let unnotifyingBell = UIImage(systemName: "bell.slash.circle.fill")
    static let add = UIImage(systemName: "plus")
}