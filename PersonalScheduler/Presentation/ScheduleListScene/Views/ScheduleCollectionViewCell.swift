//
//  ScheduleCollectionViewCell.swift
//  PersonalScheduler
//
//  Created by 천수현 on 2023/01/11.
//

import UIKit

final class ScheduleCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: ScheduleCollectionViewCell.self)


    override var isSelected: Bool {
        didSet {
            if isSelected {
                descriptionLabel.numberOfLines = 0
            } else {
                descriptionLabel.numberOfLines = 2
            }
            layoutIfNeeded()
        }
    }

    private let stateBar: UIView = {
        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.layer.cornerRadius = 2.5
        return bar
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        return label
    }()

    private let startTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let endTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUpContents(section: ScheduleListViewController.ScheduleSection, schedule: Schedule) {
        titleLabel.text = schedule.title
        descriptionLabel.text = schedule.description
        let isStartEndSameDay = Calendar.current.isDate(schedule.startDate, inSameDayAs: schedule.endDate)
        startTimeLabel.text = schedule.startDate.toString(isStartEndSameDay: isStartEndSameDay)
        endTimeLabel.text = schedule.endDate.toString(isStartEndSameDay: isStartEndSameDay)
        stateBar.backgroundColor = section.stateColor
    }

    private func layout() {
        [stateBar, titleLabel, descriptionLabel, startTimeLabel, endTimeLabel].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            stateBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stateBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stateBar.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            stateBar.widthAnchor.constraint(equalToConstant: 5),

            titleLabel.leadingAnchor.constraint(equalTo: stateBar.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: startTimeLabel.leadingAnchor, constant: -5),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            descriptionLabel.trailingAnchor.constraint(equalTo: startTimeLabel.leadingAnchor, constant: -5),

            startTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            startTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            endTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            endTimeLabel.topAnchor.constraint(equalTo: startTimeLabel.bottomAnchor, constant: 10),
            endTimeLabel.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
        ])
        startTimeLabel.setContentHuggingPriority(.required, for: .horizontal)
        endTimeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}

fileprivate extension Date {
    func toString(isStartEndSameDay: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "US")
        if !isStartEndSameDay {
            dateFormatter.dateFormat = "M / d hh:mm a"
        } else {
            dateFormatter.dateFormat = "hh:mm a"
        }
        return dateFormatter.string(from: self)
    }
}