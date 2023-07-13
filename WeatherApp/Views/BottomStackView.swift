//
//  BottomStackView.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/12/23.
//

import UIKit

class BottomStackView: UIStackView {
    let cityTextField: UITextField
    let dateLabel: UILabel
    let bottomWeatherTempInfoStackView = UIStackView()
    let minTempLabel: UILabel
    let maxTempLabel: UILabel
    let humidityLabel: UILabel

    init() {
        self.cityTextField = UITextField()
        self.dateLabel = UILabel()
        self.minTempLabel = UILabel()
        self.maxTempLabel = UILabel()
        self.humidityLabel = UILabel()

        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        alignment = .center
        spacing = 15

        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        cityTextField.font = UIFont.systemFont(ofSize: 45)
        cityTextField.textAlignment = .center
        cityTextField.textColor = UIColor.gray
        cityTextField.isUserInteractionEnabled = true
        cityTextField.placeholder = "Enter city"
        cityTextField.borderStyle = .roundedRect

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)

        // bottomWeatherInfoStackView - min, max temp + humidity labels
        bottomWeatherTempInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomWeatherTempInfoStackView.axis = .horizontal
        bottomWeatherTempInfoStackView.alignment = .center
        bottomWeatherTempInfoStackView.spacing = 15

        minTempLabel.translatesAutoresizingMaskIntoConstraints = false
        minTempLabel.font = UIFont.preferredFont(forTextStyle: .title2)

        maxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTempLabel.font = UIFont.preferredFont(forTextStyle: .title2)

        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        humidityLabel.font = UIFont.preferredFont(forTextStyle: .title2)
    }
    
    private func setupLayout() {
        addArrangedSubview(cityTextField)
        addArrangedSubview(dateLabel)
        addArrangedSubview(bottomWeatherTempInfoStackView)
        bottomWeatherTempInfoStackView.addArrangedSubview(minTempLabel)
        bottomWeatherTempInfoStackView.addArrangedSubview(maxTempLabel)
        addArrangedSubview(humidityLabel)
    }
}
