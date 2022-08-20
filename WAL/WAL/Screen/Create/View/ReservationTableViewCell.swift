//
//  ReservationTableViewCell.swift
//  WAL
//
//  Created by 배은서 on 2022/05/08.
//

import UIKit

import Then
import WALKit

struct DatePickerData {
    var date: Date?
    var time: Date?
    var didShowView = (date: false, time: false)
}

class ReservationTableViewCell: UITableViewCell {
    static var cellIdentifier: String { return String(describing: self) }
    
    // MARK: - Properties
    
    private let reservationTimeLabel = UILabel().then {
        $0.text = "예약 시간"
        $0.font = WALFont.body4.font
        $0.textColor = .black100
    }
    
    private lazy var dateButton = UIButton().then {
        $0.addTarget(self, action: #selector(touchUpDateButton), for: .touchUpInside)
    }
    
    private lazy var timeButton = UIButton().then {
        $0.addTarget(self, action: #selector(touchUpTimeButton), for: .touchUpInside)
    }
    
    private let dateFormatter = DateFormatter()
    
    var touchedDateButton: (() -> ())?
    var touchedTimeButton: (() -> ())?
    
    // MARK: - Initializer
    
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
        
        [dateButton, timeButton].forEach {
            var config = UIButton.Configuration.plain()
            config.baseForegroundColor = .gray200
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
                var title = $0
                title.font = WALFont.body6.font
                return title
            }
            $0.configuration = config
            $0.backgroundColor = .white100
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
        }
        
        dateButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 24, bottom: 7, trailing: 24)
        timeButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 14, bottom: 7, trailing: 14)
    }
    
    private func setupLayout() {
        contentView.addSubviews([reservationTimeLabel,
                                 dateButton,
                                 timeButton])
        
        reservationTimeLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(18)
        }
        
        dateButton.snp.makeConstraints {
            $0.centerY.equalTo(reservationTimeLabel)
        }
        
        timeButton.snp.makeConstraints {
            $0.leading.equalTo(dateButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(9)
            $0.centerY.equalTo(reservationTimeLabel)
        }
    }
    
    //MARK: - @objc
    
    @objc private func touchUpDateButton() {
        touchedDateButton?()
    }
    
    @objc private func touchUpTimeButton() {
        touchedTimeButton?()
    }
    
    //MARK: - Custom Method
    
    func setup(data: DatePickerData) {
        var components = DateComponents()
        components.day = 1
        guard let tomorrow = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date()) else { return }
        
        dateFormatter.dateFormat = "yyyy. MM. dd"
        dateButton.setTitle(dateFormatter.string(from: data.date ?? tomorrow), for: .normal)
        dateButton.layer.borderColor = data.didShowView.date ? UIColor.mint100.cgColor : UIColor.white100.cgColor
        dateButton.configuration?.baseForegroundColor = data.didShowView.date || data.date != nil ? UIColor.black100 : UIColor.gray200
        
        dateFormatter.dateFormat = "a hh:mm"
        timeButton.setTitle(dateFormatter.string(from: data.time ?? Date()), for: .normal)
        timeButton.layer.borderColor = data.didShowView.time ? UIColor.mint100.cgColor : UIColor.white100.cgColor
        timeButton.configuration?.baseForegroundColor = data.didShowView.time || data.time != nil ? .black100 : .gray200
    }
}
