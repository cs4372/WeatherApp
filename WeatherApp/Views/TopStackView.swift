//
//  TopStackView.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/12/23.
//

import UIKit

class TopStackView: UIStackView {
    let topWeatherStackView: UIStackView
    let temperatureLabel: UILabel
    let weatherDescriptionLabel:UILabel
    let weatherImageView: UIImageView
    
    init() {
        self.topWeatherStackView = UIStackView()
        self.temperatureLabel = UILabel()
        self.weatherDescriptionLabel = UILabel()
        self.weatherImageView = UIImageView()
        
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        spacing = 10
        alignment = .top
        
        topWeatherStackView.translatesAutoresizingMaskIntoConstraints = false
        topWeatherStackView.axis = .vertical
        topWeatherStackView.spacing = 10
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.systemFont(ofSize: 60)
        temperatureLabel.tintColor = .label
        
        weatherDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.image = UIImage(systemName: "sun.max")
        weatherImageView.tintColor = .label
        weatherImageView.contentMode = .scaleAspectFill
    }
    
    private func setupLayout() {
        addArrangedSubview(topWeatherStackView)
        addArrangedSubview(weatherImageView)
        
        topWeatherStackView.addArrangedSubview(temperatureLabel)
        topWeatherStackView.addArrangedSubview(weatherDescriptionLabel)
        
        NSLayoutConstraint.activate([
            weatherImageView.heightAnchor.constraint(equalToConstant: 100),
            weatherImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
