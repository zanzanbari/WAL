//
//  DatePickerTableViewCell.swift
//  WAL
//
//  Created by 배은서 on 2022/05/08.
//

import UIKit

import Then
import WALKit

enum DatePickerType {
    case date
    case time
    case none
}

class DatePickerTableViewCell: UITableViewCell {
    static var cellIdentifier: String { return String(describing: self) }
    
    //MARK: - Properties
    
    var reservedDates: [String] = []
    
    private lazy var datePicker = UIDatePicker().then {
        $0.tintColor = .mint100
        $0.locale = Locale(identifier: "ko-KR")
        $0.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        $0.addTarget(self, action: #selector(handleDatePickerTap), for: .editingDidBegin)
    }
    
    var datePickerType: DatePickerType = .none {
        didSet {
            switch datePickerType {
            case .date:
                datePicker.preferredDatePickerStyle = .inline
                datePicker.datePickerMode = .date
                
                var components = DateComponents()
                components.day = 90
                let maxDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
                components.day = 1
                let minDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())

                datePicker.maximumDate = maxDate
                datePicker.minimumDate = minDate

                datePicker.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview().inset(16)
                }
            case .time:
                datePicker.preferredDatePickerStyle = .wheels
                datePicker.datePickerMode = .time
                datePicker.subviews[0].subviews[1].backgroundColor = .clear
                datePicker.subviews[0].subviews[1].layer.borderColor = UIColor.mint100.cgColor
                datePicker.subviews[0].subviews[1].layer.borderWidth = 1

                datePicker.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview().inset(6)
                }
            case .none: return
            }
        }
    }
    
    //MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func configUI() {
        contentView.backgroundColor = .gray600
    }
    
    private func setupLayout() {
        contentView.addSubview(datePicker)
        
        datePicker.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
        }
    }
    
    var sendDate: ((_ date: Date, _ didShowToastMessage: Bool) -> ())?
    
    //MARK: - @objc
    
    @objc private func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var selectedDate = datePicker.date
        
        if datePickerType == .date, reservedDates.contains(dateFormatter.string(from: selectedDate)) {
            selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            sendDate?(selectedDate, true)
        } else {
            sendDate?(selectedDate, false)
        }
    }
    
    @objc func handleDatePickerTap() {
        datePicker.resignFirstResponder()
    }
    
    //MARK: - Custom Method
    
    func setup(date: DatePickerData) {
        switch datePickerType {
        case .date: datePicker.date = date.date ?? Date()
        case .time: datePicker.date = date.time ?? Date()
        case .none: return
        }
    }
}
